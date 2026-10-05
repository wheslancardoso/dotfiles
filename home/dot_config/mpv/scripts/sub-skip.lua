-- ==============================================================================
-- 🚀 Sub-Skip & Silence Accelerator — Motor de Imersão em Inglês com Pre-Roll (Lead-In)
-- ==============================================================================
-- Monitora os diálogos na legenda e elimina o tempo ocioso com desaceleração inteligente:
-- - Diálogo ativo: Toca na velocidade normal/estudo (ex: 1.0x ou 1.25x).
-- - Lead-In inteligente: Desacelera 1.2s ANTES da fala começar (nunca entra em cima da fala!).
-- - Lead-Out: Mantém 0.5s após a fala antes de acelerar.
-- - Silêncio / Sem fala: Acelera para 2.5x (ou pula para 1.2s antes da próxima fala).
-- ==============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'
local msg = require 'mp.msg'

local ENABLED = false
local MODE = "speedup" -- "speedup" (acelera no silêncio) ou "skip" (salta direto)
local FAST_SPEED = 2.5
local USER_NORMAL_SPEED = 1.0
local IN_DIALOGUE = true

-- Parâmetros de Conforto Auditivo
local LEAD_IN = 1.2      -- Desacelera 1.2 segundos ANTES da fala começar
local LEAD_OUT = 0.5     -- Mantém velocidade normal por 0.5s após a fala
local MIN_SILENCE = 2.2  -- Só acelera se o silêncio durar pelo menos 2.2 segundos

local sub_intervals = {}
local loaded_sub_file = nil

local function show_osd(text)
    mp.osd_message("⚡ [Imersão Inglês] " .. text, 3.0)
end

local function apply_speed(target_speed)
    local current_speed = mp.get_property_number("speed", 1.0)
    if math.abs(current_speed - target_speed) > 0.05 then
        mp.set_property_number("speed", target_speed)
    end
end

-- ==============================================================================
-- 📑 Parser Ultrarrápido de Legendas (.srt, .vtt, .ass)
-- ==============================================================================
local function parse_subtitle_file(file_path)
    if not file_path or file_path == "" then return false end
    local f = io.open(file_path, "r")
    if not f then return false end

    local intervals = {}
    local is_ass = file_path:match("%.ass$") or file_path:match("%.ssa$")

    for line in f:lines() do
        if is_ass then
            -- Formato ASS: Dialogue: 0,1:23:45.67,1:23:48.91,...
            local h1, m1, s1, ms1, h2, m2, s2, ms2 = line:match("Dialogue:%s*.-,(%d+):(%d+):(%d+)[,.](%d+),(%d+):(%d+):(%d+)[,.](%d+)")
            if h1 then
                local st = tonumber(h1)*3600 + tonumber(m1)*60 + tonumber(s1) + tonumber(ms1)/100
                local et = tonumber(h2)*3600 + tonumber(m2)*60 + tonumber(s2) + tonumber(ms2)/100
                if et > st then
                    table.insert(intervals, { start_t = st, end_t = et })
                end
            end
        else
            -- Formato SRT / VTT: 01:23:45,678 --> 01:23:48,910
            local h1, m1, s1, ms1, h2, m2, s2, ms2 = line:match("(%d+):(%d+):(%d+)[,.](%d+)%s*%-%-%>%s*(%d+):(%d+):(%d+)[,.](%d+)")
            if not h1 then
                -- VTT curto: 23:45.678 --> 23:48.910
                local m_1, s_1, ms_1, m_2, s_2, ms_2 = line:match("(%d+):(%d+)[,.](%d+)%s*%-%-%>%s*(%d+):(%d+)[,.](%d+)")
                if m_1 then
                    h1, m1, s1, ms1 = 0, m_1, s_1, ms_1
                    h2, m2, s2, ms2 = 0, m_2, s_2, ms_2
                end
            end

            if h1 then
                local st = tonumber(h1)*3600 + tonumber(m1)*60 + tonumber(s1) + tonumber(ms1)/1000
                local et = tonumber(h2)*3600 + tonumber(m2)*60 + tonumber(s2) + tonumber(ms2)/1000
                if et > st then
                    table.insert(intervals, { start_t = st, end_t = et })
                end
            end
        end
    end
    f:close()

    if #intervals > 0 then
        -- Ordena por tempo de início
        table.sort(intervals, function(a, b) return a.start_t < b.start_t end)
        sub_intervals = intervals
        loaded_sub_file = file_path
        msg.info(string.format("Sub-Skip: Carregados %d intervalos de legenda com antecedência (Lead-In %.1fs)", #intervals, LEAD_IN))
        return true
    end

    return false
end

-- Tenta identificar e carregar a legenda ativa
local function load_active_subtitle()
    local sid = mp.get_property_number("sid", 0)
    if sid == 0 then
        sub_intervals = {}
        loaded_sub_file = nil
        return
    end

    local tracks = mp.get_property_native("track-list", {})
    local target_sub_file = nil

    for _, track in ipairs(tracks) do
        if track.type == "sub" and track.id == sid then
            if track.external and track["external-filename"] then
                target_sub_file = track["external-filename"]
            end
            break
        end
    end

    if target_sub_file and target_sub_file ~= loaded_sub_file then
        parse_subtitle_file(target_sub_file)
    elseif not target_sub_file then
        -- Trilha interna de MKV/MP4: tenta extrair se ainda não extraiu
        local video_path = mp.get_property("path", "")
        if video_path and video_path ~= "" and not video_path:find("^%a[%a%d_]+://") then
            local temp_srt = "/tmp/mpv_sub_skip.srt"
            local ext_cmd = mp.command_native({
                name = "subprocess", playback_only = false,
                capture_stdout = false,
                args = { "ffmpeg", "-y", "-i", video_path, "-map", string.format("0:s:%d", math.max(0, sid - 1)), temp_srt }
            })
            if ext_cmd and ext_cmd.status == 0 then
                parse_subtitle_file(temp_srt)
            end
        end
    end
end

-- ==============================================================================
-- ⏱️ Verificação de Posição com Pre-Roll (Lead-In)
-- ==============================================================================
local function check_position(pos)
    if not ENABLED or not pos then return end

    local sid = mp.get_property_number("sid", 0)
    if sid == 0 then return end

    local is_paused = mp.get_property_bool("pause", false)
    if is_paused then return end

    -- Se não tiver intervalos parseados, usa fallback por texto atual
    if #sub_intervals == 0 then
        local sub_text = mp.get_property("sub-text", "")
        local has_dialogue = (sub_text ~= nil and sub_text:gsub("%s+", "") ~= "")
        if has_dialogue then
            if not IN_DIALOGUE then
                IN_DIALOGUE = true
                apply_speed(USER_NORMAL_SPEED)
            end
        else
            if IN_DIALOGUE then
                IN_DIALOGUE = false
                if MODE == "speedup" then
                    apply_speed(FAST_SPEED)
                elseif MODE == "skip" then
                    mp.commandv("sub-seek", "1")
                end
            end
        end
        return
    end

    -- Busca binária pelo primeiro intervalo onde end_t + LEAD_OUT >= pos
    local low, high = 1, #sub_intervals
    local best = nil
    while low <= high do
        local mid = math.floor((low + high) / 2)
        if sub_intervals[mid].end_t + LEAD_OUT >= pos then
            best = mid
            high = mid - 1
        else
            low = mid + 1
        end
    end

    local in_dialogue_zone = false
    local next_dialogue_start = nil

    if best then
        local cur = sub_intervals[best]
        -- Estamos dentro do intervalo (incluindo Lead-In antes e Lead-Out depois)?
        if pos >= (cur.start_t - LEAD_IN) and pos <= (cur.end_t + LEAD_OUT) then
            in_dialogue_zone = true
        else
            -- Estamos antes do Lead-In da fala atual
            next_dialogue_start = cur.start_t
            local prev_end = best > 1 and sub_intervals[best - 1].end_t or 0
            local silence_gap = cur.start_t - prev_end
            if silence_gap < MIN_SILENCE then
                -- Silêncio muito curto entre falas: mantém velocidade normal para evitar solavanco
                in_dialogue_zone = true
            end
        end
    end

    if in_dialogue_zone then
        if not IN_DIALOGUE then
            IN_DIALOGUE = true
            apply_speed(USER_NORMAL_SPEED)
        end
    else
        if IN_DIALOGUE then
            IN_DIALOGUE = false
            if MODE == "speedup" then
                apply_speed(FAST_SPEED)
            elseif MODE == "skip" and next_dialogue_start then
                -- Salto inteligente: cai exatamente LEAD_IN segundos antes da fala!
                local jump_target = math.max(0, next_dialogue_start - LEAD_IN)
                mp.set_property_number("time-pos", jump_target)
                IN_DIALOGUE = true
                apply_speed(USER_NORMAL_SPEED)
            end
        end
    end
end

-- ==============================================================================
-- 📡 Listeners & Observadores
-- ==============================================================================
local function on_time_pos_change(name, pos)
    check_position(pos)
end

local function on_speed_change(name, val)
    if not val then return end
    if IN_DIALOGUE or not ENABLED then
        USER_NORMAL_SPEED = val
    end
end

local function on_track_change()
    load_active_subtitle()
end

mp.observe_property("time-pos", "number", on_time_pos_change)
mp.observe_property("speed", "number", on_speed_change)
mp.observe_property("sid", "number", on_track_change)
mp.register_event("file-loaded", function()
    sub_intervals = {}
    loaded_sub_file = nil
    load_active_subtitle()
end)

-- ==============================================================================
-- 🎮 Atalhos e Controles
-- ==============================================================================
local function toggle()
    ENABLED = not ENABLED
    if ENABLED then
        load_active_subtitle()
        IN_DIALOGUE = true
        local current = mp.get_property_number("speed", 1.0)
        USER_NORMAL_SPEED = current
        show_osd(string.format("ATIVADO (%s | Normal: %.2fx | Silêncio: %.1fx | Antecipação: %.1fs)", 
            (MODE == "speedup" and "Acelerar" or "Pular"), USER_NORMAL_SPEED, FAST_SPEED, LEAD_IN))
        local pos = mp.get_property_number("time-pos")
        check_position(pos)
    else
        apply_speed(USER_NORMAL_SPEED)
        show_osd("DESATIVADO (Velocidade normal restaurada)")
    end
end

local function toggle_mode()
    if MODE == "speedup" then
        MODE = "skip"
        show_osd(string.format("Modo: PULAR SILÊNCIO (Salta para %.1fs antes da fala)", LEAD_IN))
    else
        MODE = "speedup"
        show_osd(string.format("Modo: ACELERAR NO SILÊNCIO (Desacelera %.1fs antes da fala)", LEAD_IN))
    end
    local pos = mp.get_property_number("time-pos")
    check_position(pos)
end

local function speed_up()
    FAST_SPEED = math.min(FAST_SPEED + 0.5, 5.0)
    show_osd(string.format("Velocidade do silêncio: %.1fx", FAST_SPEED))
    if ENABLED and not IN_DIALOGUE then
        apply_speed(FAST_SPEED)
    end
end

local function speed_down()
    FAST_SPEED = math.max(FAST_SPEED - 0.5, 1.5)
    show_osd(string.format("Velocidade do silêncio: %.1fx", FAST_SPEED))
    if ENABLED and not IN_DIALOGUE then
        apply_speed(FAST_SPEED)
    end
end

mp.add_key_binding(nil, "toggle", toggle)
mp.add_key_binding(nil, "toggle_mode", toggle_mode)
mp.add_key_binding(nil, "speed_up", speed_up)
mp.add_key_binding(nil, "speed_down", speed_down)

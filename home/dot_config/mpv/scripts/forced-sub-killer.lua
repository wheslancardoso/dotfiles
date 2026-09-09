-- ==============================================================================
-- 🛡️ Forced-Sub Killer & Smart Sub Sanitizer — Inteligência de Legendas
-- ==============================================================================
-- Resolve o problema clássico de arquivos MKV/MP4 que vêm com legendas "forçadas"
-- travadas pelo container que teimam em aparecer ou não deixam você desligar.
-- ==============================================================================

local mp = require 'mp'
local msg = require 'mp.msg'

local function is_track_forced(track)
    if not track or track.type ~= "sub" then return false end
    if track.forced then return true end
    local title = (track.title or ""):lower()
    if title:find("forced") or title:find("forçada") or title:find("forcada") then
        return true
    end
    return false
end

-- Sanitização automática ao carregar o arquivo de vídeo
local function sanitize_subtitles()
    local tracks = mp.get_property_native("track-list", {})
    local current_sid = mp.get_property_number("sid", 0)

    local clean_tracks = {}
    local forced_tracks_count = 0

    for _, track in ipairs(tracks) do
        if track.type == "sub" then
            if is_track_forced(track) then
                forced_tracks_count = forced_tracks_count + 1
            else
                table.insert(clean_tracks, track)
            end
        end
    end

    -- Se a faixa atual selecionada for "forçada", tenta trocar para uma limpa
    for _, track in ipairs(tracks) do
        if track.type == "sub" and track.id == current_sid and is_track_forced(track) then
            msg.info("Forced-Sub Killer: Trilha forçada detectada na inicialização.")
            if #clean_tracks > 0 then
                -- Seleciona a primeira trilha limpa disponível
                mp.set_property_number("sid", clean_tracks[1].id)
                msg.info(string.format("Forced-Sub Killer: Trocado para trilha limpa ID %d.", clean_tracks[1].id))
            else
                -- Nenhuma trilha limpa; desliga para não forçar texto indesejado
                mp.set_property("sid", "no")
                msg.info("Forced-Sub Killer: Nenhuma trilha limpa encontrada. Legenda desativada.")
            end
            break
        end
    end
end

-- Atalho Alt+v: Cicla estritamente entre trilhas LIMPAS ou Desliga de vez
local function toggle_sub_strip()
    local tracks = mp.get_property_native("track-list", {})
    local current_sid = mp.get_property_number("sid", 0)

    local clean_tracks = {}
    for _, track in ipairs(tracks) do
        if track.type == "sub" and not is_track_forced(track) then
            table.insert(clean_tracks, track)
        end
    end

    if #clean_tracks == 0 then
        mp.set_property("sid", "no")
        mp.osd_message("🛡️ [Legendas] Nenhuma trilha limpa (Forçadas bloqueadas)", 2.5)
        return
    end

    -- Se estiver desligado, pega a primeira limpa
    if current_sid == 0 or mp.get_property("sid") == "no" then
        local target = clean_tracks[1]
        mp.set_property_number("sid", target.id)
        local lang = target.lang or target.title or ("Trilha " .. target.id)
        mp.osd_message(string.format("🛡️ [Legenda Limpa] Ativa: %s", lang), 2.5)
        return
    end

    -- Encontra o índice atual na lista limpa
    local current_clean_idx = nil
    for idx, t in ipairs(clean_tracks) do
        if t.id == current_sid then
            current_clean_idx = idx
            break
        end
    end

    if current_clean_idx and current_clean_idx < #clean_tracks then
        -- Próxima trilha limpa
        local next_track = clean_tracks[current_clean_idx + 1]
        mp.set_property_number("sid", next_track.id)
        local lang = next_track.lang or next_track.title or ("Trilha " .. next_track.id)
        mp.osd_message(string.format("🛡️ [Legenda Limpa] %s", lang), 2.5)
    else
        -- Desliga
        mp.set_property("sid", "no")
        mp.osd_message("🛡️ [Legenda Limpa] DESATIVADA (Totalmente desligada)", 2.5)
    end
end

mp.register_event("file-loaded", sanitize_subtitles)
mp.add_key_binding(nil, "toggle_sub_strip", toggle_sub_strip)

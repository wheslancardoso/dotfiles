-- ==============================================================================
-- 🎙️ Sub-Sync — Sincronizador Acústico Manual (Ctrl+z) & Smart FPS (Alt+f)
-- ==============================================================================
-- Funções MANUAIS de sincronização (o pipeline automático está em smart-lang.lua):
-- 1. Ctrl+z: Sincronização por IA Acústica manual (forçar re-sync se precisar)
-- 2. Alt+f: Smart Auto-Detect de Framerate (lê o FPS do vídeo e corrige drift)
-- ==============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'

local CACHE_DIR = os.getenv("HOME") .. "/.cache/mpv_synced_subs"
local FPS_CYCLE_STATE = 0

local function ensure_cache_dir()
    mp.command_native({
        name = "subprocess", playback_only = false,
        args = { "mkdir", "-p", CACHE_DIR }
    })
end

-- Cache com chave baseada em idioma (compatível com smart-lang.lua)
local function normalize_lang(lang)
    if not lang then return "unknown" end
    lang = lang:lower():gsub("[_%-]", "")
    local map = {
        en = "en", eng = "en", enus = "en",
        pt = "pt", por = "pt", ptbr = "pt", pob = "pt",
        ja = "ja", jp = "ja", jpn = "ja",
    }
    return map[lang] or lang
end

local function get_current_sub_lang()
    local tracks = mp.get_property_native("track-list", {})
    local current_sid = mp.get_property_number("sid", 0)
    for _, track in ipairs(tracks) do
        if track.type == "sub" and track.id == current_sid then
            return normalize_lang(track.lang)
        end
    end
    return "unknown"
end

local function get_cache_path(video_path, lang)
    local sanitized = video_path:gsub("[^%w%._-]", "_")
    if #sanitized > 120 then sanitized = sanitized:sub(-120) end
    return string.format("%s/%s_%s.synced.srt", CACHE_DIR, sanitized, lang or "en")
end

local function sync_subtitle()
    local video_path = mp.get_property("path", "")
    if not video_path or video_path == "" or video_path:find("^%a[%a%d_]+://") then
        mp.osd_message("❌ [Sub-Sync] Indisponível para streams de URL remota.", 3.0)
        return
    end

    local tracks = mp.get_property_native("track-list", {})
    local current_sid = mp.get_property_number("sid", 0)

    if current_sid == 0 then
        mp.osd_message("⚠️ [Sub-Sync] Nenhuma legenda selecionada no momento.", 3.0)
        return
    end

    ensure_cache_dir()

    -- Verifica se o ffsubsync está disponível
    local check_cmd = mp.command_native({
        name = "subprocess", playback_only = false,
        capture_stdout = true, args = { "which", "ffsubsync" }
    })

    if check_cmd.status ~= 0 then
        mp.osd_message("⚠️ [Sub-Sync] 'ffsubsync' não encontrado.\nInstale com: pip install ffsubsync", 5.0)
        return
    end

    local current_track = nil
    local sub_track_index = 0

    for _, track in ipairs(tracks) do
        if track.type == "sub" then
            if track.id == current_sid then
                current_track = track
                break
            end
            sub_track_index = sub_track_index + 1
        end
    end

    if not current_track then
        mp.osd_message("❌ [Sub-Sync] Trilha de legenda não encontrada.", 3.0)
        return
    end

    -- Cache baseado em idioma (compartilhado com smart-lang.lua)
    local sub_lang = get_current_sub_lang()
    local synced_output = get_cache_path(video_path, sub_lang)

    -- Se já estiver em cache, aplica instantaneamente
    local file_check = io.open(synced_output, "r")
    if file_check then
        file_check:close()
        mp.commandv("sub-add", synced_output, "select")
        mp.osd_message("⚡ [Sub-Sync] Carregado instantaneamente do cache!", 3.0)
        return
    end

    -- Se for legenda externa
    if current_track.external and current_track["external-filename"] then
        local sub_file = current_track["external-filename"]
        mp.osd_message("🎙️ [Sub-Sync] Escutando áudio e alinhando fala... (Aguarde)", 4.0)

        mp.command_native_async({
            name = "subprocess", playback_only = false,
            args = { "ffsubsync", video_path, "-i", sub_file, "-o", synced_output }
        }, function(success, res)
            if success and res.status == 0 then
                mp.commandv("sub-add", synced_output, "select")
                mp.osd_message("✔ [Sub-Sync] Alinhada por voz e salva em cache!", 3.5)
            else
                mp.osd_message("❌ [Sub-Sync] Falha no alinhamento acústico.", 3.0)
            end
        end)
    else
        -- Legenda EMBUTIDA no MKV/MP4
        local temp_extracted = string.format("/tmp/mpv_extracted_%d.srt", os.time())
        mp.osd_message("📦 [Sub-Sync] Extraindo trilha interna para análise acústica...", 3.5)

        mp.command_native_async({
            name = "subprocess", playback_only = false,
            args = { "ffmpeg", "-y", "-i", video_path, "-map", string.format("0:s:%d", sub_track_index), temp_extracted }
        }, function(ext_ok, ext_res)
            if not ext_ok or ext_res.status ~= 0 then
                mp.osd_message("❌ [Sub-Sync] Falha ao extrair trilha com ffmpeg.", 3.5)
                return
            end

            mp.osd_message("🎙️ [Sub-Sync] Alinhando com a voz dos atores...", 4.0)

            mp.command_native_async({
                name = "subprocess", playback_only = false,
                args = { "ffsubsync", video_path, "-i", temp_extracted, "-o", synced_output }
            }, function(sync_ok, sync_res)
                os.remove(temp_extracted)
                if sync_ok and sync_res.status == 0 then
                    mp.commandv("sub-add", synced_output, "select")
                    mp.osd_message("🎉 [Sub-Sync] Sincronizada e salva em cache!", 4.0)
                else
                    mp.osd_message("❌ [Sub-Sync] Falha no alinhamento do ffsubsync.", 3.0)
                end
            end)
        end)
    end
end

-- --- SMART AUTO-DETECT & CICLO DE FRAMERATE (ALT + F) ---
local function smart_fps_cycle()
    local video_fps = mp.get_property_number("container-fps", 0)
    if video_fps == 0 then
        video_fps = mp.get_property_number("estimated-vf-fps", 23.976)
    end

    FPS_CYCLE_STATE = (FPS_CYCLE_STATE + 1) % 3

    if FPS_CYCLE_STATE == 1 then
        if math.abs(video_fps - 23.976) < 0.2 or math.abs(video_fps - 24.0) < 0.2 then
            local speed = 0.95904
            mp.set_property_number("sub-speed", speed)
            mp.osd_message(string.format("💡 [Smart FPS Fix] Vídeo é %.3f FPS (Cinema)\n➜ Aplicado: 25.0 ➔ 23.976 FPS (sub-speed: %.4f)", video_fps, speed), 4.0)
        else
            local speed = 1.04271
            mp.set_property_number("sub-speed", speed)
            mp.osd_message(string.format("💡 [Smart FPS Fix] Vídeo é %.3f FPS (TV/PAL)\n➜ Aplicado: 23.976 ➔ 25.0 FPS (sub-speed: %.4f)", video_fps, speed), 4.0)
        end
    elseif FPS_CYCLE_STATE == 2 then
        local speed = 1.04271
        if mp.get_property_number("sub-speed", 1.0) == 1.04271 then
            speed = 0.95904
        end
        mp.set_property_number("sub-speed", speed)
        mp.osd_message(string.format("💡 [Smart FPS Fix] Alternado para secundário: sub-speed %.4f", speed), 3.5)
    else
        mp.set_property_number("sub-speed", 1.0)
        mp.osd_message("💡 [Smart FPS Fix] Velocidade da legenda restaurada para 1.0", 3.0)
    end
end

-- NOTA: O auto-load de cache é feito pelo smart-lang.lua (pipeline automático)
-- Este script mantém apenas o sync MANUAL (Ctrl+z) e o Smart FPS (Alt+f)
mp.add_key_binding(nil, "sync_current", sync_subtitle)
mp.add_key_binding(nil, "smart_fps_cycle", smart_fps_cycle)

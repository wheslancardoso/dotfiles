-- ==============================================================================
-- 🎙️ Sub-Sync Universal — Sincronizador Acústico Inteligente de Legendas
-- ==============================================================================
-- Resolve 100% dos problemas de sincronização:
-- 1. Legenda Externa (.srt): Sincroniza via ffsubsync escutando o áudio.
-- 2. Legenda Embutida (MKV/MP4): Extrai a trilha do container em 1s e sincroniza.
-- 3. Correção de Framerate Drift: Corrige deriva de 23.976fps <-> 25.0fps instantaneamente.
-- 4. Cache Inteligente: Lembra de legendas já sincronizadas em ~/.cache/mpv_synced_subs/
-- ==============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'

local CACHE_DIR = os.getenv("HOME") .. "/.cache/mpv_synced_subs"

local function ensure_cache_dir()
    mp.command_native({
        name = "subprocess",
        playback_only = false,
        args = { "mkdir", "-p", CACHE_DIR }
    })
end

-- Gera um nome determinístico de cache baseado no caminho do vídeo e no ID da trilha
local function get_cache_path(video_path, sub_id)
    local sanitized = video_path:gsub("[^%w%._-]", "_")
    if #sanitized > 100 then
        sanitized = sanitized:sub(-100)
    end
    return string.format("%s/%s_track%s.synced.srt", CACHE_DIR, sanitized, tostring(sub_id or 1))
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
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        args = { "which", "ffsubsync" }
    })

    if check_cmd.status ~= 0 then
        mp.osd_message("⚠️ [Sub-Sync] 'ffsubsync' não encontrado.\nInstale com: paru -S python-ffsubsync ou pip install ffsubsync", 5.0)
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

    local synced_output = get_cache_path(video_path, current_sid)

    -- Se já estiver em cache, aplica instantaneamente
    local file_check = io.open(synced_output, "r")
    if file_check then
        file_check:close()
        mp.commandv("sub-add", synced_output, "select")
        mp.osd_message("⚡ [Sub-Sync] Carregado instantaneamente do Cache!", 3.0)
        return
    end

    -- Se for legenda externa
    if current_track.external and current_track["external-filename"] then
        local sub_file = current_track["external-filename"]
        mp.osd_message("🎙️ [Sub-Sync] Escutando áudio e alinhando fala... (Aguarde)", 4.0)

        mp.command_native_async({
            name = "subprocess",
            playback_only = false,
            args = { "ffsubsync", video_path, "-i", sub_file, "-o", synced_output }
        }, function(success, res, err)
            if success and res.status == 0 then
                mp.commandv("sub-add", synced_output, "select")
                mp.osd_message("✔ [Sub-Sync] Legenda perfeitamente alinhada por voz!", 3.5)
            else
                mp.osd_message("❌ [Sub-Sync] Falha no alinhamento acústico.", 3.0)
            end
        end)
    else
        -- Legenda EMBUTIDA no MKV/MP4: extrai para /tmp e sincroniza
        local temp_extracted = string.format("/tmp/mpv_extracted_%d.srt", os.time())
        mp.osd_message("📦 [Sub-Sync] Extraindo trilha interna do MKV para análise acústica...", 3.5)

        mp.command_native_async({
            name = "subprocess",
            playback_only = false,
            args = { "ffmpeg", "-y", "-i", video_path, "-map", string.format("0:s:%d", sub_track_index), temp_extracted }
        }, function(ext_ok, ext_res)
            if not ext_ok or ext_res.status ~= 0 then
                mp.osd_message("❌ [Sub-Sync] Não foi possível extrair a trilha interna com ffmpeg.", 3.5)
                return
            end

            mp.osd_message("🎙️ [Sub-Sync] Escutando áudio e alinhando com a voz dos atores...", 4.0)

            mp.command_native_async({
                name = "subprocess",
                playback_only = false,
                args = { "ffsubsync", video_path, "-i", temp_extracted, "-o", synced_output }
            }, function(sync_ok, sync_res)
                os.remove(temp_extracted)
                if sync_ok and sync_res.status == 0 then
                    mp.commandv("sub-add", synced_output, "select")
                    mp.osd_message("🎉 [Sub-Sync] Trilha do MKV sincronizada e salva em cache!", 4.0)
                else
                    mp.osd_message("❌ [Sub-Sync] Falha no alinhamento do ffsubsync.", 3.0)
                end
            end)
        end)
    end
end

-- --- Correção Rápida de Deriva de Framerate (23.976 <-> 25.0 FPS) ---
local function fix_fps_pal_to_ntsc()
    -- Converte de 25 fps para 23.976 fps (atrasa progressivamente 4.1%)
    local current_speed = mp.get_property_number("sub-speed", 1.0)
    local new_speed = current_speed * 0.95904
    mp.set_property_number("sub-speed", new_speed)
    mp.osd_message(string.format("⏱️ [FPS Fix] Ajustado: 25.0 ➔ 23.976 FPS (sub-speed: %.4f)", new_speed), 3.0)
end

local function fix_fps_ntsc_to_pal()
    -- Converte de 23.976 fps para 25 fps (acelera progressivamente 4.3%)
    local current_speed = mp.get_property_number("sub-speed", 1.0)
    local new_speed = current_speed * 1.04271
    mp.set_property_number("sub-speed", new_speed)
    mp.osd_message(string.format("⏱️ [FPS Fix] Ajustado: 23.976 ➔ 25.0 FPS (sub-speed: %.4f)", new_speed), 3.0)
end

local function reset_fps_speed()
    mp.set_property_number("sub-speed", 1.0)
    mp.osd_message("⏱️ [FPS Fix] Velocidade da legenda restaurada para 1.0", 2.5)
end

mp.add_key_binding(nil, "sync_current", sync_subtitle)
mp.add_key_binding(nil, "fps_pal_to_ntsc", fix_fps_pal_to_ntsc)
mp.add_key_binding(nil, "fps_ntsc_to_pal", fix_fps_ntsc_to_pal)
mp.add_key_binding(nil, "fps_reset", reset_fps_speed)

-- ==============================================================================
-- 🎙️ Sub-Sync Universal God Mode — Sincronizador Acústico Inteligente
-- ==============================================================================
-- Você NÃO precisa adivinhar nada:
-- 1. Ctrl+z: Sincronização por IA Acústica (ouve as vozes e alinha sozinho,
--    tanto para legendas externas quanto para faixas internas do MKV/MP4).
-- 2. Alt+f: Smart Auto-Detect de Framerate (lê o FPS real do vídeo e aplica
--    a correção matemática certa automaticamente com 1 tecla!).
-- 3. Cache Automático: Carrega silenciosamente legendas já sincronizadas antes.
-- ==============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'

local CACHE_DIR = os.getenv("HOME") .. "/.cache/mpv_synced_subs"
local FPS_CYCLE_STATE = 0

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

-- Carrega automaticamente do cache na abertura do arquivo se já tiver sido sincronizado
local function auto_load_cached_sub()
    local video_path = mp.get_property("path", "")
    if not video_path or video_path == "" or video_path:find("^%a[%a%d_]+://") then return end

    local current_sid = mp.get_property_number("sid", 1)
    local cached = get_cache_path(video_path, current_sid)

    local f = io.open(cached, "r")
    if f then
        f:close()
        mp.commandv("sub-add", cached, "select")
        mp.osd_message("⚡ [Auto-Sync] Legenda perfeitamente sincronizada carregada do cache!", 3.0)
    end
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
        mp.osd_message("🎙️ [Sub-Sync] Escutando áudio e alinhando fala... (Aguarde alguns segundos)", 4.0)

        mp.command_native_async({
            name = "subprocess",
            playback_only = false,
            args = { "ffsubsync", video_path, "-i", sub_file, "-o", synced_output }
        }, function(success, res)
            if success and res.status == 0 then
                mp.commandv("sub-add", synced_output, "select")
                mp.osd_message("✔ [Sub-Sync] Legenda perfeitamente alinhada por voz e salva em cache!", 3.5)
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

-- --- SMART AUTO-DETECT & CICLO DE FRAMERATE (ALT + F) ---
-- Você não precisa saber nada: o script lê o FPS do vídeo e escolhe o melhor!
local function smart_fps_cycle()
    local video_fps = mp.get_property_number("container-fps", 0)
    if video_fps == 0 then
        video_fps = mp.get_property_number("estimated-vf-fps", 23.976)
    end

    FPS_CYCLE_STATE = (FPS_CYCLE_STATE + 1) % 3

    if FPS_CYCLE_STATE == 1 then
        -- Se o vídeo for ~23.976 fps, a causa mais provável é legenda de 25fps rodando rápido
        -- Se o vídeo for ~25.0 fps, a causa é o inverso
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
        -- Modo inverso para teste rápido
        local speed = 1.04271
        if mp.get_property_number("sub-speed", 1.0) == 1.04271 then
            speed = 0.95904
        end
        mp.set_property_number("sub-speed", speed)
        mp.osd_message(string.format("💡 [Smart FPS Fix] Alternado para modo secundário: sub-speed %.4f", speed), 3.5)
    else
        -- Reset para 1.0
        mp.set_property_number("sub-speed", 1.0)
        mp.osd_message("💡 [Smart FPS Fix] Velocidade da legenda restaurada para 1.0 (Original)", 3.0)
    end
end

mp.register_event("file-loaded", auto_load_cached_sub)
mp.add_key_binding(nil, "sync_current", sync_subtitle)
mp.add_key_binding(nil, "smart_fps_cycle", smart_fps_cycle)

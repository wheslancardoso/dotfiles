-- ==============================================================================
-- 🎙️ Sub-Sync — Sincronizador Automático de Legendas por Voz (ffsubsync)
-- ==============================================================================
-- Sincroniza qualquer legenda (.srt) descompassada escutando o fluxo de áudio
-- e alinhando os tempos de fala automaticamente sem esforço manual.
-- ==============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'

local function sync_current_subtitle()
    local video_path = mp.get_property("path", "")
    if not video_path or video_path == "" or video_path:find("^%a[%a%d_]+://") then
        mp.osd_message("❌ [Sub-Sync] Não disponível para streams remotos de URL.", 3.0)
        return
    end

    local tracks = mp.get_property_native("track-list", {})
    local current_sid = mp.get_property_number("sid", 0)
    local sub_file = nil

    for _, track in ipairs(tracks) do
        if track.type == "sub" and track.id == current_sid then
            if track.external and track["external-filename"] then
                sub_file = track["external-filename"]
            end
            break
        end
    end

    -- Verifica se o ffsubsync existe no PATH
    local check_cmd = mp.command_native({
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        args = { "which", "ffsubsync" }
    })

    if check_cmd.status ~= 0 then
        mp.osd_message("⚠️ [Sub-Sync] Requer 'ffsubsync' instalado.\nInstale com: pip install ffsubsync ou paru -S python-ffsubsync", 4.0)
        return
    end

    if not sub_file then
        mp.osd_message("ℹ️ [Sub-Sync] Para sincronizar via IA, a legenda precisa ser um arquivo externo (.srt).", 3.5)
        return
    end

    local synced_sub = sub_file:gsub("%.srt$", "") .. ".synced.srt"
    mp.osd_message("🎙️ [Sub-Sync] Escutando áudio e alinhando legenda... Aguarde alguns segundos.", 4.0)

    -- Executa em background de forma assíncrona
    mp.command_native_async({
        name = "subprocess",
        playback_only = false,
        args = { "ffsubsync", video_path, "-i", sub_file, "-o", synced_sub }
    }, function(success, res, err)
        if success and res.status == 0 then
            mp.commandv("sub-add", synced_sub, "select")
            mp.osd_message("✔ [Sub-Sync] Legenda perfeitamente alinhada por voz e aplicada!", 3.5)
        else
            mp.osd_message("❌ [Sub-Sync] Erro na sincronização acústica.", 3.0)
        end
    end)
end

mp.add_key_binding(nil, "sync_current", sync_current_subtitle)

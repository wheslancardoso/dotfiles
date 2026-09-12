-- ============================================================================
-- 🎵 MUSIC STUDY & ANKI MINER — MPV God Mode Engine
-- Replay de Verso, Shadowing Loop (A-B Loop contínuo) e Mineração 1-Click Anki
-- ============================================================================

local mp = require 'mp'
local utils = require 'mp.utils'

local loop_active = false
local current_loop_start = nil
local current_loop_end = nil

local function get_miner_script()
    local user_miner = mp.command_native({"expand-path", "~~/../../scripts/anki-music-miner.py"})
    local dotfiles_miner = "/home/lan/dotfiles/scripts/anki-music-miner.py"
    if utils.file_info(dotfiles_miner) then
        return dotfiles_miner
    end
    return user_miner
end

-- 1. Replay do Verso Atual ('r')
local function replay_current_verse()
    local sub_start = mp.get_property_number("sub-start")
    if sub_start then
        local target = math.max(0, sub_start - 0.15)
        mp.set_property_number("time-pos", target)
        local sub_text = mp.get_property("sub-text") or ""
        sub_text = sub_text:gsub("\n", " ")
        if #sub_text > 45 then sub_text = sub_text:sub(1, 42) .. "..." end
        mp.osd_message("⏮️ [Replay Verso]: " .. sub_text, 2.0)
    else
        -- Se não tiver timestamp de legenda, faz seek normal de -3s
        mp.commandv("seek", -3, "relative", "exact")
        mp.osd_message("⏮️ Seek -3s", 1.5)
    end
end

-- 2. Shadowing Loop no Verso Atual ('l')
local function toggle_shadowing_loop()
    if loop_active then
        loop_active = false
        mp.set_property("ab-loop-a", "no")
        mp.set_property("ab-loop-b", "no")
        current_loop_start = nil
        current_loop_end = nil
        mp.osd_message("⏹️ [Shadowing Loop: DESATIVADO]", 2.0)
    else
        local sub_start = mp.get_property_number("sub-start")
        local sub_end = mp.get_property_number("sub-end")
        local pos = mp.get_property_number("time-pos") or 0

        if sub_start and sub_end and sub_end > sub_start then
            loop_active = true
            current_loop_start = math.max(0, sub_start - 0.15)
            current_loop_end = sub_end + 0.35
            
            mp.set_property_number("ab-loop-a", current_loop_start)
            mp.set_property_number("ab-loop-b", current_loop_end)
            mp.set_property_number("time-pos", current_loop_start)
            
            local sub_text = mp.get_property("sub-text") or ""
            sub_text = sub_text:gsub("\n", " ")
            if #sub_text > 40 then sub_text = sub_text:sub(1, 37) .. "..." end
            mp.osd_message("🔁 [Shadowing Loop: ATIVADO]\n" .. sub_text, 3.0)
        else
            -- Se não houver legenda no instante exato, cria um loop dos últimos 4s
            loop_active = true
            current_loop_start = math.max(0, pos - 3.0)
            current_loop_end = pos + 1.5
            mp.set_property_number("ab-loop-a", current_loop_start)
            mp.set_property_number("ab-loop-b", current_loop_end)
            mp.set_property_number("time-pos", current_loop_start)
            mp.osd_message("🔁 [Shadowing Loop Manual: 4.5s]", 2.5)
        end
    end
end

-- 3. Mineração do Verso para o Anki ('M')
local function mine_to_anki()
    local path = mp.get_property("path")
    if not path or path == "" then
        mp.osd_message("❌ Nenhum arquivo em reprodução.", 2.5)
        return
    end

    local sub_start = mp.get_property_number("sub-start")
    local sub_end = mp.get_property_number("sub-end")
    local sub_text = mp.get_property("sub-text") or ""
    local title = mp.get_property("media-title") or mp.get_property("filename/no-ext") or "Unknown Song"

    -- Se não houver marcação de legenda, permite capturar trecho atual (3s atrás até agora)
    local pos = mp.get_property_number("time-pos") or 0
    if not sub_start or not sub_end or sub_end <= sub_start then
        sub_start = math.max(0, pos - 3.5)
        sub_end = pos + 0.5
        if sub_text == "" then
            sub_text = "Audio segment (" .. string.format("%.1fs", sub_start) .. ")"
        end
    end

    sub_text = sub_text:gsub("\n", " "):gsub("^%s+", ""):gsub("%s+$", "")
    mp.osd_message("⚡ [Anki] Minerando áudio do verso...", 2.0)

    local miner_bin = get_miner_script()
    local cmd = {
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
        args = {
            "python3",
            miner_bin,
            "--file", path,
            "--start", string.format("%.3f", sub_start),
            "--end", string.format("%.3f", sub_end),
            "--text", sub_text,
            "--title", title
        }
    }

    mp.command_native_async(cmd, function(success, res, err)
        if success and res and res.status == 0 then
            mp.osd_message("✅ [Anki] Verso minerado com sucesso!\n🎵 " .. sub_text, 4.0)
        else
            local err_msg = (res and res.stderr) or err or "Desconhecido"
            mp.osd_message("❌ Falha ao minerar para Anki", 3.0)
            mp.msg.error("Miner error: " .. tostring(err_msg))
        end
    end)
end

-- Limpar loop ao trocar de arquivo
mp.register_event("end-file", function()
    if loop_active then
        loop_active = false
        mp.set_property("ab-loop-a", "no")
        mp.set_property("ab-loop-b", "no")
    end
end)

-- Mapear bindings globais do script
mp.add_key_binding("r", "replay_verse", replay_current_verse)
mp.add_key_binding("Alt+r", "replay_verse_alt", replay_current_verse)
mp.add_key_binding("l", "toggle_shadowing_loop", toggle_shadowing_loop)
mp.add_key_binding("Alt+l", "toggle_shadowing_loop_alt", toggle_shadowing_loop)
mp.add_key_binding("M", "mine_to_anki", mine_to_anki)
mp.add_key_binding("Ctrl+m", "mine_to_anki_ctrl", mine_to_anki)

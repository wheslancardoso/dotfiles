-- reload.lua - Recarrega streams / vídeos mantendo o ponto exato da reprodução
local mp = require 'mp'

function reload_resume()
    local path = mp.get_property("path")
    if not path or path == "" then return end
    local time_pos = mp.get_property_number("time-pos", 0)
    local paused = mp.get_property_bool("pause", false)

    mp.osd_message("🔄 Recarregando vídeo/stream...", 2)
    mp.commandv("loadfile", path, "replace", "start=" .. tostring(time_pos))
    if paused then
        mp.set_property_bool("pause", true)
    end
end

mp.add_key_binding("Ctrl+r", "reload_resume", reload_resume)

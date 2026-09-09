-- ==============================================================================
-- 🌙 Night Mode & Speech Clarity — Compressor Dinâmico de Áudio
-- ==============================================================================
-- Sabe quando a música/explosão estoura seus ouvidos mas você não escuta a voz?
-- O Modo Noturno aplica o Dynamic Audio Normalizer do FFmpeg para nivelar o áudio:
-- vozes sussurradas ficam nítidas e explosões são atenuadas confortavelmente.
-- ==============================================================================

local mp = require 'mp'

local ACTIVE = false
local FILTER_LABEL = "night_mode_filter"

local function toggle_night_mode()
    ACTIVE = not ACTIVE

    if ACTIVE then
        -- dynaudnorm: f=75 (tempo de resposta suave), g=25 (ganho máximo moderado), p=0.6 (pico confortável)
        local filter = string.format("@%s:lavfi=[dynaudnorm=f=75:g=25:p=0.60:m=10.0]", FILTER_LABEL)
        mp.commandv("af", "add", filter)
        mp.osd_message("🌙 [Modo Noturno] ATIVADO (Vozes Nítidas / Picos Suavizados)", 2.5)
    else
        mp.commandv("af", "remove", "@" .. FILTER_LABEL)
        mp.osd_message("🌙 [Modo Noturno] DESATIVADO (Áudio Original Dinâmico)", 2.5)
    end
end

mp.register_event("end-file", function()
    if ACTIVE then
        mp.commandv("af", "remove", "@" .. FILTER_LABEL)
        ACTIVE = false
    end
end)

mp.add_key_binding(nil, "toggle", toggle_night_mode)

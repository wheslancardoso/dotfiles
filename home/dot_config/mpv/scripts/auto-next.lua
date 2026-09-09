-- ==============================================================================
-- ⏭️ Auto-Next — Transição Automática de Episódios (Estilo Netflix)
-- ==============================================================================
-- Quando um episódio de série chega ao fim e há próximos episódios na pasta,
-- este script exibe um aviso elegante na tela e inicia o próximo episódio
-- automaticamente após 3 segundos (a menos que você aperte Esc).
-- ==============================================================================

local mp = require 'mp'

local COUNTDOWN_ACTIVE = false
local TIMER = nil

local function cancel_countdown()
    if COUNTDOWN_ACTIVE then
        COUNTDOWN_ACTIVE = false
        if TIMER then
            TIMER:kill()
            TIMER = nil
        end
        mp.osd_message("🛑 Auto-Next Cancelado", 2.0)
    end
end

local function trigger_next()
    COUNTDOWN_ACTIVE = false
    TIMER = nil
    local pos = mp.get_property_number("playlist-pos", 0)
    local count = mp.get_property_number("playlist-count", 1)

    if pos < (count - 1) then
        mp.commandv("playlist-next")
    end
end

local function on_time_update(name, remaining)
    if not remaining then return end

    local pos = mp.get_property_number("playlist-pos", 0)
    local count = mp.get_property_number("playlist-count", 1)

    -- Só ativa se houver próximo episódio na fila
    if pos >= (count - 1) then return end

    -- Quando restarem menos de 3.5 segundos e não estiver pausado
    local paused = mp.get_property_bool("pause", false)
    if remaining <= 3.5 and remaining > 0 and not paused and not COUNTDOWN_ACTIVE then
        COUNTDOWN_ACTIVE = true
        mp.osd_message("⏭️ Próximo episódio em 3s... [Esc para cancelar]", 3.0)

        TIMER = mp.add_timeout(3.2, function()
            trigger_next()
        end)
    end
end

-- Se o usuário pausar no finalzinho, cancela contagem
mp.observe_property("pause", "bool", function(name, val)
    if val and COUNTDOWN_ACTIVE then
        cancel_countdown()
    end
end)

mp.observe_property("time-remaining", "number", on_time_update)
mp.add_key_binding(nil, "cancel", cancel_countdown)

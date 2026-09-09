-- ==============================================================================
-- 🚀 Sub-Skip & Silence Accelerator — Motor de Imersão em Inglês
-- ==============================================================================
-- Monitora os diálogos na legenda e elimina o tempo ocioso:
-- - Diálogo ativo: Toca na velocidade normal/estudo escolhida pelo usuário (ex: 1.0x ou 1.25x).
-- - Silêncio / Sem fala: Acelera automaticamente para 2.5x (ou pula pro diálogo).
-- ==============================================================================

local mp = require 'mp'

local ENABLED = false
local MODE = "speedup" -- "speedup" (acelera no silêncio) ou "skip" (salta direto)
local FAST_SPEED = 2.5
local USER_NORMAL_SPEED = 1.0
local IN_DIALOGUE = true

local function show_osd(text)
    mp.osd_message("⚡ [Imersão Inglês] " .. text, 2.5)
end

local function apply_speed(target_speed)
    local current_speed = mp.get_property_number("speed", 1.0)
    if math.abs(current_speed - target_speed) > 0.05 then
        mp.set_property_number("speed", target_speed)
    end
end

local function check_subtitle_state()
    if not ENABLED then return end

    -- Verifica se há trilha de legenda selecionada
    local sid = mp.get_property_number("sid", 0)
    if sid == 0 then
        -- Sem legenda carregada, não altera velocidade
        return
    end

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
                -- Salto para o próximo evento de legenda
                mp.commandv("sub-seek", "1")
            end
        end
    end
end

-- Observa quando o usuário altera manualmente a velocidade normal fora do silêncio
local function on_speed_change(name, val)
    if not val then return end
    if IN_DIALOGUE or not ENABLED then
        USER_NORMAL_SPEED = val
    end
end

-- Observa mudanças na legenda
mp.observe_property("sub-text", "string", check_subtitle_state)
mp.observe_property("speed", "number", on_speed_change)

-- Atalho: Ligar/Desligar Imersão
local function toggle()
    ENABLED = not ENABLED
    if ENABLED then
        IN_DIALOGUE = true
        local current = mp.get_property_number("speed", 1.0)
        USER_NORMAL_SPEED = current
        show_osd(string.format("ATIVADO (%s | Normal: %.2fx | Silêncio: %.1fx)", 
            (MODE == "speedup" and "Acelerar" or "Pular"), USER_NORMAL_SPEED, FAST_SPEED))
        check_subtitle_state()
    else
        apply_speed(USER_NORMAL_SPEED)
        show_osd("DESATIVADO (Velocidade normal restaurada)")
    end
end

-- Atalho: Alternar entre Acelerar no Silêncio ou Pular
local function toggle_mode()
    if MODE == "speedup" then
        MODE = "skip"
        show_osd("Modo alterado para: PULAR SILÊNCIO (Seek direto)")
    else
        MODE = "speedup"
        show_osd("Modo alterado para: ACELERAR NO SILÊNCIO (Smooth speedup)")
    end
    check_subtitle_state()
end

-- Atalho: Ajustar velocidade do silêncio
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

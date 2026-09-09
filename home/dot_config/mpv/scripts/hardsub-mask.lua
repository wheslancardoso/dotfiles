-- ==============================================================================
-- 🕶️ Hardsub Mask — Máscara Inteligente para Legendas Queimadas no Vídeo
-- ==============================================================================
-- Quando o vídeo vem com legenda queimada nos pixels (hardsub) e é impossível
-- desligá-la, este script adiciona uma faixa preta elegante semi-opaca no rodapé
-- com uma única tecla (Alt+b), permitindo ler suas legendas em inglês sem atrito.
-- ==============================================================================

local mp = require 'mp'

local MASK_ACTIVE = false
local LABEL = "hardsub_mask_filter"

local function toggle_mask()
    MASK_ACTIVE = not MASK_ACTIVE

    if MASK_ACTIVE then
        -- Adiciona filtro drawbox no rodapé inferior (15% da altura do vídeo)
        -- Cor preta fosca com 92% de opacidade para cobrir o texto queimado
        local filter_str = string.format(
            "@%s:drawbox=x=0:y=ih-ih*0.16:w=iw:h=ih*0.16:color=black@0.92:t=fill",
            LABEL
        )
        mp.commandv("vf", "add", filter_str)
        mp.osd_message("🕶️ [Hardsub Mask] ATIVADA (Rodapé Ocultado)", 2.5)
    else
        -- Remove o filtro
        mp.commandv("vf", "remove", "@" .. LABEL)
        mp.osd_message("🕶️ [Hardsub Mask] DESATIVADA (Vídeo Original)", 2.5)
    end
end

-- Limpa a máscara quando um novo arquivo for aberto
mp.register_event("end-file", function()
    if MASK_ACTIVE then
        mp.commandv("vf", "remove", "@" .. LABEL)
        MASK_ACTIVE = false
    end
end)

mp.add_key_binding(nil, "toggle_mask", toggle_mask)

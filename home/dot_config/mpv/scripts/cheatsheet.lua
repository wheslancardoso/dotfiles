-- ==============================================================================
-- 📖 In-Player Cheatsheet HUD — Guia Visual de Teclas na Tela do MPV
-- ==============================================================================
-- Pressione '?' ou 'F1' ou 'h' a qualquer momento para ver todos os atalhos
-- organizados em categorias diretamente sobre o vídeo. Pressione de novo para fechar.
-- ==============================================================================

local mp = require 'mp'

local VISIBLE = false
local OVERLAY = mp.create_osd_overlay("ass-events")

local function build_hud_text()
    local ass = {
        "{\\an7\\pos(45,35)\\fs26\\fnInter\\bord1.5\\shad1\\b1\\1c&H00F5C2E7&}🎬 MPV GOD MODE — GUIA RÁPIDO DE ATALHOS{\\b0\\1c&H00CDD6F4&}\\N\\N",
        
        "{\\b1\\1c&H0089B4FA&}⚡ VELOCIDADE & ESTUDO (Áudio Natural sem voz de esquilo):{\\b0\\1c&H00BAC2DE&}\\N",
        "  • {\\b1\\1c&H00A6E3A1&}[{\\b0} / {\\b1\\1c&H00A6E3A1&}]{\\b0} : Diminuir / Aumentar velocidade (1.1x, 1.25x, 1.5x)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}BS{\\b0} (Backspace) : Voltar para 1.0x instantaneamente\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + i{\\b0} ou {\\b1\\1c&H00A6E3A1&}Ctrl + n{\\b0} : Ligar/Desligar {\\b1}Imersão de Inglês{\\b0} (Acelera nos silêncios)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + m{\\b0} : Alternar modo de imersão (Acelerar no silêncio vs Pular direto)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + [ / ]{\\b0} : Regular velocidade rápida do silêncio (2.0x a 4.0x)\\N\\N",

        "{\\b1\\1c&H0089B4FA&}🛡️ INTELIGÊNCIA DE LEGENDAS:{\\b0\\1c&H00BAC2DE&}\\N",
        "  • {\\b1\\1c&H00A6E3A1&}v{\\b0} : Ligar / Desligar visibilidade da legenda normal\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Shift + V{\\b0} : {\\b1}Forced-Sub Killer{\\b0} (Mata forçadas e cicla só trilhas limpas)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Ctrl + z{\\b0} : {\\b1}Sincronização por Voz{\\b0} (Universal: embutida ou externa via ffsubsync)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + f{\\b0} : {\\b1}Smart FPS Auto-Detect{\\b0} (Lê FPS do vídeo e corrige drift com 1 tecla!)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Ctrl + s{\\b0} : {\\b1}Baixar Legenda Automática{\\b0} (OpenSubtitles via 1 clique)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}z{\\b0} / {\\b1\\1c&H00A6E3A1&}Z{\\b0} : Atrasar / Adiantar legenda em 50ms (ajuste manual)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + z{\\b0} : Resetar atraso de legenda a 0.0s\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + b{\\b0} : Máscara preta no rodapé (para tapar legenda queimada no vídeo)\\N\\N",

        "{\\b1\\1c&H0089B4FA&}🧠 SMART-LANG: DUAL AUDIO & IMERSÃO:{\\b0\\1c&H00BAC2DE&}\\N",
        "  • {\\b1\\1c&H00A6E3A1&}a{\\b0} : Trocar áudio (legenda troca junto automaticamente!)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + e{\\b0} : {\\b1}🇬🇧 Modo Imersão{\\b0} (Áudio EN + Legenda EN com 1 tecla)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Alt + p{\\b0} : {\\b1}🇧🇷 Modo Nativo{\\b0} (Áudio PT + Legenda PT com 1 tecla)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Ctrl + e{\\b0} : {\\b1}📝 Dual Sub{\\b0} (EN embaixo + PT em cima para estudo)\\N",
        "  • {\\b1\\1c&H00F5C2E7&}Auto:{\\b0} Ao abrir vídeo, seleciona a melhor legenda EN automaticamente\\N",
        "  • {\\b1\\1c&H00F5C2E7&}Auto:{\\b0} Sem legenda? Baixa do OpenSubtitles sozinho em background\\N\\N",

        "{\\b1\\1c&H0089B4FA&}📺 SÉRIES & NAVEGAÇÃO BINGE-WATCH:{\\b0\\1c&H00BAC2DE&}\\N",
        "  • {\\b1\\1c&H00A6E3A1&}TAB{\\b0} : {\\b1}Pular Abertura / Intro{\\b0} (Estilo Netflix / Crunchyroll)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}ENTER{\\b0} : Abrir menu visual com a lista de episódios da temporada\\N",
        "  • {\\b1\\1c&H00A6E3A1&}>{\\b0} / {\\b1\\1c&H00A6E3A1&}<{\\b0} : Próximo episódio / Episódio anterior\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Auto-Next{\\b0} : Próximo episódio toca sozinho faltando 3s (Esc cancela)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Setas Dir/Esq{\\b0} : Avançar / Retroceder 5 segundos\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Setas Cima/Baixo{\\b0} : Avançar / Retroceder 30 segundos\\N\\N",

        "{\\b1\\1c&H0089B4FA&}🔊 ÁUDIO, VÍDEO & CONFORTO:{\\b0\\1c&H00BAC2DE&}\\N",
        "  • {\\b1\\1c&H00A6E3A1&}n{\\b0} : {\\b1}Modo Noturno{\\b0} (Compressor dinâmico: vozes nítidas sem explosão alta)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}a{\\b0} : Trocar faixa de áudio (Dublado / Inglês Original)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Botão Direito{\\b0} : Menu completo do uosc (Controles, trilhas, velocidade na tela)\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Duplo Clique Esq.{\\b0} : Alternar Tela Cheia\\N",
        "  • {\\b1\\1c&H00A6E3A1&}Clique do Meio{\\b0} : Play / Pause\\N\\N",

        "{\\fs22\\1c&H00F38BA8&}Pressione '?' ou 'F1' ou 'Esc' para fechar este guia.{\\r}"
    }
    return table.concat(ass)
end

local function toggle_hud()
    VISIBLE = not VISIBLE
    if VISIBLE then
        OVERLAY.data = build_hud_text()
        OVERLAY:update()
    else
        OVERLAY:remove()
    end
end

local function close_hud()
    if VISIBLE then
        VISIBLE = false
        OVERLAY:remove()
    end
end

mp.add_key_binding(nil, "toggle", toggle_hud)
mp.add_key_binding(nil, "close", close_hud)

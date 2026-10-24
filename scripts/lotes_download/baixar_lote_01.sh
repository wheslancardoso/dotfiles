#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 01 DE 17 NO BRAVE (Novos Mods 1 a 15) ==="
URLS=(
    "https://sharemods.com/79u303jv0csa/Proper_Streaming.zip.html" # [1] [SA] Proper Streaming (corrigir mapa não carregando)
    "https://sharemods.com/px30jmq1k2xo/SA_-_Proper_Shaders_08-26___40_py8vte2gr7a__41_.zip.html" # [2] [SA] Proper Shaders (gráficos HD para GTA SA)
    "https://github.com/CookiePLMonster/SilentPatch/releases/tag/1.1-BUILD34.1-SA" # [3] [SA] SilentPatch (Build 34.1 – 2026)
    "https://sharemods.com/dnlu9kd7wejz/Improved_Streaming.zip.html" # [4] [SA/PC/Mobile] Improved Streaming v1.1 (corrigir mapa não carregando)
    "https://drive.google.com/file/d/115LMhaNP6mh-Sip9Sbtdl9EulSUlaq2F/view" # [5] [SA] Proper Fixes v2.1.1 (pack de correções para PC)
    "https://www.mixmods.com.br/2026/06/soundize/" # [6] [SA] Soundize (AAA audio system)
    "https://sharemods.com/7jrzxw0b8x9j/ModLoader.zip.html" # [7] ModLoader 0.3.10 para GTA SA / VC / III
    "https://www.mixmods.com.br/2026/02/gta-sa-proper-shaders-teaser/" # [9] [GTA SA] Proper Shaders (teaser)
    "https://www.mixmods.com.br/2025/07/muitos-mods-importantes-foram-atualizados/" # [11] Muitos mods importantes foram atualizados
    "https://sharemods.com/f67rcc920tm9/SA_-_Silent_ASI_Loader.zip.html" # [12] [SA] Silent’s ASI Loader v1.5
    "https://sharemods.com/1ly65k5xchjr/FxsFuncs.7z.html" # [14] FxsFuncs v1.2 (melhorias para efeitos especiais)
    "https://sharemods.com/kmxsdpto6re8/In-Game_Map_Editor.zip.html" # [16] In-Game Map Editor v0.7 (editor de mapa dentro do jogo)
    "https://www.mixmods.com.br/2024/08/original-radio-extended/" # [17] [SA] Original Radio Extended (1000 músicas)
    "https://sharemods.com/stxvlyt5j4q4/SA_-_SkyGfx_Extended.zip.html" # [18] [SA] SkyGfx v4.2b + Extended v1.7
    "https://sharemods.com/3yrdrs7l9v6r/CLEOPlus.zip.html" # [19] [SA] CLEO+ v1.2.0
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote pendente aberto no Brave!"

#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 01 DE 19 NO BRAVE (Mods 1 a 15) ==="

URLS=(
    "https://sharemods.com/79u303jv0csa/Proper_Streaming.zip.html" # [1] [SA] Proper Streaming (corrigir mapa não carregando)
    "https://sharemods.com/px30jmq1k2xo/SA_-_Proper_Shaders_08-26___40_py8vte2gr7a__41_.zip.html" # [2] [SA] Proper Shaders (gráficos HD para GTA SA)
    "https://github.com/CookiePLMonster/SilentPatch/releases/tag/1.1-BUILD34.1-SA" # [3] [SA] SilentPatch (Build 34.1 – 2026)
    "https://sharemods.com/dnlu9kd7wejz/Improved_Streaming.zip.html" # [4] [SA/PC/Mobile] Improved Streaming v1.1 (corrigir mapa não carregando)
    "https://drive.google.com/file/d/115LMhaNP6mh-Sip9Sbtdl9EulSUlaq2F/view" # [5] [SA] Proper Fixes v2.1.1 (pack de correções para PC)
    "https://www.mixmods.com.br/2026/06/soundize/" # [6] [SA] Soundize (AAA audio system)
    "https://sharemods.com/7jrzxw0b8x9j/ModLoader.zip.html" # [7] ModLoader 0.3.10 para GTA SA / VC / III
    "https://sharemods.com/f67rcc920tm9/SA_-_Silent_ASI_Loader.zip.html" # [10] [SA] Silent’s ASI Loader v1.5
    "https://sharemods.com/1ly65k5xchjr/FxsFuncs.7z.html" # [12] FxsFuncs v1.2 (melhorias para efeitos especiais)
    "https://www.mixmods.com.br/2024/08/original-radio-extended/" # [14] [SA] Original Radio Extended (1000 músicas)
    "https://sharemods.com/stxvlyt5j4q4/SA_-_SkyGfx_Extended.zip.html" # [15] [SA] SkyGfx v4.2b + Extended v1.7
    "https://sharemods.com/3yrdrs7l9v6r/CLEOPlus.zip.html" # [16] [SA] CLEO+ v1.2.0
    "https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd/" # [17] [SA] RoSA Evolved v1.5 (remaster texturas HD 2026) PC/Android
    "https://github.com/NVIDIAGameWorks/rtx-remix/releases/latest" # [18] [SA] RTX Remix (download)
    "https://sharemods.com/qa2p3422m9am/SA_-_Santa_Maria_Pier_Extended.7z.html" # [19] [SA] Santa Maria Pier Extended (parque de diversões)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 01/19 enviado para o navegador com sucesso!"

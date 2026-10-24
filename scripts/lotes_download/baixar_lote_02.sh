#!/usr/bin/env bash
echo "=== ABRINDO LOTE 02 DE 18 NO BRAVE (Mods 16 a 30) ==="
URLS=(
    "https://sharemods.com/kmxsdpto6re8/In-Game_Map_Editor.zip.html" # [16] In-Game Map Editor v0.7 (editor de mapa dentro do jogo)
    "https://www.mixmods.com.br/2024/08/original-radio-extended/" # [17] [SA] Original Radio Extended (1000 músicas)
    "https://sharemods.com/stxvlyt5j4q4/SA_-_SkyGfx_Extended.zip.html" # [18] [SA] SkyGfx v4.2b + Extended v1.7
    "https://sharemods.com/3yrdrs7l9v6r/CLEOPlus.zip.html" # [19] [SA] CLEO+ v1.2.0
    "https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd/" # [20] [SA] RoSA Evolved v1.5 (remaster texturas HD 2026) PC/Android
    "https://github.com/NVIDIAGameWorks/rtx-remix/releases/latest" # [21] [SA] RTX Remix (download)
    "https://www.mixmods.com.br/2023/05/gta-san-andreas-com-rtx-remix-supera-expectativas/" # [22] GTA San Andreas com RTX Remix supera expectativas
    "https://sharemods.com/qa2p3422m9am/SA_-_Santa_Maria_Pier_Extended.7z.html" # [23] [SA] Santa Maria Pier Extended (parque de diversões)
    "https://sharemods.com/y5pkv6qmpy9y/SA_-_Pacific_Park_Rotating_Ferris_Wheel.7z.html" # [24] [SA] Pacific Park Rotating Ferris Wheel (roda-gigante animada)
    "https://sharemods.com/bn17c3snstt1/SA_Snow_Conversion.7z.html" # [25] SA Snow Conversion 2022 (mod pack)
    "https://sharemods.com/gq01h5shttg9/DYOM_8.1.zip.html" # [26] [SA] DYOM – Design Your Own Mission (2022)
    "https://sharemods.com/zf4cw8dt5y0j/SA_-_Tree_House.7z.html" # [27] [SA] Tree House v1.1 (mod casa na árvore)
    "https://sharemods.com/iq9lg1tafztf/Story_Mode.7z.html" # [28] [SA] Story Mode v2.0 (melhorias pra storyline)
    "https://sharemods.com/r9991nx53e61/SA_-_Ladders_Mod.zip.html" # [29] [SA] Ladders Mod (subir escadas)
    "https://www.mixmods.com.br/2022/10/projeto-urbanize-apoie/" # [30] Projeto Urbanize – Apoie!
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

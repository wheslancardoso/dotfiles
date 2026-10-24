#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 04 DE 07 NO BRAVE (Mods 37 a 48) ==="

URLS=(
    "https://sharemods.com/mjxz5fvpmt4p/HeliFix.7z.html" # [43] HeliFix v1.4
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [44] Extended Gang Wars
    "https://drive.google.com/open?id=0B04D_5yMCyl9RWNHdUdTQVZ0T2M" # [45] Recomeçar Missão
    "https://www.mixmods.com.br/2023/07/rosa-project-evolved-remaster-texturas-hd" # [47] RoSA Project Evolved (v1.5 - 2026)
    "https://sharemods.com/stxvlyt5j4q4/SA_-_SkyGfx_Extended.zip.html" # [48] SkyGfx v4.2b + Extended
    "https://sharemods.com/1ly65k5xchjr/FxsFuncs.7z.html" # [49] FxsFuncs v1.2 (2025/2026)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [50] Shadows Settings Extender v2.1.2
    "https://sharemods.com/duxyrps05sns/Dynamic_Shadow_Color.7z.html" # [51] Dynamic Shadow Color (Sombras com Cores Atmosféricas)
    "https://sharemods.com/j81zikfmhj4t/Mesh_Smoothed_Pack.7z.html" # [52] High Poly Desert
    "https://sharemods.com/iwbbggdxsnhy/Improved_Lamps.7z.html" # [53] Improved Lamps v0.8
    "https://sharemods.com/rb96prexlrg9/More_Radar_Icons.7z.html" # [54] More Radar Icons v2.0
    "https://sharemods.com/e134w29j6xze/Improved_Surface_Physics.7z.html" # [56] Improved Surface Physics (Superfícies com Física Aprimorada)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 04/07 aberto no Brave com sucesso!"

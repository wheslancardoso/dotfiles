#!/usr/bin/env bash
echo "=== ABRINDO LOTE 11 DE 18 NO BRAVE (Mods 151 a 165) ==="
URLS=(
    "https://sharemods.com/bdfmly3kxlww/Beta_Weapons.7z.html" # [151] Beta Weapons Pack (armas restauradas da versão beta)
    "https://sharemods.com/6bqvoaye4s8o/Real_Skybox_-_skyboxes_1024.7z.html" # [152] Real Skybox skyboxes by Crowdigger (novos céus HD)
    "https://sharemods.com/7ebe6hqzbcc8/Handshake_Mod.7z.html" # [153] Handshake Mod (aperto de mão)
    "https://sharemods.com/shb6ml79ruhj/Stress_Test.7z.html" # [154] Stress Test (forçar jogo a crashar)
    "https://sharemods.com/ejwih62ioxnz/Gang_Rider_Lua.7z.html" # [155] Gang Rider v2 (carregar mais gangue)
    "https://sharemods.com/2zhd2ohur8hu/fastman92_processor.7z.html" # [156] fastman92 processor v1.9 + GUI
    "https://drive.google.com/drive/folders/1gPYZm_H0i-h22r1TjSZCcKY8hiCEqI8t" # [157] GTA SA Comic Edition
    "https://drive.google.com/file/d/1OjwyxUKqjRCYuv9y49dgHfV0EOnqiBTA/view?usp=sharing" # [158] Faithful Weapons Pack 2.0 (pack de armas fiéis)
    "https://sharemods.com/t0qrb187b7qr/Banshee_Plus.7z.html" # [159] Banshee Plus+ (SA style)
    "https://sharemods.com/jm60r1j8pr72/Euryopa.7z.html" # [160] Euryopa (visualizador de mapa para GTA)
    "https://sharemods.com/ywqqzuky007z/Futo_Trueno_Levin.7z.html" # [161] Futo Trueno + Levin (AE86 SA style)
    "https://sharemods.com/s8bmfqkshpzo/90s_Atmosphere_Weapons_Pack_Reborn.7z.html" # [162] 90s AWP – 90s Atmosphere Weapons Pack Reborn 4.0
    "https://sharemods.com/coxoxpb23p35/ENBSeriesAutoToggle.7z.html" # [163] ENB Series Auto Toggle (desativar ENB em interior e menu)
    "https://sharemods.com/jvzzb61srlpb/Peugeot_206_GTI.7z.html" # [164] Peugeot 206 GTI (tunável)
    "https://sharemods.com/w955w0xtii2a/Clean_Render_-_Renderhook.7z.html" # [165] Clean Render (RenderHook)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

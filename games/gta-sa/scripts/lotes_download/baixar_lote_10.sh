#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 10 DE 14 NO BRAVE (Mods 136 a 150) ==="

URLS=(
    "https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html" # [153] Comet Plus+ (SA style)
    "https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view" # [154] 90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [155] Shadows Settings Extender v2.1.2 (extensor de sombras)
    "https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html" # [156] Wayfarer Plus+ (sa style)
    "https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html" # [157] Dream Grass (grama HD do GTA V)
    "https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html" # [158] Grip Animation (nova animação de segurar arma)
    "https://sharemods.com/cgdkdrp91z28/Military_Animation.7z.html" # [159] Military Animation v9 (unofficial fix)
    "https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html" # [160] ImVehFt – Improved Vehicle Features
    "https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html" # [161] Rename vehicles (car names.fxt)
    "https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html" # [162] NRG-500 Remastered HD by Ezekiel
    "https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html" # [163] Ford Focus ZX3/SVT 2000-2004 by Avant
    "https://sharemods.com/5xnjtf8aab38/Infernus_HD_Remastered_by_Ezekiel.7z.html" # [164] Infernus HD Remastered by Ezekiel
    "https://sharemods.com/jwztx8xur9nc/AI_Upscaled_Weapon_Textures_and_Icons.7z.html" # [165] [SA] Improved Original Weapons (mod pack)
    "https://sharemods.com/s39vzt0qts03/Taurus_M972.7z.html" # [166] Arma Taurus M972/MT12 (brasileira) (lowpoly)
    "https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html" # [167] IndieVehicles
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 10/14 enviado para o navegador com sucesso!"

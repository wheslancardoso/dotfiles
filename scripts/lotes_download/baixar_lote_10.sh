#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 10 DE 16 NO BRAVE (Mods 136 a 150) ==="

URLS=(
    "https://sharemods.com/wyg3bh7dgbro/Big_Gangster_Mod.7z.html" # [154] Big Gangster Mod (mais gangues)
    "https://sharemods.com/r17sebrganh9/Deluxo.7z.html" # [155] 86′ Deluxo (SA style)
    "https://sharemods.com/nkqrfzf2uxti/Comet_Plus.7z.html" # [156] Comet Plus+ (SA style)
    "https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view" # [157] 90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [158] Shadows Settings Extender v2.1.2 (extensor de sombras)
    "https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html" # [159] Wayfarer Plus+ (sa style)
    "https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html" # [160] Dream Grass (grama HD do GTA V)
    "https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html" # [161] Grip Animation (nova animação de segurar arma)
    "https://sharemods.com/cgdkdrp91z28/Military_Animation.7z.html" # [162] Military Animation v9 (unofficial fix)
    "https://sharemods.com/uhuafeex1b5x/VW_Gol_G1_GTI_2000_Turbo.7z.html" # [163] VW Gol G1 GTI 2000 Turbo
    "https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html" # [164] ImVehFt – Improved Vehicle Features
    "https://sharemods.com/x0i8t4lx8ayo/Snowmobile_SA_style.7z.html" # [165] Snowmobile (SA style)
    "https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html" # [166] Rename vehicles (car names.fxt)
    "https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html" # [167] NRG-500 Remastered HD by Ezekiel
    "https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html" # [168] Ford Focus ZX3/SVT 2000-2004 by Avant
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 10/16 enviado para o navegador com sucesso!"

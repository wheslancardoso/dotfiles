#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 10 DE 17 NO BRAVE (Mods 136 a 150) ==="

URLS=(
    "https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html" # [153] Dream Grass (grama HD do GTA V)
    "https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html" # [154] Grip Animation (nova animação de segurar arma)
    "https://sharemods.com/cgdkdrp91z28/Military_Animation.7z.html" # [155] Military Animation v9 (unofficial fix)
    "https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html" # [156] ImVehFt – Improved Vehicle Features
    "https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html" # [157] Rename vehicles (car names.fxt)
    "https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html" # [158] NRG-500 Remastered HD by Ezekiel
    "https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html" # [159] Ford Focus ZX3/SVT 2000-2004 by Avant
    "https://sharemods.com/5xnjtf8aab38/Infernus_HD_Remastered_by_Ezekiel.7z.html" # [160] Infernus HD Remastered by Ezekiel
    "https://sharemods.com/jwztx8xur9nc/AI_Upscaled_Weapon_Textures_and_Icons.7z.html" # [161] [SA] Improved Original Weapons (mod pack)
    "https://sharemods.com/s39vzt0qts03/Taurus_M972.7z.html" # [162] Arma Taurus M972/MT12 (brasileira) (lowpoly)
    "https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html" # [163] IndieVehicles
    "https://sharemods.com/3duli5cpn9bb/ImGui.7z.html" # [164] ImGui (interface gráfica para MoonLoader)
    "https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html" # [165] Low Life Animation v1.2.2 (animação de saúde baixa)
    "https://sharemods.com/dh3hh64cs3wg/Tuning_Mod_v3.7z.html" # [166] Tuning Mod v3.0.1
    "https://sharemods.com/82ph468pxbvm/Kawasaki_Ninja_H2R_2019.7z.html" # [167] Kawasaki Ninja H2R 2019
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 10/17 enviado para o navegador com sucesso!"

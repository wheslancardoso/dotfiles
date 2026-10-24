#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 11 DE 19 NO BRAVE (Mods 151 a 165) ==="

URLS=(
    "https://sharemods.com/vqvsr7ykuobm/ModdedSAA.7z.html" # [168] ModdedSAA (carregar arquivos bloqueados no SAMP)
    "https://sharemods.com/uhuafeex1b5x/VW_Gol_G1_GTI_2000_Turbo.7z.html" # [169] VW Gol G1 GTI 2000 Turbo
    "https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html" # [170] ImVehFt – Improved Vehicle Features
    "https://sharemods.com/x0i8t4lx8ayo/Snowmobile_SA_style.7z.html" # [171] Snowmobile (SA style)
    "https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html" # [172] Rename vehicles (car names.fxt)
    "https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html" # [173] NRG-500 Remastered HD by Ezekiel
    "https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html" # [174] Ford Focus ZX3/SVT 2000-2004 by Avant
    "https://sharemods.com/5xnjtf8aab38/Infernus_HD_Remastered_by_Ezekiel.7z.html" # [175] Infernus HD Remastered by Ezekiel
    "https://sharemods.com/jwztx8xur9nc/AI_Upscaled_Weapon_Textures_and_Icons.7z.html" # [176] [SA] Improved Original Weapons (mod pack)
    "https://sharemods.com/s39vzt0qts03/Taurus_M972.7z.html" # [177] Arma Taurus M972/MT12 (brasileira) (lowpoly)
    "https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html" # [178] IndieVehicles
    "https://sharemods.com/3duli5cpn9bb/ImGui.7z.html" # [179] ImGui (interface gráfica para MoonLoader)
    "https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html" # [180] Low Life Animation v1.2.2 (animação de saúde baixa)
    "https://sharemods.com/dh3hh64cs3wg/Tuning_Mod_v3.7z.html" # [181] Tuning Mod v3.0.1
    "https://sharemods.com/82ph468pxbvm/Kawasaki_Ninja_H2R_2019.7z.html" # [182] Kawasaki Ninja H2R 2019
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 11/19 enviado para o navegador com sucesso!"

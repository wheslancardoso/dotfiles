#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 12 DE 17 NO BRAVE (Mods 166 a 180) ==="

URLS=(
    "https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html" # [184] Grip Animation (nova animação de segurar arma)
    "https://sharemods.com/cgdkdrp91z28/Military_Animation.7z.html" # [185] Military Animation v9 (unofficial fix)
    "https://sharemods.com/vqvsr7ykuobm/ModdedSAA.7z.html" # [186] ModdedSAA (carregar arquivos bloqueados no SAMP)
    "https://sharemods.com/uhuafeex1b5x/VW_Gol_G1_GTI_2000_Turbo.7z.html" # [187] VW Gol G1 GTI 2000 Turbo
    "https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html" # [188] ImVehFt – Improved Vehicle Features
    "https://sharemods.com/x0i8t4lx8ayo/Snowmobile_SA_style.7z.html" # [189] Snowmobile (SA style)
    "https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html" # [190] Rename vehicles (car names.fxt)
    "https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html" # [191] NRG-500 Remastered HD by Ezekiel
    "https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html" # [192] Ford Focus ZX3/SVT 2000-2004 by Avant
    "https://sharemods.com/5xnjtf8aab38/Infernus_HD_Remastered_by_Ezekiel.7z.html" # [193] Infernus HD Remastered by Ezekiel
    "https://sharemods.com/jwztx8xur9nc/AI_Upscaled_Weapon_Textures_and_Icons.7z.html" # [194] [SA] Improved Original Weapons (mod pack)
    "https://sharemods.com/s39vzt0qts03/Taurus_M972.7z.html" # [195] Arma Taurus M972/MT12 (brasileira) (lowpoly)
    "https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html" # [196] IndieVehicles
    "https://sharemods.com/3duli5cpn9bb/ImGui.7z.html" # [197] ImGui (interface gráfica para MoonLoader)
    "https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html" # [198] Low Life Animation v1.2.2 (animação de saúde baixa)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 12/17 enviado para o navegador com sucesso!"

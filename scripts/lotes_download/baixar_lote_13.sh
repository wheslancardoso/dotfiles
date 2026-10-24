#!/usr/bin/env bash
echo "=== ABRINDO LOTE 13 DE 18 NO BRAVE (Mods 181 a 195) ==="
URLS=(
    "https://sharemods.com/9is4rzz7fd7w/Cartoon_Mod_Fixed.7z.html" # [181] Cartoon Mod Fixed (texturas e gráficos cartoon)
    "https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html" # [182] Dream Grass (grama HD do GTA V)
    "https://www.mixmods.com.br/2020/03/reshade-tutorial-de-como-usar/" # [183] ReShade + Tutorial de como usar
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
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

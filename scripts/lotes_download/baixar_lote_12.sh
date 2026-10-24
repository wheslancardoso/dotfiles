#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 12 DE 20 NO BRAVE (Mods 166 a 180) ==="

URLS=(
    "https://sharemods.com/ytebfstop2as/NRG_500_Remastered_by_Ezekiel.7z.html" # [183] NRG-500 Remastered HD by Ezekiel
    "https://sharemods.com/rqgayynoe9ly/Ford_Focus_ZX3-SVT_2000-2004_Low-High_Trim.7z.html" # [184] Ford Focus ZX3/SVT 2000-2004 by Avant
    "https://sharemods.com/5xnjtf8aab38/Infernus_HD_Remastered_by_Ezekiel.7z.html" # [185] Infernus HD Remastered by Ezekiel
    "https://sharemods.com/jwztx8xur9nc/AI_Upscaled_Weapon_Textures_and_Icons.7z.html" # [186] [SA] Improved Original Weapons (mod pack)
    "https://sharemods.com/s39vzt0qts03/Taurus_M972.7z.html" # [187] Arma Taurus M972/MT12 (brasileira) (lowpoly)
    "https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html" # [188] IndieVehicles
    "https://sharemods.com/3duli5cpn9bb/ImGui.7z.html" # [189] ImGui (interface gráfica para MoonLoader)
    "https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html" # [190] Low Life Animation v1.2.2 (animação de saúde baixa)
    "https://sharemods.com/dh3hh64cs3wg/Tuning_Mod_v3.7z.html" # [191] Tuning Mod v3.0.1
    "https://sharemods.com/82ph468pxbvm/Kawasaki_Ninja_H2R_2019.7z.html" # [192] Kawasaki Ninja H2R 2019
    "https://sharemods.com/kah8arfbnvx0/Panic_Face.7z.html" # [193] Panic Face (expressão facial nos pedestres)
    "https://sharemods.com/8zyh3jyrt3hs/Revive_Friend_-_Junior_Djjr.7z.html" # [194] Revive Friend (reanimar parceiro)
    "https://sharemods.com/2sny0oq1g1m6/Sly_Veh_Textures_Unofficial_Build.7z.html" # [195] Sly’s Veh Textures Unofficial Build v1 (vehicle.txd HD)
    "https://sharemods.com/cuews8z5k6ew/Change_Gear_Anim.7z.html" # [196] Change Gear Anim v3.2 (animação de mudar marcha)
    "https://sharemods.com/nt2bhj7tspt9/Airsoft_Glock_18C.7z.html" # [197] Mod Airsoft + Glock 18C
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 12/20 enviado para o navegador com sucesso!"

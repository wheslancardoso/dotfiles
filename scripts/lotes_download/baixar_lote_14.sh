#!/usr/bin/env bash
echo "=== ABRINDO LOTE 14 DE 18 NO BRAVE (Mods 196 a 210) ==="
URLS=(
    "https://sharemods.com/p8e8cq5qdr4k/IndieVehicles.7z.html" # [196] IndieVehicles
    "https://sharemods.com/3duli5cpn9bb/ImGui.7z.html" # [197] ImGui (interface gráfica para MoonLoader)
    "https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html" # [198] Low Life Animation v1.2.2 (animação de saúde baixa)
    "https://sharemods.com/dh3hh64cs3wg/Tuning_Mod_v3.7z.html" # [199] Tuning Mod v3.0.1
    "https://sharemods.com/82ph468pxbvm/Kawasaki_Ninja_H2R_2019.7z.html" # [200] Kawasaki Ninja H2R 2019
    "https://sharemods.com/kah8arfbnvx0/Panic_Face.7z.html" # [201] Panic Face (expressão facial nos pedestres)
    "https://sharemods.com/8zyh3jyrt3hs/Revive_Friend_-_Junior_Djjr.7z.html" # [202] Revive Friend (reanimar parceiro)
    "https://sharemods.com/2sny0oq1g1m6/Sly_Veh_Textures_Unofficial_Build.7z.html" # [203] Sly’s Veh Textures Unofficial Build v1 (vehicle.txd HD)
    "https://sharemods.com/cuews8z5k6ew/Change_Gear_Anim.7z.html" # [204] Change Gear Anim v3.2 (animação de mudar marcha)
    "https://sharemods.com/nt2bhj7tspt9/Airsoft_Glock_18C.7z.html" # [205] Mod Airsoft + Glock 18C
    "https://sharemods.com/sjhzmtv05o0t/Gangs_relationships.7z.html" # [206] Gangs Relationships
    "https://sharemods.com/zzblq4idkq1p/BeSlim.7z.html" # [207] BeSlim (opções para o CJ musculoso e gordo)
    "https://sharemods.com/cp2ftd9u0re3/Land_Mines.7z.html" # [208] Land Mines (minas terrestres)
    "https://www.mixmods.com.br/2019/02/tutorial-adicionar-armas-sem-substituir/" # [209] [Tutorial] Adicionar armas sem substituir
    "https://sharemods.com/hiy3o47xxd7w/Car_Kick.7z.html" # [210] Car Kick (chutar motorista pela janela do carro)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

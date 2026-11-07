#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 11 DE 14 NO BRAVE (Mods 151 a 165) ==="

URLS=(
    "https://sharemods.com/3duli5cpn9bb/ImGui.7z.html" # [168] ImGui (interface gráfica para MoonLoader)
    "https://sharemods.com/iey3goqj7yma/Low_Life_Animation.7z.html" # [169] Low Life Animation v1.2.2 (animação de saúde baixa)
    "https://sharemods.com/dh3hh64cs3wg/Tuning_Mod_v3.7z.html" # [170] Tuning Mod v3.0.1
    "https://sharemods.com/82ph468pxbvm/Kawasaki_Ninja_H2R_2019.7z.html" # [171] Kawasaki Ninja H2R 2019
    "https://sharemods.com/kah8arfbnvx0/Panic_Face.7z.html" # [172] Panic Face (expressão facial nos pedestres)
    "https://sharemods.com/8zyh3jyrt3hs/Revive_Friend_-_Junior_Djjr.7z.html" # [173] Revive Friend (reanimar parceiro)
    "https://sharemods.com/2sny0oq1g1m6/Sly_Veh_Textures_Unofficial_Build.7z.html" # [174] Sly’s Veh Textures Unofficial Build v1 (vehicle.txd HD)
    "https://sharemods.com/cuews8z5k6ew/Change_Gear_Anim.7z.html" # [175] Change Gear Anim v3.2 (animação de mudar marcha)
    "https://sharemods.com/sjhzmtv05o0t/Gangs_relationships.7z.html" # [176] Gangs Relationships
    "https://sharemods.com/zzblq4idkq1p/BeSlim.7z.html" # [177] BeSlim (opções para o CJ musculoso e gordo)
    "https://sharemods.com/cp2ftd9u0re3/Land_Mines.7z.html" # [178] Land Mines (minas terrestres)
    "https://www.mixmods.com.br/2019/02/tutorial-adicionar-armas-sem-substituir/" # [179] [Tutorial] Adicionar armas sem substituir
    "https://sharemods.com/hiy3o47xxd7w/Car_Kick.7z.html" # [180] Car Kick (chutar motorista pela janela do carro)
    "https://sharemods.com/9fu5fbdw3e5h/Kawasaki_Z1000_A1_1977.7z.html" # [181] Kawasaki Z1000 A1 1977
    "https://sharemods.com/vj9mky5k373a/Plymouth_Belvedere_Station_Wagon_1965_by_Avant.7z.html" # [182] Plymouth Belvedere Station Wagon 1965 by Avant
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 11/14 enviado para o navegador com sucesso!"

#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 11 DE 17 NO BRAVE (Mods 151 a 165) ==="

URLS=(
    "https://sharemods.com/kah8arfbnvx0/Panic_Face.7z.html" # [168] Panic Face (expressão facial nos pedestres)
    "https://sharemods.com/8zyh3jyrt3hs/Revive_Friend_-_Junior_Djjr.7z.html" # [169] Revive Friend (reanimar parceiro)
    "https://sharemods.com/2sny0oq1g1m6/Sly_Veh_Textures_Unofficial_Build.7z.html" # [170] Sly’s Veh Textures Unofficial Build v1 (vehicle.txd HD)
    "https://sharemods.com/cuews8z5k6ew/Change_Gear_Anim.7z.html" # [171] Change Gear Anim v3.2 (animação de mudar marcha)
    "https://sharemods.com/sjhzmtv05o0t/Gangs_relationships.7z.html" # [172] Gangs Relationships
    "https://sharemods.com/zzblq4idkq1p/BeSlim.7z.html" # [173] BeSlim (opções para o CJ musculoso e gordo)
    "https://sharemods.com/cp2ftd9u0re3/Land_Mines.7z.html" # [174] Land Mines (minas terrestres)
    "https://sharemods.com/hiy3o47xxd7w/Car_Kick.7z.html" # [175] Car Kick (chutar motorista pela janela do carro)
    "https://sharemods.com/9fu5fbdw3e5h/Kawasaki_Z1000_A1_1977.7z.html" # [176] Kawasaki Z1000 A1 1977
    "https://sharemods.com/vj9mky5k373a/Plymouth_Belvedere_Station_Wagon_1965_by_Avant.7z.html" # [177] Plymouth Belvedere Station Wagon 1965 by Avant
    "https://sharemods.com/1pshm7jmw1tf/Anim_Play.7z.html" # [178] Anim Play v2.0 (tocar animações)
    "https://sharemods.com/8dy2ncqtysbg/Surrender.7z.html" # [179] Surrender Mod (se render / se entregar)
    "https://sharemods.com/b8q8e55loi0q/Original_Weapons_Fix___Retex.7z.html" # [180] Original Weapons Fix 2.0 + Retex (corrigir posição das armas)
    "https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html" # [181] Correr com armas pesadas (correr com rifle)
    "https://sharemods.com/ry8wc7z7bnaf/Handbrake_Mod.7z.html" # [182] Handbrake Mod [sound + anim] (freio de mão com som e anim)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 11/17 enviado para o navegador com sucesso!"

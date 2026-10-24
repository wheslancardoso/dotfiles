#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 13 DE 20 NO BRAVE (Mods 181 a 195) ==="

URLS=(
    "https://sharemods.com/sjhzmtv05o0t/Gangs_relationships.7z.html" # [198] Gangs Relationships
    "https://sharemods.com/zzblq4idkq1p/BeSlim.7z.html" # [199] BeSlim (opções para o CJ musculoso e gordo)
    "https://sharemods.com/cp2ftd9u0re3/Land_Mines.7z.html" # [200] Land Mines (minas terrestres)
    "https://sharemods.com/hiy3o47xxd7w/Car_Kick.7z.html" # [201] Car Kick (chutar motorista pela janela do carro)
    "https://sharemods.com/9fu5fbdw3e5h/Kawasaki_Z1000_A1_1977.7z.html" # [202] Kawasaki Z1000 A1 1977
    "https://sharemods.com/vj9mky5k373a/Plymouth_Belvedere_Station_Wagon_1965_by_Avant.7z.html" # [203] Plymouth Belvedere Station Wagon 1965 by Avant
    "https://sharemods.com/1pshm7jmw1tf/Anim_Play.7z.html" # [204] Anim Play v2.0 (tocar animações)
    "https://sharemods.com/8dy2ncqtysbg/Surrender.7z.html" # [205] Surrender Mod (se render / se entregar)
    "https://sharemods.com/b8q8e55loi0q/Original_Weapons_Fix___Retex.7z.html" # [206] Original Weapons Fix 2.0 + Retex (corrigir posição das armas)
    "https://sharemods.com/vf80kq9lsrhq/VW_Gol_G2_1.0_Plus___40_bola__41__by_Den_3D.7z.html" # [207] VW Gol G2 1.0 Plus (bola) by Dean 3D
    "https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html" # [208] Correr com armas pesadas (correr com rifle)
    "https://sharemods.com/ry8wc7z7bnaf/Handbrake_Mod.7z.html" # [209] Handbrake Mod [sound + anim] (freio de mão com som e anim)
    "https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html" # [210] Espingarda boito caipira (country bolt rifle) (lowpoly)
    "https://drive.google.com/file/d/1VgA-z5reCSf0NQDIMuP_pinkftjWKj1w/view?usp=sharing" # [211] Pack de Armas do Combat Arms
    "http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html" # [212] 1964 Chevrolet Impala SS Lowrider v2.1
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 13/20 enviado para o navegador com sucesso!"

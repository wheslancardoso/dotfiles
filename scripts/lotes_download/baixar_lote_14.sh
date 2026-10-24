#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 14 DE 17 NO BRAVE (Mods 196 a 210) ==="

URLS=(
    "https://sharemods.com/8dy2ncqtysbg/Surrender.7z.html" # [214] Surrender Mod (se render / se entregar)
    "https://sharemods.com/b8q8e55loi0q/Original_Weapons_Fix___Retex.7z.html" # [215] Original Weapons Fix 2.0 + Retex (corrigir posição das armas)
    "https://sharemods.com/vf80kq9lsrhq/VW_Gol_G2_1.0_Plus___40_bola__41__by_Den_3D.7z.html" # [216] VW Gol G2 1.0 Plus (bola) by Dean 3D
    "https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html" # [217] Correr com armas pesadas (correr com rifle)
    "https://sharemods.com/ry8wc7z7bnaf/Handbrake_Mod.7z.html" # [218] Handbrake Mod [sound + anim] (freio de mão com som e anim)
    "https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html" # [219] Espingarda boito caipira (country bolt rifle) (lowpoly)
    "https://drive.google.com/file/d/1VgA-z5reCSf0NQDIMuP_pinkftjWKj1w/view?usp=sharing" # [220] Pack de Armas do Combat Arms
    "http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html" # [221] 1964 Chevrolet Impala SS Lowrider v2.1
    "http://sharemods.com/2lo0mhpepqff/Beta_Cars_Pack.7z.html" # [222] Beta Cars Pack (carros da versão beta)
    "http://sharemods.com/vm0zc1olju4k/Rainbow_Weapons.7z.html" # [223] Rainbow Weapons (armas coloridas animadas)
    "http://sharemods.com/kuyzylh9du4i/LQ_Wheels__rodas_tuning_lowpoly_SA_Style_.7z.html" # [224] LQ Wheels (rodas tuning lowpoly / SA Style)
    "https://sharemods.com/gi2txs6hwidv/Honda_CRX_by_AllCash.7z.html" # [225] Honda CRX by AllCash (tunable – tunável)
    "http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html" # [226] Big Gangster Mod v5
    "http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html" # [227] Se jogar para esquivar de carros
    "http://sharemods.com/4q0zw5rsc74h/Fortnite_Pack.7z.html" # [228] Pack de armas e sons do Fortnite
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 14/17 enviado para o navegador com sucesso!"

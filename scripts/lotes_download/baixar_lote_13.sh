#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 13 DE 19 NO BRAVE (Mods 181 a 195) ==="

URLS=(
    "https://sharemods.com/vf80kq9lsrhq/VW_Gol_G2_1.0_Plus___40_bola__41__by_Den_3D.7z.html" # [198] VW Gol G2 1.0 Plus (bola) by Dean 3D
    "https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html" # [199] Correr com armas pesadas (correr com rifle)
    "https://sharemods.com/ry8wc7z7bnaf/Handbrake_Mod.7z.html" # [200] Handbrake Mod [sound + anim] (freio de mão com som e anim)
    "https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html" # [201] Espingarda boito caipira (country bolt rifle) (lowpoly)
    "https://drive.google.com/file/d/1VgA-z5reCSf0NQDIMuP_pinkftjWKj1w/view?usp=sharing" # [202] Pack de Armas do Combat Arms
    "http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html" # [203] 1964 Chevrolet Impala SS Lowrider v2.1
    "http://sharemods.com/2lo0mhpepqff/Beta_Cars_Pack.7z.html" # [204] Beta Cars Pack (carros da versão beta)
    "http://sharemods.com/vm0zc1olju4k/Rainbow_Weapons.7z.html" # [205] Rainbow Weapons (armas coloridas animadas)
    "http://sharemods.com/kuyzylh9du4i/LQ_Wheels__rodas_tuning_lowpoly_SA_Style_.7z.html" # [206] LQ Wheels (rodas tuning lowpoly / SA Style)
    "https://sharemods.com/gi2txs6hwidv/Honda_CRX_by_AllCash.7z.html" # [207] Honda CRX by AllCash (tunable – tunável)
    "http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html" # [208] Big Gangster Mod v5
    "http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html" # [209] Se jogar para esquivar de carros
    "http://sharemods.com/4q0zw5rsc74h/Fortnite_Pack.7z.html" # [210] Pack de armas e sons do Fortnite
    "http://sharemods.com/zsw83kwdd2ag/Anima____es_de_Kung_Fu_melhoradas.7z.html" # [211] Animações de Kung Fu melhoradas
    "http://sharemods.com/vgxjuwx0joou/SASD_Carpack_by_MCHammer.7z.html" # [212] SASD Carpack by MCHammer (pack polícia SA Style)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 13/19 enviado para o navegador com sucesso!"

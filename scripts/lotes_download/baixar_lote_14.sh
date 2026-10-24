#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 14 DE 20 NO BRAVE (Mods 196 a 210) ==="

URLS=(
    "https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html" # [213] Espingarda boito caipira (country bolt rifle) (lowpoly)
    "https://drive.google.com/file/d/1VgA-z5reCSf0NQDIMuP_pinkftjWKj1w/view?usp=sharing" # [214] Pack de Armas do Combat Arms
    "http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html" # [215] 1964 Chevrolet Impala SS Lowrider v2.1
    "http://sharemods.com/2lo0mhpepqff/Beta_Cars_Pack.7z.html" # [216] Beta Cars Pack (carros da versão beta)
    "http://sharemods.com/vm0zc1olju4k/Rainbow_Weapons.7z.html" # [217] Rainbow Weapons (armas coloridas animadas)
    "http://sharemods.com/kuyzylh9du4i/LQ_Wheels__rodas_tuning_lowpoly_SA_Style_.7z.html" # [218] LQ Wheels (rodas tuning lowpoly / SA Style)
    "https://sharemods.com/gi2txs6hwidv/Honda_CRX_by_AllCash.7z.html" # [219] Honda CRX by AllCash (tunable – tunável)
    "http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html" # [220] Big Gangster Mod v5
    "http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html" # [221] Se jogar para esquivar de carros
    "http://sharemods.com/4q0zw5rsc74h/Fortnite_Pack.7z.html" # [222] Pack de armas e sons do Fortnite
    "http://sharemods.com/zsw83kwdd2ag/Anima____es_de_Kung_Fu_melhoradas.7z.html" # [223] Animações de Kung Fu melhoradas
    "http://sharemods.com/vgxjuwx0joou/SASD_Carpack_by_MCHammer.7z.html" # [224] SASD Carpack by MCHammer (pack polícia SA Style)
    "http://sharemods.com/cchq803ez667/Desert_Eagle_Mark_XIX.7z.html" # [225] EnhFuncs – Desert Eagle Mark XIX
    "http://sharemods.com/d1ougyt80b8r/Mount_Akina___Toyota_AE86.7z.html" # [226] Mount Akina + Toyota AE86 Trueno
    "http://sharemods.com/bi6t0xqvr5jj/CJ_reclama_com_carros_2.7z.html" # [227] CJ reclama com carros
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 14/20 enviado para o navegador com sucesso!"

#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 12 DE 14 NO BRAVE (Mods 166 a 180) ==="

URLS=(
    "https://sharemods.com/1pshm7jmw1tf/Anim_Play.7z.html" # [183] Anim Play v2.0 (tocar animações)
    "https://sharemods.com/8dy2ncqtysbg/Surrender.7z.html" # [184] Surrender Mod (se render / se entregar)
    "https://sharemods.com/b8q8e55loi0q/Original_Weapons_Fix___Retex.7z.html" # [185] Original Weapons Fix 2.0 + Retex (corrigir posição das armas)
    "https://sharemods.com/zxvhj5rtn1jr/Sprinting_With_Two_Handed_Weapons.7z.html" # [186] Correr com armas pesadas (correr com rifle)
    "https://sharemods.com/ry8wc7z7bnaf/Handbrake_Mod.7z.html" # [187] Handbrake Mod [sound + anim] (freio de mão com som e anim)
    "https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html" # [188] Espingarda boito caipira (country bolt rifle) (lowpoly)
    "http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html" # [189] 1964 Chevrolet Impala SS Lowrider v2.1
    "http://sharemods.com/2lo0mhpepqff/Beta_Cars_Pack.7z.html" # [190] Beta Cars Pack (carros da versão beta)
    "http://sharemods.com/kuyzylh9du4i/LQ_Wheels__rodas_tuning_lowpoly_SA_Style_.7z.html" # [191] LQ Wheels (rodas tuning lowpoly / SA Style)
    "https://sharemods.com/gi2txs6hwidv/Honda_CRX_by_AllCash.7z.html" # [192] Honda CRX by AllCash (tunable – tunável)
    "http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html" # [193] Big Gangster Mod v5
    "http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html" # [194] Se jogar para esquivar de carros
    "http://sharemods.com/zsw83kwdd2ag/Anima____es_de_Kung_Fu_melhoradas.7z.html" # [195] Animações de Kung Fu melhoradas
    "http://sharemods.com/vgxjuwx0joou/SASD_Carpack_by_MCHammer.7z.html" # [196] SASD Carpack by MCHammer (pack polícia SA Style)
    "http://sharemods.com/cchq803ez667/Desert_Eagle_Mark_XIX.7z.html" # [197] EnhFuncs – Desert Eagle Mark XIX
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 12/14 enviado para o navegador com sucesso!"

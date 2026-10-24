#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 12 DE 17 NO BRAVE (Mods 166 a 180) ==="

URLS=(
    "https://sharemods.com/agzcmqzekvof/Espingarda_boito.7z.html" # [183] Espingarda boito caipira (country bolt rifle) (lowpoly)
    "http://sharemods.com/cohrl1eh7rnn/1964_Chevrolet_Impala_SS.7z.html" # [184] 1964 Chevrolet Impala SS Lowrider v2.1
    "http://sharemods.com/2lo0mhpepqff/Beta_Cars_Pack.7z.html" # [185] Beta Cars Pack (carros da versão beta)
    "http://sharemods.com/kuyzylh9du4i/LQ_Wheels__rodas_tuning_lowpoly_SA_Style_.7z.html" # [186] LQ Wheels (rodas tuning lowpoly / SA Style)
    "https://sharemods.com/gi2txs6hwidv/Honda_CRX_by_AllCash.7z.html" # [187] Honda CRX by AllCash (tunable – tunável)
    "http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html" # [188] Big Gangster Mod v5
    "http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html" # [189] Se jogar para esquivar de carros
    "http://sharemods.com/zsw83kwdd2ag/Anima____es_de_Kung_Fu_melhoradas.7z.html" # [190] Animações de Kung Fu melhoradas
    "http://sharemods.com/vgxjuwx0joou/SASD_Carpack_by_MCHammer.7z.html" # [191] SASD Carpack by MCHammer (pack polícia SA Style)
    "http://sharemods.com/cchq803ez667/Desert_Eagle_Mark_XIX.7z.html" # [192] EnhFuncs – Desert Eagle Mark XIX
    "http://sharemods.com/bi6t0xqvr5jj/CJ_reclama_com_carros_2.7z.html" # [193] CJ reclama com carros
    "http://sharemods.com/2yhtn7ed2utl/GTA_Online_Anims.7z.html" # [194] GTA V Online Original Anims to SA (animações do GTA Online)
    "http://sharemods.com/y7ny6i33w58q/Parkour_Mod.7z.html" # [195] Parkour Mod v2.0.4 Unofficial Fix
    "http://sharemods.com/1osrp4cxex04/Infernus_HD_by_Ezekiel.7z.html" # [196] Infernus HD by Ezekiel
    "http://sharemods.com/81id5unk7jky/Shotgun_Reload.7z.html" # [197] Shotgun Reload (espingarda recarregando)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 12/17 enviado para o navegador com sucesso!"

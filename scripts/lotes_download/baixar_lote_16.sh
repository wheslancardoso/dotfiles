#!/usr/bin/env bash
echo "=== ABRINDO LOTE 16 DE 18 NO BRAVE (Mods 226 a 240) ==="
URLS=(
    "http://sharemods.com/00izlnuf1r76/Big_Gangster.7z.html" # [226] Big Gangster Mod v5
    "http://sharemods.com/48eldouiaq1e/Se_jogar_para_esquivar_de_carros.7z.html" # [227] Se jogar para esquivar de carros
    "http://sharemods.com/4q0zw5rsc74h/Fortnite_Pack.7z.html" # [228] Pack de armas e sons do Fortnite
    "http://sharemods.com/zsw83kwdd2ag/Anima____es_de_Kung_Fu_melhoradas.7z.html" # [229] Animações de Kung Fu melhoradas
    "http://sharemods.com/vgxjuwx0joou/SASD_Carpack_by_MCHammer.7z.html" # [230] SASD Carpack by MCHammer (pack polícia SA Style)
    "http://sharemods.com/cchq803ez667/Desert_Eagle_Mark_XIX.7z.html" # [231] EnhFuncs – Desert Eagle Mark XIX
    "http://sharemods.com/d1ougyt80b8r/Mount_Akina___Toyota_AE86.7z.html" # [232] Mount Akina + Toyota AE86 Trueno
    "http://sharemods.com/bi6t0xqvr5jj/CJ_reclama_com_carros_2.7z.html" # [233] CJ reclama com carros
    "http://sharemods.com/lzxs1w77ffh6/London_Cabbie.7z.html" # [234] London Cabbie
    "http://sharemods.com/bgd4a3kbdjfw/Ganados__Mod_Resident_Evil_4_.7z.html" # [235] Ganados v2.0 (Mod Resident Evil 4)
    "http://sharemods.com/2yhtn7ed2utl/GTA_Online_Anims.7z.html" # [236] GTA V Online Original Anims to SA (animações do GTA Online)
    "http://sharemods.com/y7ny6i33w58q/Parkour_Mod.7z.html" # [237] Parkour Mod v2.0.4 Unofficial Fix
    "http://sharemods.com/wpmcvchn1nly/Trator_Valtra_685___carreta__SA_Style_.7z.html" # [238] Trator Valtra 685 + carreta (SA Style)
    "http://sharemods.com/1osrp4cxex04/Infernus_HD_by_Ezekiel.7z.html" # [239] Infernus HD by Ezekiel
    "https://www.mixmods.com.br/2018/02/pack-de-armas-do-battlegrounds/" # [240] Pack de armas do Battlegrounds
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

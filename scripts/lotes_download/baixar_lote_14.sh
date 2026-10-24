#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 14 DE 19 NO BRAVE (Mods 196 a 210) ==="

URLS=(
    "http://sharemods.com/cchq803ez667/Desert_Eagle_Mark_XIX.7z.html" # [213] EnhFuncs – Desert Eagle Mark XIX
    "http://sharemods.com/d1ougyt80b8r/Mount_Akina___Toyota_AE86.7z.html" # [214] Mount Akina + Toyota AE86 Trueno
    "http://sharemods.com/bi6t0xqvr5jj/CJ_reclama_com_carros_2.7z.html" # [215] CJ reclama com carros
    "http://sharemods.com/lzxs1w77ffh6/London_Cabbie.7z.html" # [216] London Cabbie
    "http://sharemods.com/bgd4a3kbdjfw/Ganados__Mod_Resident_Evil_4_.7z.html" # [217] Ganados v2.0 (Mod Resident Evil 4)
    "http://sharemods.com/2yhtn7ed2utl/GTA_Online_Anims.7z.html" # [218] GTA V Online Original Anims to SA (animações do GTA Online)
    "http://sharemods.com/y7ny6i33w58q/Parkour_Mod.7z.html" # [219] Parkour Mod v2.0.4 Unofficial Fix
    "http://sharemods.com/wpmcvchn1nly/Trator_Valtra_685___carreta__SA_Style_.7z.html" # [220] Trator Valtra 685 + carreta (SA Style)
    "http://sharemods.com/1osrp4cxex04/Infernus_HD_by_Ezekiel.7z.html" # [221] Infernus HD by Ezekiel
    "https://www.mixmods.com.br/2018/02/pack-de-armas-do-battlegrounds/" # [222] Pack de armas do Battlegrounds
    "http://sharemods.com/81id5unk7jky/Shotgun_Reload.7z.html" # [223] Shotgun Reload (espingarda recarregando)
    "https://drive.google.com/file/d/1wnWITLTGQAuqLgB14bTWSjSk_CYxR0S2/view" # [224] Bar Drink (mod beber no bar / ficar bêbado)
    "https://drive.google.com/open?id=1asrLFdaJ702-Cy-Kqw0m6zTfEPK3Iho0" # [225] Animações do GTA VCS/LCS
    "https://drive.google.com/open?id=1Da9MWJ3qROTT62rnRwHM9AD1V7vwHEO9" # [226] Arremessar facas ou katanas
    "https://drive.google.com/file/d/1Gjx78UjDyXcKxQz37vdK17C9WGwfz5ap/view" # [227] Arma IMBEL IA2 (brasileira) (lowpoly)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 14/19 enviado para o navegador com sucesso!"

#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 15 DE 20 NO BRAVE (Mods 211 a 225) ==="

URLS=(
    "http://sharemods.com/y7ny6i33w58q/Parkour_Mod.7z.html" # [228] Parkour Mod v2.0.4 Unofficial Fix
    "http://sharemods.com/wpmcvchn1nly/Trator_Valtra_685___carreta__SA_Style_.7z.html" # [229] Trator Valtra 685 + carreta (SA Style)
    "http://sharemods.com/1osrp4cxex04/Infernus_HD_by_Ezekiel.7z.html" # [230] Infernus HD by Ezekiel
    "https://www.mixmods.com.br/2018/02/pack-de-armas-do-battlegrounds/" # [231] Pack de armas do Battlegrounds
    "http://sharemods.com/81id5unk7jky/Shotgun_Reload.7z.html" # [232] Shotgun Reload (espingarda recarregando)
    "https://drive.google.com/file/d/1wnWITLTGQAuqLgB14bTWSjSk_CYxR0S2/view" # [233] Bar Drink (mod beber no bar / ficar bêbado)
    "https://drive.google.com/open?id=1asrLFdaJ702-Cy-Kqw0m6zTfEPK3Iho0" # [234] Animações do GTA VCS/LCS
    "https://drive.google.com/open?id=1Da9MWJ3qROTT62rnRwHM9AD1V7vwHEO9" # [235] Arremessar facas ou katanas
    "https://drive.google.com/file/d/1Gjx78UjDyXcKxQz37vdK17C9WGwfz5ap/view" # [236] Arma IMBEL IA2 (brasileira) (lowpoly)
    "https://drive.google.com/open?id=1fWs2vr_sJv7djPRxDX3CI_4XsA6BDWsO" # [237] M4k3’s New Car Animations – Novas animações ao dirigir
    "https://drive.google.com/open?id=1zgWe0bejROV0cdFQDR6zTr0-E7zK2bKD" # [238] Max Payne Mod
    "https://drive.google.com/file/d/0B1sAJQAUfOOYNjhwLXFQTWFneG8/view" # [239] Amazing Player: Female v2.0 (skin feminina)
    "https://www.mixmods.com.br/2017/10/pack-de-skins-da-ak-47-do-csgo/" # [240] Pack de Skins da AK-47 do CS:GO
    "https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html" # [241] Pose Mod (beta)
    "https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc" # [242] Explosivo TNT (relógio com detonador)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 15/20 enviado para o navegador com sucesso!"

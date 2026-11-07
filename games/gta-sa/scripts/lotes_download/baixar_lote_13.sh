#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 13 DE 14 NO BRAVE (Mods 181 a 195) ==="

URLS=(
    "http://sharemods.com/bi6t0xqvr5jj/CJ_reclama_com_carros_2.7z.html" # [198] CJ reclama com carros
    "http://sharemods.com/2yhtn7ed2utl/GTA_Online_Anims.7z.html" # [199] GTA V Online Original Anims to SA (animações do GTA Online)
    "http://sharemods.com/y7ny6i33w58q/Parkour_Mod.7z.html" # [200] Parkour Mod v2.0.4 Unofficial Fix
    "http://sharemods.com/1osrp4cxex04/Infernus_HD_by_Ezekiel.7z.html" # [201] Infernus HD by Ezekiel
    "http://sharemods.com/81id5unk7jky/Shotgun_Reload.7z.html" # [202] Shotgun Reload (espingarda recarregando)
    "https://drive.google.com/file/d/1wnWITLTGQAuqLgB14bTWSjSk_CYxR0S2/view" # [203] Bar Drink (mod beber no bar / ficar bêbado)
    "https://drive.google.com/open?id=1asrLFdaJ702-Cy-Kqw0m6zTfEPK3Iho0" # [204] Animações do GTA VCS/LCS
    "https://drive.google.com/open?id=1Da9MWJ3qROTT62rnRwHM9AD1V7vwHEO9" # [205] Arremessar facas ou katanas
    "https://drive.google.com/file/d/1Gjx78UjDyXcKxQz37vdK17C9WGwfz5ap/view" # [206] Arma IMBEL IA2 (brasileira) (lowpoly)
    "https://drive.google.com/open?id=1fWs2vr_sJv7djPRxDX3CI_4XsA6BDWsO" # [207] M4k3’s New Car Animations – Novas animações ao dirigir
    "https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html" # [208] Pose Mod (beta)
    "https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc" # [209] Explosivo TNT (relógio com detonador)
    "https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/" # [210] AK74 do Contract Wars
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [211] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [212] Parachute Randomizer (variar para-quedas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 13/14 enviado para o navegador com sucesso!"

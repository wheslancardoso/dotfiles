#!/usr/bin/env bash
echo "=== ABRINDO LOTE 17 DE 18 NO BRAVE (Mods 241 a 255) ==="
URLS=(
    "http://sharemods.com/81id5unk7jky/Shotgun_Reload.7z.html" # [241] Shotgun Reload (espingarda recarregando)
    "https://drive.google.com/file/d/1wnWITLTGQAuqLgB14bTWSjSk_CYxR0S2/view" # [242] Bar Drink (mod beber no bar / ficar bêbado)
    "https://drive.google.com/open?id=1asrLFdaJ702-Cy-Kqw0m6zTfEPK3Iho0" # [243] Animações do GTA VCS/LCS
    "https://drive.google.com/open?id=1Da9MWJ3qROTT62rnRwHM9AD1V7vwHEO9" # [244] Arremessar facas ou katanas
    "https://drive.google.com/file/d/1Gjx78UjDyXcKxQz37vdK17C9WGwfz5ap/view" # [245] Arma IMBEL IA2 (brasileira) (lowpoly)
    "https://drive.google.com/open?id=1fWs2vr_sJv7djPRxDX3CI_4XsA6BDWsO" # [246] M4k3’s New Car Animations – Novas animações ao dirigir
    "https://drive.google.com/open?id=1zgWe0bejROV0cdFQDR6zTr0-E7zK2bKD" # [247] Max Payne Mod
    "https://drive.google.com/file/d/0B1sAJQAUfOOYNjhwLXFQTWFneG8/view" # [248] Amazing Player: Female v2.0 (skin feminina)
    "https://www.mixmods.com.br/2017/10/pack-de-skins-da-ak-47-do-csgo/" # [249] Pack de Skins da AK-47 do CS:GO
    "https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html" # [250] Pose Mod (beta)
    "https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc" # [251] Explosivo TNT (relógio com detonador)
    "https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/" # [252] AK74 do Contract Wars
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [253] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [254] Parachute Randomizer (variar para-quedas)
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [255] Hit the Entity Fix (Bater na parede)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

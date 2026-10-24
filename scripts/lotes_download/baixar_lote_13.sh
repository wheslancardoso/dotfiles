#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 13 DE 17 NO BRAVE (Mods 181 a 195) ==="

URLS=(
    "https://drive.google.com/file/d/1wnWITLTGQAuqLgB14bTWSjSk_CYxR0S2/view" # [198] Bar Drink (mod beber no bar / ficar bêbado)
    "https://drive.google.com/open?id=1asrLFdaJ702-Cy-Kqw0m6zTfEPK3Iho0" # [199] Animações do GTA VCS/LCS
    "https://drive.google.com/open?id=1Da9MWJ3qROTT62rnRwHM9AD1V7vwHEO9" # [200] Arremessar facas ou katanas
    "https://drive.google.com/file/d/1Gjx78UjDyXcKxQz37vdK17C9WGwfz5ap/view" # [201] Arma IMBEL IA2 (brasileira) (lowpoly)
    "https://drive.google.com/open?id=1fWs2vr_sJv7djPRxDX3CI_4XsA6BDWsO" # [202] M4k3’s New Car Animations – Novas animações ao dirigir
    "https://sharemods.com/zr8805cvzg0y/Pose_Mod.7z.html" # [203] Pose Mod (beta)
    "https://drive.google.com/open?id=0B04D_5yMCyl9bC16eTc2SnBHTmc" # [204] Explosivo TNT (relógio com detonador)
    "https://www.mixmods.com.br/2017/08/ak74-do-contract-wars/" # [205] AK74 do Contract Wars
    "https://drive.google.com/file/d/0B1sAJQAUfOOYdXNwNk9sSU1NUW8/view" # [206] Microphone Talk (mexer a boca ao falar no microfone)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYYXFiS0pkX2dCVjg/view" # [207] Parachute Randomizer (variar para-quedas)
    "https://www.mixmods.com.br/2017/07/hit-the-entity-fix-bater-na-parede/" # [208] Hit the Entity Fix (Bater na parede)
    "https://sharemods.com/azzbo9poul6r/Extended_Gang_Wars.7z.html" # [209] Extended Gang Wars
    "https://sharemods.com/0cw2e8gpne29/Visual_Weapon_Spawner.7z.html" # [210] Visual Weapon Spawner
    "http://sharemods.com/3hbsuxa6sgrf/Ladders_-_Subir_escadas.7z.html" # [211] Ladders – Subir e descer escadas
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [212] Colocar/tirar silenciador da 9mm
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 13/17 enviado para o navegador com sucesso!"

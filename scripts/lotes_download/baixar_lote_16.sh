#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 16 DE 19 NO BRAVE (Mods 226 a 240) ==="

URLS=(
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [243] Grafites originais em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view" # [244] Pack Skins Da Nang Boyz HD
    "https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/" # [245] Pack de Skins Vagos HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view" # [246] Pack de skins Grove em HD (by AnRi)
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [247] The Gang War
    "https://sharemods.com/i7fb2i43f55z/Novas_Skins_para_Grove_em_HD.7z.html" # [248] Novas Skins para Grove em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYLXRLSFZxclFUMW8/view?usp=sharing" # [249] Novos Ballas em HD
    "https://www.mixmods.com.br/2011/10/nova-grove-v2/" # [250] Nova Grove v2
    "https://www.mixmods.com.br/2011/05/nova-groove-v1/" # [251] NOVA GROOVE V1
    "https://drive.google.com/open?id=0B04D_5yMCyl9N3h6emNOZHJRLW8" # [254] Extintor Apaga Fogo do Carro
    "https://sharemods.com/ykr4p8mtjmom/Sniper_Distance_Fix.7z.html" # [255] Sniper Distance Fix
    "https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/" # [256] Vigilante Special
    "https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/" # [257] Weapons OutFit
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [258] Proper Vehicles Retex
    "https://sharemods.com/rupfn9c41t3t/Round_Tuning_Wheels_CE.7z.html" # [259] Round Tuning Wheels CE
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 16/19 enviado para o navegador com sucesso!"

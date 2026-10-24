#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 17 DE 20 NO BRAVE (Mods 241 a 255) ==="

URLS=(
    "https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/" # [258] Pack de Skins Vagos HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view" # [259] Pack de skins Grove em HD (by AnRi)
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [260] The Gang War
    "https://sharemods.com/i7fb2i43f55z/Novas_Skins_para_Grove_em_HD.7z.html" # [261] Novas Skins para Grove em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYLXRLSFZxclFUMW8/view?usp=sharing" # [262] Novos Ballas em HD
    "https://www.mixmods.com.br/2011/10/nova-grove-v2/" # [263] Nova Grove v2
    "https://www.mixmods.com.br/2011/05/nova-groove-v1/" # [264] NOVA GROOVE V1
    "https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/" # [267] Cheat Menu v3.52
    "https://drive.google.com/open?id=0B04D_5yMCyl9N3h6emNOZHJRLW8" # [268] Extintor Apaga Fogo do Carro
    "https://sharemods.com/ykr4p8mtjmom/Sniper_Distance_Fix.7z.html" # [269] Sniper Distance Fix
    "https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/" # [270] Vigilante Special
    "https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/" # [271] Weapons OutFit
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [272] Proper Vehicles Retex
    "https://sharemods.com/rupfn9c41t3t/Round_Tuning_Wheels_CE.7z.html" # [273] Round Tuning Wheels CE
    "https://sharemods.com/bw24kx8xr9xa/Thunder_Mod.7z.html" # [274] Thunder Mod
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 17/20 enviado para o navegador com sucesso!"

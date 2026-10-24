#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 16 DE 19 NO BRAVE (Mods 226 a 240) ==="

URLS=(
    "https://sharemods.com/jn47en03jynn/Bloodz_and_CripZ_Remake.7z.html" # [243] Bloodz & CripZ (Remake)
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [244] Grafites originais em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view" # [245] Pack Skins Da Nang Boyz HD
    "https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/" # [246] Pack de Skins Vagos HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view" # [247] Pack de skins Grove em HD (by AnRi)
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [248] The Gang War
    "https://sharemods.com/i7fb2i43f55z/Novas_Skins_para_Grove_em_HD.7z.html" # [249] Novas Skins para Grove em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYLXRLSFZxclFUMW8/view?usp=sharing" # [250] Novos Ballas em HD
    "https://www.mixmods.com.br/2011/10/nova-grove-v2/" # [251] Nova Grove v2
    "https://www.mixmods.com.br/2011/05/nova-groove-v1/" # [252] NOVA GROOVE V1
    "https://www.mixmods.com.br/2021/11/cheat-menu-by-grinch-v3-52/" # [255] Cheat Menu v3.52
    "https://drive.google.com/open?id=0B04D_5yMCyl9N3h6emNOZHJRLW8" # [256] Extintor Apaga Fogo do Carro
    "https://sharemods.com/ykr4p8mtjmom/Sniper_Distance_Fix.7z.html" # [257] Sniper Distance Fix
    "https://www.mixmods.com.br/2021/04/vigilante-special-missao-de-policia-em-qualquer-carro/" # [258] Vigilante Special
    "https://www.mixmods.com.br/2021/08/weapons-outfit-armas-pelo-corpo/" # [259] Weapons OutFit
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 16/19 enviado para o navegador com sucesso!"

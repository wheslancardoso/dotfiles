#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 17 DE 17 NO BRAVE (Novos Mods 241 a 252) ==="
URLS=(
    "https://drive.google.com/open?id=0B04D_5yMCyl9RjIzbmVSOGU0bFk" # [259] Colocar/tirar silenciador da 9mm
    "https://sharemods.com/bbvvho2ynd42/No_Dual_Wield___Segurar_pistola_com_duas_maos.7z.html" # [260] No Dual Wield + Segurar pistola com duas mãos
    "https://sharemods.com/jn47en03jynn/Bloodz_and_CripZ_Remake.7z.html" # [261] Bloodz & CripZ (Remake)
    "https://www.mixmods.com.br/2015/01/grafites-originais-em-hd/" # [262] Grafites originais em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYRFZLUVVmc3Rhd2M/view" # [263] Pack Skins Da Nang Boyz HD
    "https://www.mixmods.com.br/2012/08/pack-de-skins-vagos-hd/" # [264] Pack de Skins Vagos HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYTnJOeHBCM3I5WGc/view" # [265] Pack de skins Grove em HD (by AnRi)
    "https://sharemods.com/35z1qznzsx1w/The_Gang_War.7z.html" # [266] The Gang War
    "https://sharemods.com/i7fb2i43f55z/Novas_Skins_para_Grove_em_HD.7z.html" # [267] Novas Skins para Grove em HD
    "https://drive.google.com/file/d/0B1sAJQAUfOOYLXRLSFZxclFUMW8/view?usp=sharing" # [268] Novos Ballas em HD
    "https://www.mixmods.com.br/2011/10/nova-grove-v2/" # [269] Nova Grove v2
    "https://www.mixmods.com.br/2011/05/nova-groove-v1/" # [270] NOVA GROOVE V1
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote pendente aberto no Brave!"

#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 05 DE 17 NO BRAVE (Novos Mods 61 a 75) ==="
URLS=(
    "https://www.mixmods.com.br/2022/04/no-minimap-in-interiors/" # [70] [SA] No Minimap In Interiors (desativar mapa em interiores)
    "https://sharemods.com/l0oi1e2w49d1/SA_-_NextGen_Remaster_Effects.7z.html" # [71] [SA] NextGen Remaster Effects (efeitos realistas HD)
    "https://sharemods.com/28iie8htc4jq/Missing_Lampposts_Fix.7z.html" # [73] [SA] Missing Lampposts Fix (mais postes de luz)
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [74] [SA/SA:DE] Proper Vehicles Retex v2.1 (texturas HD para veículos)
    "https://drive.google.com/file/d/1PUR5J0BexJI2lXtATiu68U86EXkNM7tC/view?usp=sharing" # [75] [SA] GTA V Vehicles to SA by _F_ (carros convertidos do GTA V)
    "https://sharemods.com/o07xb22y59nf/Project_Web_Anims.7z.html" # [76] [SA] Project Web Anims v7.5 (pack de animações)
    "https://sharemods.com/iy139fyfuyet/Cheat_Menu_by_Grinch_.zip.html" # [77] Cheat Menu by Grinch_ v3.52
    "https://sharemods.com/1rj82p2q33cz/Projectile_Shoot.7z.html" # [78] [SA] Projectile Shoot (atirar para explodir)
    "https://sharemods.com/o4fco3bicyin/Rules_Mod.7z.html" # [79] Rules Mod v1.2 (estrela de procurado ao quebrar leis)
    "https://sharemods.com/ilp0t25k29gz/LS_Lit_Church.7z.html" # [80] LS Lit Church (igreja com luzes acesas)
    "https://sharemods.com/llx280hsssre/SA_-_MixSets_-_password_mixmods.com.br.zip.html" # [81] [SA] MixSets v4.3.7
    "https://drive.google.com/file/d/1QecekuuyWgw68HU9tg6ENfrCTCVIjm6l/view" # [82] Shader Stochastic no GTA San Andreas (correção de tiling nas texturas)
    "https://sharemods.com/z6yo02u4xvaf/Sprint_Everywhere.7z.html" # [83] [SA] Sprint Everywhere (correr em interiores)
    "https://sharemods.com/o74eq9y76hjj/Glasses_Color_Overlay.7z.html" # [84] [SA] Glasses Color Overlay (filtro de cor ao usar óculos)
    "https://sharemods.com/tysasyrhqebt/nadalao_Weapon_Icons_-_icones_fieis_corrigidos.7z.html" # [85] [SA] nadalao Weapon Icons (ícones HD fiéis corrigidos)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote pendente aberto no Brave!"

#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 05 DE 20 NO BRAVE (Mods 61 a 75) ==="

URLS=(
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [70] [SA/SA:DE] Proper Vehicles Retex v2.1 (texturas HD para veículos)
    "https://drive.google.com/file/d/1PUR5J0BexJI2lXtATiu68U86EXkNM7tC/view?usp=sharing" # [71] [SA] GTA V Vehicles to SA by _F_ (carros convertidos do GTA V)
    "https://sharemods.com/o07xb22y59nf/Project_Web_Anims.7z.html" # [72] [SA] Project Web Anims v7.5 (pack de animações)
    "https://sharemods.com/iy139fyfuyet/Cheat_Menu_by_Grinch_.zip.html" # [73] Cheat Menu by Grinch_ v3.52
    "https://sharemods.com/1rj82p2q33cz/Projectile_Shoot.7z.html" # [74] [SA] Projectile Shoot (atirar para explodir)
    "https://sharemods.com/o4fco3bicyin/Rules_Mod.7z.html" # [75] Rules Mod v1.2 (estrela de procurado ao quebrar leis)
    "https://sharemods.com/ilp0t25k29gz/LS_Lit_Church.7z.html" # [76] LS Lit Church (igreja com luzes acesas)
    "https://sharemods.com/llx280hsssre/SA_-_MixSets_-_password_mixmods.com.br.zip.html" # [77] [SA] MixSets v4.3.7
    "https://drive.google.com/file/d/1QecekuuyWgw68HU9tg6ENfrCTCVIjm6l/view" # [78] Shader Stochastic no GTA San Andreas (correção de tiling nas texturas)
    "https://sharemods.com/z6yo02u4xvaf/Sprint_Everywhere.7z.html" # [79] [SA] Sprint Everywhere (correr em interiores)
    "https://sharemods.com/o74eq9y76hjj/Glasses_Color_Overlay.7z.html" # [80] [SA] Glasses Color Overlay (filtro de cor ao usar óculos)
    "https://sharemods.com/tysasyrhqebt/nadalao_Weapon_Icons_-_icones_fieis_corrigidos.7z.html" # [81] [SA] nadalao Weapon Icons (ícones HD fiéis corrigidos)
    "https://sharemods.com/l01yekk929dh/MW_Project.7z.html" # [82] MW Project (mais água por SA)
    "https://sharemods.com/c08l1q6s8kxy/SA_SADE_-_Peds_Run_Fix.7z.html" # [84] [SA/SA:DE] Ped Run Fix v2.2 (corrigir velhinhas correndo)
    "https://sharemods.com/sl15wwdhyw7o/Custom_Ammunation.7z.html" # [85] Custom Ammunation Mod v3.5 (adicionar armas pra comprar)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 05/20 enviado para o navegador com sucesso!"

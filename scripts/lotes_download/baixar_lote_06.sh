#!/usr/bin/env bash
echo "=== ABRINDO LOTE 06 DE 18 NO BRAVE (Mods 76 a 90) ==="
URLS=(
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
    "https://sharemods.com/l01yekk929dh/MW_Project.7z.html" # [86] MW Project (mais água por SA)
    "https://sharemods.com/3xputk50vuec/Animation_Fix___M4k3_New_Car_Animations.7z.html" # [87] [SA] Animation Fix + M4k3 Anims (corrigir bugs de animações)
    "https://sharemods.com/c08l1q6s8kxy/SA_SADE_-_Peds_Run_Fix.7z.html" # [88] [SA/SA:DE] Ped Run Fix v2.2 (corrigir velhinhas correndo)
    "https://sharemods.com/sl15wwdhyw7o/Custom_Ammunation.7z.html" # [89] Custom Ammunation Mod v3.5 (adicionar armas pra comprar)
    "https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html" # [90] LOD Vegetation v1.2 (árvores distantes)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

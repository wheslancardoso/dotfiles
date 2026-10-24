#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 05 DE 17 NO BRAVE (Mods 61 a 75) ==="

URLS=(
    "https://drive.google.com/file/d/1QecekuuyWgw68HU9tg6ENfrCTCVIjm6l/view" # [70] Shader Stochastic no GTA San Andreas (correção de tiling nas texturas)
    "https://sharemods.com/z6yo02u4xvaf/Sprint_Everywhere.7z.html" # [71] [SA] Sprint Everywhere (correr em interiores)
    "https://sharemods.com/o74eq9y76hjj/Glasses_Color_Overlay.7z.html" # [72] [SA] Glasses Color Overlay (filtro de cor ao usar óculos)
    "https://sharemods.com/tysasyrhqebt/nadalao_Weapon_Icons_-_icones_fieis_corrigidos.7z.html" # [73] [SA] nadalao Weapon Icons (ícones HD fiéis corrigidos)
    "https://sharemods.com/l01yekk929dh/MW_Project.7z.html" # [74] MW Project (mais água por SA)
    "https://sharemods.com/c08l1q6s8kxy/SA_SADE_-_Peds_Run_Fix.7z.html" # [76] [SA/SA:DE] Ped Run Fix v2.2 (corrigir velhinhas correndo)
    "https://sharemods.com/sl15wwdhyw7o/Custom_Ammunation.7z.html" # [77] Custom Ammunation Mod v3.5 (adicionar armas pra comprar)
    "https://sharemods.com/7u9q36epczhn/LOD_Vegetation.7z.html" # [78] LOD Vegetation v1.2 (árvores distantes)
    "https://www.mixmods.com.br/2021/12/cleo-redux/" # [79] CLEO Redux
    "https://sharemods.com/s13yawvkfnwn/SADE_MP5.7z.html" # [81] MP5 (convertida do SA:DE)
    "https://sharemods.com/i8pyupgkl3ia/Tesla_Model_S_2014.7z.html" # [82] Tesla Model S 2014 (fix + script)
    "https://sharemods.com/uelr5g9m1eff/Illuminated_Vinewood_Sign.7z.html" # [83] Illuminated Vinewood Sign (placa de Vinewood iluminada)
    "https://sharemods.com/z2uh6naoyg1i/Pre-lighting_Fixes_Pack.7z.html" # [84] Pre-lighting Fixes Pack (correções de iluminação)
    "https://sharemods.com/4s905tmgiphk/Upgraded_Vehicles_Pack.7z.html" # [85] Upgraded Vehicles Pack (carros originais corrigidos)
    "https://sharemods.com/dgcbm6ixj1pl/RenderHookFix.7z.html" # [86] RenderHook Fix (correções para o RH)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 05/17 enviado para o navegador com sucesso!"

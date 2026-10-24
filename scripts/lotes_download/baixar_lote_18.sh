#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 18 DE 19 NO BRAVE (Mods 256 a 270) ==="

URLS=(
    "https://sharemods.com/duxyrps05sns/Dynamic_Shadow_Color.7z.html" # [276] Dynamic Shadow Color (Sombras com Cores Atmosféricas)
    "https://sharemods.com/j81zikfmhj4t/Mesh_Smoothed_Pack.7z.html" # [277] High Poly Desert
    "https://sharemods.com/iwbbggdxsnhy/Improved_Lamps.7z.html" # [278] Improved Lamps v0.8
    "https://sharemods.com/rb96prexlrg9/More_Radar_Icons.7z.html" # [279] More Radar Icons v2.0
    "https://sharemods.com/e134w29j6xze/Improved_Surface_Physics.7z.html" # [280] Improved Surface Physics (Superfícies com Física Aprimorada)
    "https://sharemods.com/e61gwxaw6zz8/Wheel_Detach.7z.html" # [281] Wheel Detach (Soltar e Arrancar Rodas em Colisões)
    "https://sharemods.com/pl8akn9yotvd/Smooth_Criminal_Bicycles.7z.html" # [282] Smooth Criminal Bicycles
    "https://sharemods.com/13giliprj62v/Custom_Crosshairs.7z.html" # [283] CustomCrosshairs v2.0
    "https://sharemods.com/bpkboyrbseb9/Miras_e_discos_de_radar_pack.7z.html" # [284] Crosshairs Pack (300+ Miras & 46 Discos de Radar)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUEEtVVd5b2p2clU/view?usp=sharing" # [285] Hit Indicator (Damage Indicator / Hitmarker Tático)
    "https://sharemods.com/drr20mtaslro/Hairstyles_and_Beards.7z.html" # [286] Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)
    "https://sharemods.com/pwpz3eq28frz/Beard_Grow.7z.html" # [287] Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)
    "https://sharemods.com/wpq8ylslxbx3/MenuUI.zip.html" # [288] MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)
    "https://sharemods.com/vhm7q61koy0g/SA_-_HD_Underwater.7z.html" # [289] HD Underwater v2.0 (Corais, Peixes e Vida Marinha)
    "https://sharemods.com/lozj8d9wsxip/More_Locked_Cars.7z.html" # [291] More Locked Cars
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 18/19 enviado para o navegador com sucesso!"

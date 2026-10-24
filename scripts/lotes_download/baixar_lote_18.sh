#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 18 DE 19 NO BRAVE (Mods 256 a 270) ==="

URLS=(
    "https://sharemods.com/mjxz5fvpmt4p/HeliFix.7z.html" # [275] HeliFix v1.4
    "https://drive.google.com/open?id=0B04D_5yMCyl9RWNHdUdTQVZ0T2M" # [276] Recomeçar Missão
    "https://sharemods.com/duxyrps05sns/Dynamic_Shadow_Color.7z.html" # [278] Dynamic Shadow Color (Sombras com Cores Atmosféricas)
    "https://sharemods.com/j81zikfmhj4t/Mesh_Smoothed_Pack.7z.html" # [279] High Poly Desert
    "https://sharemods.com/iwbbggdxsnhy/Improved_Lamps.7z.html" # [280] Improved Lamps v0.8
    "https://sharemods.com/rb96prexlrg9/More_Radar_Icons.7z.html" # [281] More Radar Icons v2.0
    "https://sharemods.com/e134w29j6xze/Improved_Surface_Physics.7z.html" # [282] Improved Surface Physics (Superfícies com Física Aprimorada)
    "https://sharemods.com/e61gwxaw6zz8/Wheel_Detach.7z.html" # [283] Wheel Detach (Soltar e Arrancar Rodas em Colisões)
    "https://sharemods.com/pl8akn9yotvd/Smooth_Criminal_Bicycles.7z.html" # [284] Smooth Criminal Bicycles
    "https://sharemods.com/13giliprj62v/Custom_Crosshairs.7z.html" # [285] CustomCrosshairs v2.0
    "https://sharemods.com/bpkboyrbseb9/Miras_e_discos_de_radar_pack.7z.html" # [286] Crosshairs Pack (300+ Miras & 46 Discos de Radar)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUEEtVVd5b2p2clU/view?usp=sharing" # [287] Hit Indicator (Damage Indicator / Hitmarker Tático)
    "https://sharemods.com/drr20mtaslro/Hairstyles_and_Beards.7z.html" # [288] Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)
    "https://sharemods.com/pwpz3eq28frz/Beard_Grow.7z.html" # [289] Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)
    "https://sharemods.com/wpq8ylslxbx3/MenuUI.zip.html" # [290] MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 18/19 enviado para o navegador com sucesso!"

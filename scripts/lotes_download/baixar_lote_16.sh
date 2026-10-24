#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 16 DE 17 NO BRAVE (Mods 226 a 240) ==="

URLS=(
    "https://sharemods.com/pl8akn9yotvd/Smooth_Criminal_Bicycles.7z.html" # [246] Smooth Criminal Bicycles
    "https://sharemods.com/13giliprj62v/Custom_Crosshairs.7z.html" # [247] CustomCrosshairs v2.0
    "https://sharemods.com/bpkboyrbseb9/Miras_e_discos_de_radar_pack.7z.html" # [248] Crosshairs Pack (300+ Miras & 46 Discos de Radar)
    "https://drive.google.com/file/d/0B1sAJQAUfOOYUEEtVVd5b2p2clU/view?usp=sharing" # [249] Hit Indicator (Damage Indicator / Hitmarker Tático)
    "https://sharemods.com/drr20mtaslro/Hairstyles_and_Beards.7z.html" # [250] Hairstyles & Beards (Escolher Separadamente Cabelo e Barba)
    "https://sharemods.com/pwpz3eq28frz/Beard_Grow.7z.html" # [251] Beard Grow Mod v1.2 (Crescimento de Barba estilo RDR2)
    "https://sharemods.com/wpq8ylslxbx3/MenuUI.zip.html" # [252] MenuUI v2.0 (Interface Moderna para Barbearias e Lojas)
    "https://sharemods.com/vhm7q61koy0g/SA_-_HD_Underwater.7z.html" # [253] HD Underwater v2.0 (Corais, Peixes e Vida Marinha)
    "https://sharemods.com/lozj8d9wsxip/More_Locked_Cars.7z.html" # [255] More Locked Cars
    "https://sharemods.com/0gemwch5bivn/Alarm_Touching_Cars.7z.html" # [256] Alarm Touching Cars
    "https://www.mixmods.com.br/2019/04/swim-fps-fix-corrigir-nadar-com-fps-alto/" # [257] Swim FPS Fix
    "https://www.mixmods.com.br/2022/06/model-variations/" # [258] Model Variations
    "http://sharemods.com/f0n5080m9quu/Phoenix_Mode.7z.html" # [259] Phoenix Mode
    "https://sharemods.com/6m3go2b7lqbx/Robbery_Mod.7z.html" # [260] 24/7 Robbery
    "https://sharemods.com/ao53yl4oua80/SA_-_Random_Car_Talk.7z.html" # [261] Random Car Talk
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 16/17 enviado para o navegador com sucesso!"

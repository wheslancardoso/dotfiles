#!/usr/bin/env bash
echo "=== ABRINDO LOTE CURADO 06 DE 07 NO BRAVE (Mods 61 a 72) ==="

URLS=(
    "https://www.mixmods.com.br/2024/08/original-radio-extended" # [72] Original Radio Extended (1000 Músicas Sem Cortes)
    "https://www.mixmods.com.br/2022/08/atualizados-traducao-emmet-useful-vehicle-immunities" # [73] Emmet But Useful (Emmet Útil no Jogo Inteiro)
    "https://sharemods.com/vhm7q61koy0g/SA_-_HD_Underwater.7z.html" # [76] HD Underwater v2.0 (Corais, Peixes e Vida Marinha)
    "https://sharemods.com/lozj8d9wsxip/More_Locked_Cars.7z.html" # [78] More Locked Cars
    "https://sharemods.com/0gemwch5bivn/Alarm_Touching_Cars.7z.html" # [79] Alarm Touching Cars
    "https://sharemods.com/nd45td9y91fj/Open_Door_Anim.7z.html" # [80] Open Door Anim v1.2.2
    "https://www.mixmods.com.br/2019/04/swim-fps-fix-corrigir-nadar-com-fps-alto" # [81] Swim FPS Fix
    "https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html" # [83] Peds Extender
    "https://www.mixmods.com.br/2022/06/model-variations" # [84] Model Variations
    "https://www.mixmods.com.br/2022/12/atualizados-peds-bleeding-wind-project-skygfx-extended" # [85] Peds Bleeding
    "https://sharemods.com/2289owg3jx0m/Death_In_Car.7z.html" # [86] Death In Car
    "http://sharemods.com/f0n5080m9quu/Phoenix_Mode.7z.html" # [87] Phoenix Mode
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done
echo "✔ Lote 06/07 aberto no Brave com sucesso!"

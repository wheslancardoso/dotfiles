#!/usr/bin/env bash
echo "=== ABRINDO LOTE 04 DE 18 NO BRAVE (Mods 46 a 60) ==="
URLS=(
    "https://sharemods.com/6xafx05pnj6v/GraphicsTweaker.7z.html" # [46] [SA] Graphics Tweaker v1.3.1 (melhorar gráficos)
    "https://sharemods.com/1euifjsacuwu/SA_-_Z_Menu.7z.html" # [47] [SA] Z Menu (mod trainer)
    "https://sharemods.com/4bgzyt2gtpj2/SA_-_Throw_Rotate_Fix.7z.html" # [48] [SA] Throw Rotate Fix v2.0 (molotov/granada rodando no ar)
    "https://www.mixmods.com.br/2022/08/sa-revamped-vehicles-project/" # [49] [SA] Revamped Vehicles Project (carros corrigidos e adaptados)
    "https://sharemods.com/s1rxdti1yntv/Framerate_Vigilante.zip.html" # [50] [III/VC/SA] Framerate Vigilante (corrigir bugs de FPS alto)
    "https://sharemods.com/pfge1km3wdw3/SA_-_Peds_Extender.7z.html" # [51] [SA] Peds Extender v1.1.5 (corrigir, restaurar e variar pedestres)
    "https://sharemods.com/a4lbda6sgq5v/Destructive_Rhino_Mod.7z.html" # [52] [SA] Destructive Rhino Mod (explodir tanques)
    "https://sharemods.com/2xibsxei9gan/PedSkills.7z.html" # [53] [SA] PedSkills v2.2 (aumentar dificuldade)
    "https://sharemods.com/dhjea67wrhm1/Real_Linear_Graphics.7z.html" # [54] Real Linear Graphics v2.6 (cores realistas)
    "https://sharemods.com/w1gml4nqvlo8/Remove_Brass_Knucles.7z.html" # [55] [SA/SADE/Mobile] Remove Brass Knuckles (desativar soco-inglês)
    "https://sharemods.com/eenyrp1bklvj/Proper_Radar.7z.html" # [56] [SA/SA:DE] Proper Radar v1.3 (mapa em HD corrigido)
    "https://sharemods.com/a3tl94dgrzrb/Body_Stats_Fix.7z.html" # [57] [SA] Body Stats Fix in Interiors (corrigir corpo sem mudar)
    "https://sharemods.com/fkum0x0mhyu6/PedFuncs.7z.html" # [58] [SA] PedFuncs v0.5.1
    "https://sharemods.com/pknk1m9jkooc/SADE_-_Torch_Mod.7z.html" # [59] [SA/SA:DE] Torch Mod (tocha com luz)
    "https://sharemods.com/2289owg3jx0m/Death_In_Car.7z.html" # [60] Death In Car (morrer dentro do carro)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

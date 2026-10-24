#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 04 DE 20 NO BRAVE (Mods 46 a 60) ==="

URLS=(
    "https://sharemods.com/a3tl94dgrzrb/Body_Stats_Fix.7z.html" # [53] [SA] Body Stats Fix in Interiors (corrigir corpo sem mudar)
    "https://sharemods.com/pknk1m9jkooc/SADE_-_Torch_Mod.7z.html" # [55] [SA/SA:DE] Torch Mod (tocha com luz)
    "https://sharemods.com/2289owg3jx0m/Death_In_Car.7z.html" # [56] Death In Car (morrer dentro do carro)
    "https://sharemods.com/1u3i9l2uo4ao/Gang_Hands_Texture_Fix.7z.html" # [57] [SA] Gang Hands Texture Fix (corrigir mãos bugadas)
    "https://sharemods.com/s4l7mw43heuk/SFDP_Heli_Fix.7z.html" # [58] [SA/SA:DE/Mobile] SFDP Heli Fix (helicóptero da polícia de SF)
    "https://sharemods.com/q2gr7fu98fml/Proper_Night_Windows.7z.html" # [59] [SA] Proper Night Windows (mais janelas noturnas)
    "https://sharemods.com/33090codslex/Skate_Mod.7z.html" # [60] [SA/SA:DE] Skateboarding Mod (mod de skate)
    "https://sharemods.com/vmhimyh5mm0k/No_Auto_Pickups.7z.html" # [61] [SA] No Auto Pickups (coletar armas manualmente)
    "https://sharemods.com/0ff3q5jkuabp/Missing_Smokes_Fix.7z.html" # [62] [SA] Missing Smokes Fix (fumaça na tubulação das fábricas)
    "https://sharemods.com/u2fwrrrj6hvn/Manual_Firing.7z.html" # [63] [SA] Manual Firing v2.2.1 (tiros manuais)
    "https://www.mixmods.com.br/2022/04/sa-map-editor/" # [64] [SA] Map Editor (editar mapa dentro do jogo com mouse)
    "https://sharemods.com/0l8a752l17ui/Prostitutes_Money_Drop_Fix.7z.html" # [65] [SA] Prostitutes Money Drop Fix (corrigir dinheiro de prostitutas)
    "https://www.mixmods.com.br/2022/04/no-minimap-in-interiors/" # [66] [SA] No Minimap In Interiors (desativar mapa em interiores)
    "https://sharemods.com/l0oi1e2w49d1/SA_-_NextGen_Remaster_Effects.7z.html" # [67] [SA] NextGen Remaster Effects (efeitos realistas HD)
    "https://sharemods.com/28iie8htc4jq/Missing_Lampposts_Fix.7z.html" # [69] [SA] Missing Lampposts Fix (mais postes de luz)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 04/20 enviado para o navegador com sucesso!"

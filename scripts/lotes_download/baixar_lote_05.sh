#!/usr/bin/env bash
echo "=== ABRINDO LOTE 05 DE 18 NO BRAVE (Mods 61 a 75) ==="
URLS=(
    "https://sharemods.com/1u3i9l2uo4ao/Gang_Hands_Texture_Fix.7z.html" # [61] [SA] Gang Hands Texture Fix (corrigir mãos bugadas)
    "https://sharemods.com/s4l7mw43heuk/SFDP_Heli_Fix.7z.html" # [62] [SA/SA:DE/Mobile] SFDP Heli Fix (helicóptero da polícia de SF)
    "https://sharemods.com/q2gr7fu98fml/Proper_Night_Windows.7z.html" # [63] [SA] Proper Night Windows (mais janelas noturnas)
    "https://sharemods.com/33090codslex/Skate_Mod.7z.html" # [64] [SA/SA:DE] Skateboarding Mod (mod de skate)
    "https://sharemods.com/vmhimyh5mm0k/No_Auto_Pickups.7z.html" # [65] [SA] No Auto Pickups (coletar armas manualmente)
    "https://sharemods.com/0ff3q5jkuabp/Missing_Smokes_Fix.7z.html" # [66] [SA] Missing Smokes Fix (fumaça na tubulação das fábricas)
    "https://sharemods.com/u2fwrrrj6hvn/Manual_Firing.7z.html" # [67] [SA] Manual Firing v2.2.1 (tiros manuais)
    "https://www.mixmods.com.br/2022/04/sa-map-editor/" # [68] [SA] Map Editor (editar mapa dentro do jogo com mouse)
    "https://sharemods.com/0l8a752l17ui/Prostitutes_Money_Drop_Fix.7z.html" # [69] [SA] Prostitutes Money Drop Fix (corrigir dinheiro de prostitutas)
    "https://www.mixmods.com.br/2022/04/no-minimap-in-interiors/" # [70] [SA] No Minimap In Interiors (desativar mapa em interiores)
    "https://sharemods.com/l0oi1e2w49d1/SA_-_NextGen_Remaster_Effects.7z.html" # [71] [SA] NextGen Remaster Effects (efeitos realistas HD)
    "https://sharemods.com/jlqyc2ya7lol/SA_-_Real_Traffic_Fix.7z.html" # [72] [VC/SA] Real Traffic Fix v2.2.1 beta
    "https://sharemods.com/28iie8htc4jq/Missing_Lampposts_Fix.7z.html" # [73] [SA] Missing Lampposts Fix (mais postes de luz)
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [74] [SA/SA:DE] Proper Vehicles Retex v2.1 (texturas HD para veículos)
    "https://drive.google.com/file/d/1PUR5J0BexJI2lXtATiu68U86EXkNM7tC/view?usp=sharing" # [75] [SA] GTA V Vehicles to SA by _F_ (carros convertidos do GTA V)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.3
done
echo "Lote aberto no Brave com sucesso!"

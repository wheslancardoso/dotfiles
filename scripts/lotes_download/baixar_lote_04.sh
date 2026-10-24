#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 04 DE 19 NO BRAVE (Mods 46 a 60) ==="

URLS=(
    "https://sharemods.com/vmhimyh5mm0k/No_Auto_Pickups.7z.html" # [54] [SA] No Auto Pickups (coletar armas manualmente)
    "https://sharemods.com/0ff3q5jkuabp/Missing_Smokes_Fix.7z.html" # [55] [SA] Missing Smokes Fix (fumaça na tubulação das fábricas)
    "https://sharemods.com/u2fwrrrj6hvn/Manual_Firing.7z.html" # [56] [SA] Manual Firing v2.2.1 (tiros manuais)
    "https://sharemods.com/0l8a752l17ui/Prostitutes_Money_Drop_Fix.7z.html" # [57] [SA] Prostitutes Money Drop Fix (corrigir dinheiro de prostitutas)
    "https://www.mixmods.com.br/2022/04/no-minimap-in-interiors/" # [58] [SA] No Minimap In Interiors (desativar mapa em interiores)
    "https://sharemods.com/l0oi1e2w49d1/SA_-_NextGen_Remaster_Effects.7z.html" # [59] [SA] NextGen Remaster Effects (efeitos realistas HD)
    "https://sharemods.com/28iie8htc4jq/Missing_Lampposts_Fix.7z.html" # [61] [SA] Missing Lampposts Fix (mais postes de luz)
    "https://sharemods.com/2uesa2zbze2m/Proper_Vehicles_Retex_v2.1_512_VERSION.7z.html" # [62] [SA/SA:DE] Proper Vehicles Retex v2.1 (texturas HD para veículos)
    "https://drive.google.com/file/d/1PUR5J0BexJI2lXtATiu68U86EXkNM7tC/view?usp=sharing" # [63] [SA] GTA V Vehicles to SA by _F_ (carros convertidos do GTA V)
    "https://sharemods.com/o07xb22y59nf/Project_Web_Anims.7z.html" # [64] [SA] Project Web Anims v7.5 (pack de animações)
    "https://sharemods.com/iy139fyfuyet/Cheat_Menu_by_Grinch_.zip.html" # [65] Cheat Menu by Grinch_ v3.52
    "https://sharemods.com/1rj82p2q33cz/Projectile_Shoot.7z.html" # [66] [SA] Projectile Shoot (atirar para explodir)
    "https://sharemods.com/o4fco3bicyin/Rules_Mod.7z.html" # [67] Rules Mod v1.2 (estrela de procurado ao quebrar leis)
    "https://sharemods.com/ilp0t25k29gz/LS_Lit_Church.7z.html" # [68] LS Lit Church (igreja com luzes acesas)
    "https://sharemods.com/llx280hsssre/SA_-_MixSets_-_password_mixmods.com.br.zip.html" # [69] [SA] MixSets v4.3.7
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 04/19 enviado para o navegador com sucesso!"

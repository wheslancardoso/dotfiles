#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 02 DE 19 NO BRAVE (Mods 16 a 30) ==="

URLS=(
    "https://sharemods.com/y5pkv6qmpy9y/SA_-_Pacific_Park_Rotating_Ferris_Wheel.7z.html" # [20] [SA] Pacific Park Rotating Ferris Wheel (roda-gigante animada)
    "https://sharemods.com/bn17c3snstt1/SA_Snow_Conversion.7z.html" # [21] SA Snow Conversion 2022 (mod pack)
    "https://sharemods.com/gq01h5shttg9/DYOM_8.1.zip.html" # [22] [SA] DYOM – Design Your Own Mission (2022)
    "https://sharemods.com/zf4cw8dt5y0j/SA_-_Tree_House.7z.html" # [23] [SA] Tree House v1.1 (mod casa na árvore)
    "https://sharemods.com/3b7uuwotoncu/SA_-_Wind_Project.7z.html" # [26] [SA] Wind Project v1.0.2 (mod de vento)
    "https://sharemods.com/6s9h92i8pfd0/Girlfriend_Parked_Cars_Restore_Fix.zip.html" # [27] [SA] RepairGTA (corrigir problemas automaticamente)
    "https://sharemods.com/qi1khsdznvmg/Myths_Maker.7z.html" # [28] Myths Maker v2.7 (criar mitos e lendas)
    "https://sharemods.com/wia802k6ikkm/Myths_Maker_-_Animals_Pack.7z.html" # [29] Myths Maker – Animals Pack (mod de animais)
    "https://sharemods.com/0zi4kjql48g1/SA_-_Furniture_Mod.zip.html" # [30] [SA] Furniture Mod v1.0 beta (comprar móveis)
    "https://sharemods.com/a8lp92fm5jz4/Open_Limit_Adjuster.zip.html" # [31] [III|VC|SA] OLA – Open Limit Adjuster v1.7
    "https://sharemods.com/jvdsgr5n0kf9/SA_-_Cyber_Cafe_Interior.7z.html" # [32] [SA] Cyber Cafe Interior (lan-house)
    "https://sharemods.com/6gxnkrbws5wr/GPS_Redux.zip.html" # [33] [SA/SAMP] GPS Redux v1.5 (mostrar caminho no mapa)
    "https://sharemods.com/uj564y9f94iy/SA_-_Proper_HD_Models.7z.html" # [34] [SA] Proper HD Models (objetos remasterizados)
    "https://sharemods.com/4qoj2ti1l74c/SA_VC_III_-_Windowed_Mode.zip.html" # [35] [III/VC/SA] Windowed Mode (modo janela)
    "https://sharemods.com/xhb7m223eofm/Radar_Map_by_wD_D159.7z.html" # [36] [SA] Radar Map by wD.D159 (mapa redesenhado)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 02/19 enviado para o navegador com sucesso!"

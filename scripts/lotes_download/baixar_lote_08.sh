#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 08 DE 20 NO BRAVE (Mods 106 a 120) ==="

URLS=(
    "https://sharemods.com/v0mqs5d7wick/Save_Tools.7z.html" # [120] Save Tools – Jogo salvo 100% + Save Game Helper + Backup
    "https://sharemods.com/cg6r9vwvtdik/Rikintosh__x27_s_Small_Details_Mod_-_Improved.7z.html" # [121] Rikintosh’s Small Details Mod (carros com texturas HD)
    "https://sharemods.com/5x07pblbqpxz/Mod_VR.7z.html" # [123] Mod VR (Virtual Reality)
    "https://sharemods.com/3bet7r9pi53t/SAORS.7z.html" # [124] SAORS v2 (mod rádio online)
    "https://sharemods.com/dacnu6i4jbps/Acceleratorgen.7z.html" # [125] Acceleratorgen (gerador de MINFO.BIN e CINFO.BIN)
    "https://sharemods.com/z7cnx7ur9s5n/San_Andreas_Farming_Equipment_DLC.7z.html" # [126] San Andreas Farming Equipment DLC (SAFE DLC) (trator HD)
    "https://sharemods.com/1swhpdai23zn/Draw_Cols_SA.7z.html" # [128] Draw Cols SA (modo debug de colisores)
    "https://sharemods.com/e07ksm6zefr3/SA_DirectX_2.7z.html" # [129] SA_DirectX 2.0 Final + Unofficial update (ASI version)
    "https://sharemods.com/kgi120yjoqgc/Vehicle_Shared_HD_Wheels.7z.html" # [130] Vehicle Shared HD Wheels (carros com rodas HD)
    "https://sharemods.com/t1oa3uuqyl8p/Beta_Gang_Skins_Added.7z.html" # [131] Beta Gang Skins Added (restaurar gangue beta)
    "https://sharemods.com/04ywd5k9r0ps/Revamped_Arsenal.7z.html" # [132] Revamped Arsenal (armas originais melhoradas)
    "https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html" # [133] NewOpcodes.cleo v2.1
    "https://sharemods.com/sjmd1yxgpf08/SCRLog.zip.html" # [134] [III/VC/SA] SCRLog 2020.3 (descobrir crash em mod CLEO)
    "https://sharemods.com/acne914kzt4m/MoonLoader_preview_version.7z.html" # [135] MoonLoader
    "https://sharemods.com/1ssbaxmrs16v/ModLoader_support_for_MoonLoader.7z.html" # [136] ModLoader support for MoonLoader (mods Lua no ModLoader)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 08/20 enviado para o navegador com sucesso!"

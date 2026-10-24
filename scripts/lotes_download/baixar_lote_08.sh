#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 08 DE 20 NO BRAVE (Mods 106 a 120) ==="

URLS=(
    "https://www.mixmods.com.br/2021/03/autoid-v2-2-corrigir-conflito-de-ids-autoadapt/" # [120] AutoID (corrigir conflito de IDs) + AutoAdapt
    "https://sharemods.com/6o30hb6d20nc/Disable_camera_-_Insert_key.7z.html" # [121] ENB Series v0.430 (.asi) + complex shadows, soft particles
    "https://sharemods.com/m7m47k8pbah5/Added_Weapons_Pack.7z.html" # [122] Added 70 Weapons Pack (70 novas armas adicionadas)
    "https://sharemods.com/v0mqs5d7wick/Save_Tools.7z.html" # [123] Save Tools – Jogo salvo 100% + Save Game Helper + Backup
    "https://sharemods.com/cg6r9vwvtdik/Rikintosh__x27_s_Small_Details_Mod_-_Improved.7z.html" # [124] Rikintosh’s Small Details Mod (carros com texturas HD)
    "https://sharemods.com/5x07pblbqpxz/Mod_VR.7z.html" # [126] Mod VR (Virtual Reality)
    "https://sharemods.com/3bet7r9pi53t/SAORS.7z.html" # [127] SAORS v2 (mod rádio online)
    "https://sharemods.com/dacnu6i4jbps/Acceleratorgen.7z.html" # [128] Acceleratorgen (gerador de MINFO.BIN e CINFO.BIN)
    "https://sharemods.com/z7cnx7ur9s5n/San_Andreas_Farming_Equipment_DLC.7z.html" # [129] San Andreas Farming Equipment DLC (SAFE DLC) (trator HD)
    "https://sharemods.com/1swhpdai23zn/Draw_Cols_SA.7z.html" # [131] Draw Cols SA (modo debug de colisores)
    "https://sharemods.com/e07ksm6zefr3/SA_DirectX_2.7z.html" # [132] SA_DirectX 2.0 Final + Unofficial update (ASI version)
    "https://sharemods.com/kgi120yjoqgc/Vehicle_Shared_HD_Wheels.7z.html" # [133] Vehicle Shared HD Wheels (carros com rodas HD)
    "https://sharemods.com/t1oa3uuqyl8p/Beta_Gang_Skins_Added.7z.html" # [134] Beta Gang Skins Added (restaurar gangue beta)
    "https://sharemods.com/04ywd5k9r0ps/Revamped_Arsenal.7z.html" # [135] Revamped Arsenal (armas originais melhoradas)
    "https://sharemods.com/69lwlady6yav/NewOpcodes.7z.html" # [136] NewOpcodes.cleo v2.1
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 08/20 enviado para o navegador com sucesso!"

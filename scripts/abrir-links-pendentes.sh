#!/usr/bin/env bash
# Abre todos os links diretos pendentes de download no navegador Brave

echo "Abrindo links de download pendentes no Brave..."

URLS=(
    # --- Tiro, Mira, Primeira Pessoa & Animações de Arma ---
    "https://sharemods.com/ekfp0ll7momd/Advanced_Aiming_Mod.7z.html"
    "https://sharemods.com/w0fwn9cbc65k/First_Person_Mod_fixed.7z.html"
    "https://sharemods.com/svuvzea8cpa7/Manual_Driveby_Remake.7z.html"
    "https://sharemods.com/a5ip9lonbiwc/INSANITY_Weapons_Items.7z.html"
    "https://sharemods.com/kyvwkd7vtt4i/More_Realistic_Reload_Animation_Mod.7z.html"

    # --- Animações & Físicas de Veículo ---
    "https://sharemods.com/47465yc6kq12/Awesome_IFP.7z.html"
    "https://sharemods.com/3xputk50vuec/Animation_Fix___M4k3_New_Car_Animations.7z.html"
    "https://sharemods.com/w56pqdc3vr1v/VehDeform.zip.html"

    # --- Gameplay, Coletáveis & Mundo ---
    "https://sharemods.com/eo6bbf9psmeq/Collectibles_on_Radar.7z.html"
    "https://sharemods.com/r9991nx53e61/SA_-_Ladders_Mod.zip.html"
    "https://sharemods.com/asxvzdjkpa6m/Real_Skybox.7z.html"

    # --- Personagens & CJ ---
    "https://sharemods.com/dckdhp4ir86q/Proper_Player_Retex.7z.html"
    "https://sharemods.com/fkum0x0mhyu6/PedFuncs.7z.html"
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.4
done

echo "Todos os 13 links diretos foram enviados para o Brave!"
echo "Clique em 'Create download link' no navegador para salvar em ~/Downloads."

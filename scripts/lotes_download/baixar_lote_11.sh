#!/usr/bin/env bash
echo "=== ABRINDO LOTE PENDENTE 11 DE 20 NO BRAVE (Mods 151 a 165) ==="

URLS=(
    "https://www.mixmods.com.br/2020/04/como-copiar-pastas-sem-ocupar-espaco-em-disco-symbolic-link/" # [168] Como copiar pastas sem ocupar espaço em disco (symbolic link)
    "https://drive.google.com/file/d/18iLZ_IEoAQl-3nZgWa_kFy6q7lsszy0L/view" # [169] 90s Atmosphere Vehicles Pack Reborn 3 (latest official stable version)
    "https://sharemods.com/y1o3rvh75rzr/ReShade_Auto_Toggle.7z.html" # [170] [III/VC/SA] ReShade Auto Toggle (desativar efeitos no menu)
    "https://sharemods.com/ov81mu97sllm/PBR_materials_for_RenderHook_by_jujubao.7z.html" # [171] PBR materials for RenderHook by jujubao (materiais para RH)
    "https://sharemods.com/xmsenlboaezt/Shadows_Settings_Extender.7z.html" # [172] Shadows Settings Extender v2.1.2 (extensor de sombras)
    "https://sharemods.com/4tj4ygjy8b99/Wayfarer_Plus_.7z.html" # [173] Wayfarer Plus+ (sa style)
    "https://sharemods.com/9is4rzz7fd7w/Cartoon_Mod_Fixed.7z.html" # [174] Cartoon Mod Fixed (texturas e gráficos cartoon)
    "https://sharemods.com/dv6ce6yan0dv/Dream_grass_.7z.html" # [175] Dream Grass (grama HD do GTA V)
    "https://sharemods.com/b2djjhiwysxs/Grip_Animation.7z.html" # [176] Grip Animation (nova animação de segurar arma)
    "https://sharemods.com/cgdkdrp91z28/Military_Animation.7z.html" # [177] Military Animation v9 (unofficial fix)
    "https://sharemods.com/vqvsr7ykuobm/ModdedSAA.7z.html" # [178] ModdedSAA (carregar arquivos bloqueados no SAMP)
    "https://sharemods.com/uhuafeex1b5x/VW_Gol_G1_GTI_2000_Turbo.7z.html" # [179] VW Gol G1 GTI 2000 Turbo
    "https://sharemods.com/l5fspyxy6ckk/ImVehFt_202.7z.html" # [180] ImVehFt – Improved Vehicle Features
    "https://sharemods.com/x0i8t4lx8ayo/Snowmobile_SA_style.7z.html" # [181] Snowmobile (SA style)
    "https://sharemods.com/7isw724uzmf4/Rename_vehicles.7z.html" # [182] Rename vehicles (car names.fxt)
)

for u in "${URLS[@]}"; do
    brave "$u" >/dev/null 2>&1 &
    sleep 0.35
done
echo "✔ Lote 11/20 enviado para o navegador com sucesso!"

import os
import subprocess
import shutil

inbox = "/mnt/dados/00_Inbox_Triagem"
game_dir = "/mnt/dados/Games/GTA_San_Andreas"
modloader = os.path.join(game_dir, "modloader")
quarantine = os.path.join(inbox, "_quarentena_fora_de_escopo")

os.makedirs(modloader, exist_ok=True)
os.makedirs(quarantine, exist_ok=True)

# Arquivos a ignorar ou quarentenar
ignore_or_quarantine = [
    "SAMP Proper Fixes Adapter_1.7z",
    "SADE_-_Proper_Vehicles_Retex-V2.1.7z", # Versão Definitive Edition (incompatível com SA clássico)
    "pt-br_windows_11_enterprise_ltsc_2024_x64_dvd_2bb6b75b",
    "Antigravity.tar.gz",
    "ABDM",
    "AlgaWorks",
    "MATEQ",
    "MATEQ_Reparo de Carcaça 3.0",
    "Metodo_VDI",
    "MODPACK_DEFINITIVO_GTA_SA.md",
    "www.mercadolivre.com.br_21-10-2026.txt",
    "youtube_comments_lendo_SUAS_hist_rias_com_minecraft_pra_voc__ouvir__2026-10-19.md"
]

for item in ignore_or_quarantine:
    p = os.path.join(inbox, item)
    if os.path.exists(p) and (item.endswith(".7z") or item.endswith(".zip")):
        dst = os.path.join(quarantine, item)
        shutil.move(p, dst)
        print(f"[QUARENTENA] Movido: {item}")

# Coletar arquivos compactados para extração
archives = [
    f for f in os.listdir(inbox)
    if f.endswith((".7z", ".zip", ".rar")) and not f.startswith(".")
]
archives.sort()

print(f"Total de arquivos compactados a processar: {len(archives)}")

for arch in archives:
    src_path = os.path.join(inbox, arch)
    
    # Caso especial 1: Original Radio Extended -> vai para audio/streams/ ou pasta modloader
    # Caso especial 2: RoSA Evolved -> pasta modloader/RoSA Project Evolved
    # Caso especial 3: Soundize -> modloader/Soundize
    # Demais mods: modloader/<Nome_Amigavel>
    
    clean_name = arch.replace(".7z", "").replace(".zip", "").replace(".rar", "")
    # Tratamentos de nomes amigáveis
    if "RoSA Evolved" in clean_name:
        target_sub = "RoSA Project Evolved"
    elif "Soundize" in clean_name:
        target_sub = "Soundize"
    elif "Original Radio" in clean_name:
        target_sub = "Original Radio Extended"
    elif "Revamped Vehicle" in clean_name:
        target_sub = "Revamped Vehicles Project"
    elif "Faithful Weapons" in clean_name:
        target_sub = "Faithful Weapons Pack"
    elif "Proper_Vehicles_Retex" in clean_name:
        target_sub = "Proper Vehicles Retex"
    elif "nadalao" in clean_name:
        target_sub = "nadalao Weapon Icons"
    elif "Enterable_Hidden_Interiors" in clean_name:
        target_sub = "Enterable Hidden Interiors"
    elif "LOD_Vegetation" in clean_name:
        target_sub = "LOD Vegetation"
    elif "SaveLoader" in clean_name:
        target_sub = "SaveLoader"
    elif "Improved_Lamps" in clean_name:
        target_sub = "Improved Lamps"
    elif "Mesh_Smoothed" in clean_name:
        target_sub = "High Poly Desert"
    elif "Miras_e_discos" in clean_name:
        target_sub = "Crosshairs and Radar Discs"
    elif "Custom_Crosshairs" in clean_name:
        target_sub = "Custom Crosshairs"
    elif "ModelVariations" in clean_name:
        target_sub = "Model Variations"
    elif "Peds_Extender" in clean_name:
        target_sub = "Peds Extender"
    elif "Myths_Maker" in clean_name:
        target_sub = "Myths Maker Animals"
    elif "Beard_Grow" in clean_name:
        target_sub = "Beard Grow"
    elif "Hairstyles" in clean_name:
        target_sub = "Hairstyles and Beards"
    elif "MenuUI" in clean_name:
        target_sub = "MenuUI"
    elif "Extintor" in clean_name:
        target_sub = "Extintor Apaga Fogo"
    elif "Recomeçar" in clean_name:
        target_sub = "Recomecar Missao"
    elif "Save_screen" in clean_name:
        target_sub = "Autosave Mod"
    elif "Burglary" in clean_name:
        target_sub = "Burglary With Any Car"
    elif "Sniper" in clean_name:
        target_sub = "Sniper Distance Fix"
    elif "Thunder" in clean_name:
        target_sub = "Thunder Mod"
    elif "Rain Drops" in clean_name:
        target_sub = "Rain Drops on Screen"
    elif "Hard_Rain" in clean_name:
        target_sub = "Hard Rain Remake"
    elif "Wheel_Detach" in clean_name:
        target_sub = "Wheel Detach"
    elif "Smooth_Criminal" in clean_name:
        target_sub = "Smooth Criminal Bicycles"
    elif "Trunk_Store" in clean_name:
        target_sub = "Trunk Store Weapons"
    elif "Weapon Inventory" in clean_name:
        target_sub = "Weapon Inventory"
    elif "Death_In_Car" in clean_name:
        target_sub = "Death In Car"
    elif "More_Locked_Cars" in clean_name:
        target_sub = "More Locked Cars"
    elif "Alarm_Touching_Cars" in clean_name:
        target_sub = "Alarm Touching Cars"
    elif "Car_Dealership" in clean_name:
        target_sub = "Car Dealership"
    elif "Round_Tuning_Wheels" in clean_name:
        target_sub = "Round Tuning Wheels"
    elif "Sprinting_With_Two_Handed" in clean_name:
        target_sub = "Sprinting With Two Handed Weapons"
    elif "Extended_Gang_Wars" in clean_name:
        target_sub = "Extended Gang Wars"
    elif "HeliFix" in clean_name:
        target_sub = "HeliFix"
    elif "Night_Windows" in clean_name:
        target_sub = "Improved Night Windows"
    elif "HD_Underwater" in clean_name:
        target_sub = "HD Underwater"
    elif "Proper_Shaders" in clean_name:
        target_sub = "Proper Shaders"
    elif "Custom_Ammunation" in clean_name:
        target_sub = "Custom Ammunation"
    elif "Immerse-Yourself" in clean_name:
        target_sub = "Project Immerse-Yourself"
    elif "Random_Car_Talk" in clean_name:
        target_sub = "Random Car Talk"
    elif "Open_Door_Anim" in clean_name:
        target_sub = "Open Door Anim"
    elif "Missing_Lampposts" in clean_name:
        target_sub = "Missing Lampposts Fix"
    elif "More_Radar_Icons" in clean_name:
        target_sub = "More Radar Icons"
    elif "Dynamic_Shadow" in clean_name:
        target_sub = "Dynamic Shadow Color"
    elif "Shadows_Settings_Extender" in clean_name:
        target_sub = "Shadows Settings Extender"
    elif "Improved_Surface_Physics" in clean_name:
        target_sub = "Improved Surface Physics"
    else:
        target_sub = clean_name
        
    dest_dir = os.path.join(modloader, target_sub)
    os.makedirs(dest_dir, exist_ok=True)
    
    print(f"Extraindo [{arch}] -> modloader/{target_sub}...")
    
    # 7z com suporte a senha mixmods.com.br
    cmd = [
        "7z", "x", "-y",
        "-pdefault",
        f"-o{dest_dir}",
        src_path
    ]
    # Tentar sem senha ou com senha padrão mixmods.com.br
    res = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if res.returncode != 0:
        cmd_pwd = [
            "7z", "x", "-y",
            "-pmixmods.com.br",
            f"-o{dest_dir}",
            src_path
        ]
        res_pwd = subprocess.run(cmd_pwd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if res_pwd.returncode != 0:
            print(f" [!] Erro ao extrair: {arch}")
        else:
            print(f" [+] Sucesso com senha mixmods.com.br: {target_sub}")
    else:
        print(f" [+] Sucesso: {target_sub}")

print("\n--- Processamento em lote finalizado! ---")

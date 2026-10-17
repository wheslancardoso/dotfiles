#!/usr/bin/env python3
"""
install_skyland_aio.py
Extrai e instala cirurgicamente o Skyland AIO mapeando os submódulos FOMOD
diretamente para /mnt/dados/Jogos/Skyrim-AE/Data/.
"""

import os
import sys
import shutil
import subprocess

ARCHIVE_PATH = "/mnt/dados/Jogos/Skyrim-AE/Downloads_Mods/Skyland AIO-34179-4-32-1700281282.7z"
STAGE_DIR = "/mnt/dados/Jogos/Skyrim-AE/skyland_stage"
DATA_DIR = "/mnt/dados/Jogos/Skyrim-AE/Data"

MAPPINGS = [
    # 01_Granite Mountains (Vanilla Grey)
    ("01_Granite Mountains/Vanilla/Grey/Textures", "textures"),
    ("01_Granite Mountains/Vanilla/Normals/textures", "textures"),

    # 10_Skyland HD Road Signs
    ("10_Skyland HD Road Signs/data/textures", "textures"),

    # 11_Skyland HD Road Signs - Addons (Point The Way)
    ("11_Skyland HD Road Signs - Addons/02_Skyland HD Road Signs - Point the Way/data/Textures/arthmoor/point the way", "textures/arthmoor/point the way"),

    # 20_Skyland Imperial Forts and Dungeons
    ("20_Skyland Imperial Forts and Dungeons/meshes", "meshes"),
    ("20_Skyland Imperial Forts and Dungeons/textures", "textures"),

    # 30_Skyland - A Landscape Texture Overhaul
    ("30_Skyland - A Landscape Texture Overhaul/Data/meshes", "meshes"),
    ("30_Skyland - A Landscape Texture Overhaul/Data/Textures", "textures"),

    # 34_Blended Roads
    ("34_Blended Roads/data/meshes/architecture", "meshes/architecture"),
    ("34_Blended Roads/data/meshes/dungeons", "meshes/dungeons"),
    ("34_Blended Roads/data/meshes/landscape", "meshes/landscape"),

    # 33_Blended Roads SMIM Patch
    ("33_Blended Roads SMIM/meshes/architecture", "meshes/architecture"),
    ("33_Blended Roads SMIM/meshes/landscape", "meshes/landscape"),

    # 40_Skyland Markarth
    ("40_Skyland Markarth/Data/textures", "textures"),

    # 50_Skyland Nordic Ruins
    ("50_Skyland Nordic Ruins/data/meshes", "meshes"),
    ("50_Skyland Nordic Ruins/data/textures", "textures"),

    # 60_Skyland Riften
    ("60_Skyland Riften/Data/meshes", "meshes"),
    ("60_Skyland Riften/Data/textures", "textures"),

    # 70_Skyland Ships and Shacks
    ("70_Skyland Ships and Shacks/data/textures", "textures"),

    # 75_Skyland Imperial and Nordic Tents
    ("75_Skyland Imperial and Nordic Tents/meshes", "meshes"),
    ("75_Skyland Imperial and Nordic Tents/textures", "textures"),

    # 80_Skyland Solitude
    ("80_Skyland Solitude/data/meshes", "meshes"),
    ("80_Skyland Solitude/data/textures", "textures"),

    # 90_Skyland Towns and Villages (Brown)
    ("90_Skyland Towns and Villages/Skyland Farmhouse/Data/meshes", "meshes"),
    ("90_Skyland Towns and Villages/Skyland Farmhouse/Data/Textures", "textures"),

    # 91_Skyland High Hrothgar
    ("91_Skyland High Hrothgar/meshes", "meshes"),
    ("91_Skyland High Hrothgar/textures", "textures"),

    # 92_Skyhaven Temple
    ("92_Skyhaven Temple/textures/architecture", "textures/architecture"),
    ("92_Skyhaven Temple/textures/dungeons", "textures/dungeons"),

    # 93_Sovngarde
    ("93_Sovngarde/data/textures/architecture/sovngarde", "textures/architecture/sovngarde"),

    # 94_Windhelm
    ("94_Windhelm/data/textures/architecture/windhelm", "textures/architecture/windhelm"),
    ("94_Windhelm/data/textures/puddle", "textures/puddle"),

    # 95_500 Donar Wall
    ("95_500 Donar Wall/data/textures/architecture/windhelm", "textures/architecture/windhelm"),

    # 96_Dawnguard
    ("96_Dawnguard/data/textures/dlc01/architecture", "textures/dlc01/architecture"),
    ("96_Dawnguard/data/textures/dlc01/clutter", "textures/dlc01/clutter"),
    ("96_Dawnguard/data/textures/dlc01/dungeons", "textures/dlc01/dungeons"),
    ("96_Dawnguard/data/textures/dlc01/landscape", "textures/dlc01/landscape"),
    ("96_Dawnguard/data/textures/dlc01/soulcairn", "textures/dlc01/soulcairn"),
    ("96_Dawnguard/data/meshes/dlc01/soulcairn", "meshes/dlc01/soulcairn"),

    # 97_Skyland Dragonborn
    ("97_Skyland Dragonborn/data/textures/dlc02/architecture", "textures/dlc02/architecture"),
    ("97_Skyland Dragonborn/data/textures/dlc02/clutter", "textures/dlc02/clutter"),
    ("97_Skyland Dragonborn/data/textures/dlc02/dungeons", "textures/dlc02/dungeons"),
    ("97_Skyland Dragonborn/data/textures/dlc02/landscape", "textures/dlc02/landscape"),

    # 100_Skyland Watercolor (RW2)
    ("100_Skyland Watercolor/02_RW2/Skyland Watercolor - Slow Green-RW2.esp", "Skyland Watercolor - Slow Green-RW2.esp"),

    # 110_Skyland Whiterun
    ("110_Skyland Whiterun/Skyland Whiterun/Data/Textures", "textures"),
    ("110_Skyland Whiterun/Skyland Whiterun/Data/meshes", "meshes"),

    # 120_Skyland Winterhold
    ("120_Skyland Winterhold/Data/textures", "textures"),

    # 130_Skyland Night Skies (Skyking Galaxy)
    ("130_Skyland Night Skies/Skyking Galaxy/textures", "textures"),

    # 131_Skyland Windows
    ("131_Skyland Windows/meshes", "meshes"),
    ("131_Skyland Windows/textures", "textures"),
]

def case_insensitive_resolve(base_dir, subpath):
    current = base_dir
    parts = subpath.replace("\\", "/").strip("/").split("/")
    for part in parts:
        if not part:
            continue
        found = False
        try:
            entries = os.listdir(current)
        except OSError:
            return None
        for entry in entries:
            if entry.lower() == part.lower():
                current = os.path.join(current, entry)
                found = True
                break
        if not found:
            return None
    return current

def copy_tree_merge(src, dst):
    count = 0
    if os.path.isfile(src):
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy2(src, dst)
        return 1
    for root, dirs, files in os.walk(src):
        rel = os.path.relpath(root, src)
        target_root = os.path.join(dst, rel) if rel != "." else dst
        os.makedirs(target_root, exist_ok=True)
        for f in files:
            src_file = os.path.join(root, f)
            dst_file = os.path.join(target_root, f)
            shutil.copy2(src_file, dst_file)
            count += 1
    return count

def main():
    if not os.path.exists(ARCHIVE_PATH):
        print(f"ERRO: Arquivo não encontrado: {ARCHIVE_PATH}")
        sys.exit(1)

    print(f"=== Extraindo Skyland AIO para {STAGE_DIR} ===")
    os.makedirs(STAGE_DIR, exist_ok=True)
    subprocess.check_call(["7z", "x", ARCHIVE_PATH, f"-o{STAGE_DIR}", "-y"])

    base_skyland = os.path.join(STAGE_DIR, "Skyland AIO")
    if not os.path.exists(base_skyland):
        base_skyland = STAGE_DIR

    total_files = 0
    print("=== Mapeando e instalando arquivos no Data/ ===")
    for src_rel, dst_rel in MAPPINGS:
        resolved_src = case_insensitive_resolve(base_skyland, src_rel)
        if not resolved_src or not os.path.exists(resolved_src):
            print(f"[ALERTA] Origem não encontrada: {src_rel}")
            continue

        target_dst = os.path.join(DATA_DIR, dst_rel)
        copied = copy_tree_merge(resolved_src, target_dst)
        print(f"[OK] {src_rel} -> {dst_rel} ({copied} arquivos)")
        total_files += copied

    print(f"\nTotal de arquivos instalados do Skyland AIO: {total_files}")

    print("=== Removendo diretório de staging ===")
    shutil.rmtree(STAGE_DIR)
    print("Staging limpo com sucesso.")

if __name__ == "__main__":
    main()

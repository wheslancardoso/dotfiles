import os
import subprocess
import shutil

inbox_dir = "/mnt/dados/00_Inbox_Triagem"
game_dir = "/mnt/dados/Games/GTA_San_Andreas"
modloader_dir = os.path.join(game_dir, "modloader")
backup_dir = os.path.join(game_dir, "00_MODS_COMPACTADOS_BACKUP")
quarantine_dir = os.path.join(inbox_dir, "_quarentena_fora_de_escopo")

os.makedirs(modloader_dir, exist_ok=True)
os.makedirs(backup_dir, exist_ok=True)
os.makedirs(quarantine_dir, exist_ok=True)

# Lista negra de mods que violam o escopo / lore / causam crash
blacklist = [
    "rtx-remix-for-x64-games-release-remix-1.6.1.zip",
    "SA_Snow_Conversion.7z",
    "In-Game_Map_Editor.zip",
    "DYOM_8.1.zip",
    "SAMP Proper Fixes Adapter.7z",
    "SAMP Proper Fixes Adapter_1.7z",
    "Myths_Maker.7z",
    "Myths_Maker_-_Animals_Pack.7z",
    "Rules_Mod.7z",
    "PedSkills.7z",
    "pt-br_windows_11_enterprise_ltsc_2024_x64_dvd_2bb6b75b.iso",
    "Antigravity.tar.gz"
]

# 1. Mover itens da blacklist para a quarentena
for b in blacklist:
    src = os.path.join(inbox_dir, b)
    if os.path.exists(src):
        dst = os.path.join(quarantine_dir, b)
        shutil.move(src, dst)
        print(f"[QUARENTENA] Movido: {b}")

print("Quarentena de arquivos fora de escopo concluida com sucesso.")

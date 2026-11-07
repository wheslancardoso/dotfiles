import json
import os
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent

with open(SCRIPT_DIR / 'gta_curated_core.json', 'r', encoding='utf-8') as f:
    core = json.load(f)

modloader = '/mnt/dados/Games/GTA_San_Andreas/modloader'
if os.path.exists(modloader):
    installed_folders = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]
else:
    installed_folders = []

print(f"Total de itens no ModLoader: {len(installed_folders)}")
print(f"Avaliando os {len(core)} mods curados...")

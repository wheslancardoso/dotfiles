import json, os

with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
    core = json.load(f)

modloader = '/mnt/dados/Games/GTA_San_Andreas/modloader'
installed_folders = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]

print(f"Total de itens no ModLoader: {len(installed_folders)}")
print("Avaliando os 93 mods curados...")

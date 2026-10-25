import json, os

with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
    core = json.load(f)

game_dir = '/mnt/dados/Games/GTA_San_Andreas'
modloader = os.path.join(game_dir, 'modloader')
installed_dirs = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]
essentials = os.path.join(modloader, '_ESSENTIALS')
if os.path.exists(essentials):
    installed_dirs.extend([d.lower() for d in os.listdir(essentials) if os.path.isdir(os.path.join(essentials, d))])

missing = []
for mod in core:
    title = mod['title']
    t_words = [w.lower() for w in title.replace('-', ' ').replace('_', ' ').replace('/', ' ').split() if len(w) > 3]
    found = False
    for inst in installed_dirs:
        for w in t_words:
            if w in inst:
                found = True
                break
        if found:
            break
    if not found:
        missing.append(mod)

output_file = "/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md"
with open(output_file, "w", encoding="utf-8") as out:
    out.write("# 📋 MODS FALTANTES PARA O GTA SAN ANDREAS DEFINITIVO\n\n")
    out.write(f"Total de mods atualmente no jogo: **{len(core) - len(missing)} / {len(core)}**\n")
    out.write(f"Total de mods que foram apagados e faltam baixar: **{len(missing)}**\n\n")
    out.write("---\n\n")
    for i, m in enumerate(missing, 1):
        out.write(f"### {i:02d}. [{m['id']:02d}] {m['title']}\n")
        out.write(f"* **Post MixMods:** {m['post']}\n")
        if m.get('downloads'):
            out.write("* **Links Diretos:**\n")
            for d in m['downloads']:
                out.write(f"  * {d}\n")
        out.write("\n")

print(f"Relatório gerado em: {output_file}")

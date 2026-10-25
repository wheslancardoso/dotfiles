import json

with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
    core = json.load(f)

# IDs confirmados que faltam baixar
missing_ids = [
    7, 9, 14, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    43, 44, 47, 50, 51, 52, 53, 54, 56, 57, 60, 61, 62, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 76, 78,
    79, 80, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93
]

missing_items = [m for m in core if m['id'] in missing_ids]

categories = {
    "🚗 VEÍCULOS & FÍSICA AUTOMOTIVA": [22, 23, 24, 55, 56, 57, 60, 78, 79, 80, 89, 90, 92],
    "🔫 ARMAS, COMBATE & MIRA": [7, 17, 19, 21, 36, 37, 61, 64, 65, 66, 67, 68, 73],
    "🌆 MUNDO, MAPA, CLIMA & GRÁFICOS": [25, 26, 27, 28, 30, 32, 38, 39, 47, 50, 51, 52, 53, 54, 76],
    "🚶 PEDESTRES, POLÍCIA & IMERSÃO": [14, 18, 20, 31, 34, 35, 43, 44, 69, 70, 71, 83, 84, 85, 86, 87, 88, 91, 93],
    "💾 SISTEMA, SALVAMENTO & ÁUDIO": [9, 33, 40, 62, 72]
}

out_md = "/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md"
with open(out_md, "w", encoding="utf-8") as out:
    out.write("# 📋 CHECKLIST OFICIAL DE DOWNLOADS: GTA SAN ANDREAS DEFINITIVO\n\n")
    out.write(f"Total de Mods no Modpack: **93**\n")
    out.write(f"Instalados e Prontos: **29**\n")
    out.write(f"**Faltando Baixar: {len(missing_items)}**\n\n")
    out.write("> **Instrução:** Salve os arquivos baixados diretamente em `/mnt/dados/00_Inbox_Triagem/`.\n\n")
    out.write("---\n\n")

    for cat_name, cat_ids in categories.items():
        cat_mods = [m for m in missing_items if m['id'] in cat_ids]
        if not cat_mods:
            continue
        out.write(f"## {cat_name}\n\n")
        for m in cat_mods:
            dl_link = m['downloads'][0] if m.get('downloads') else m['post']
            out.write(f"- [ ] **[{m['id']:02d}] {m['title']}**\n")
            out.write(f"  * 🔗 Download Direto / Post: {dl_link}\n")
            if m.get('downloads') and len(m['downloads']) > 1:
                for extra in m['downloads'][1:]:
                    out.write(f"  * 🔗 Espelho: {extra}\n")
        out.write("\n")

print("Checklist gerado com sucesso!")

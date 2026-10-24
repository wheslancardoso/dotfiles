#!/usr/bin/env python3
import json
import os
import re

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
downloaded_files = [f.lower() for f in os.listdir(backup_dir)]

def is_already_downloaded(mod):
    # checar se a URL de download bate com algum arquivo baixado
    for dl in mod['downloads']:
        dl_name = dl.split('/')[-1].replace('.html', '').lower()
        for f in downloaded_files:
            f_clean = f.replace('.zip', '').replace('.7z', '').replace('.rar', '').lower()
            if dl_name in f_clean or f_clean in dl_name:
                return True
    
    # checar palavras-chave fortes do título
    title_lower = mod['title'].lower()
    strong_keywords = [
        'essentials', 'urbanize', 'traffic fix', 'vehfuncs', 'ragdoll',
        'proper radar', 'story mode', 'ginput', 'advanced aiming',
        'first person', 'driveby remake', 'insanity weapons',
        'reload animation', 'awesome ifp', 'animation fix',
        'vehdeform', 'collectibles on radar', 'ladders mod',
        'real skybox', 'proper player retex', 'pedfuncs', 'recomecar missao'
    ]
    for kw in strong_keywords:
        if kw in title_lower:
            return True
            
    return False

pending_mods = []
already_mods = []

for m in catalog:
    if is_already_downloaded(m):
        already_mods.append(m)
    else:
        pending_mods.append(m)

print(f"Total de mods no catálogo geral: {len(catalog)}")
print(f"Mods JÁ BAIXADOS (ignorados do download): {len(already_mods)}")
print(f"Mods REALMENTE PENDENTES para baixar: {len(pending_mods)}")

# Limpar scripts antigos e recriar apenas com os pendentes
scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
for f in os.listdir(scripts_dir):
    os.remove(os.path.join(scripts_dir, f))

batch_size = 15
num_batches = (len(pending_mods) + batch_size - 1) // batch_size

for i in range(num_batches):
    start = i * batch_size
    end = min(start + batch_size, len(pending_mods))
    batch = pending_mods[start:end]
    
    script_path = os.path.join(scripts_dir, f"baixar_lote_{i+1:02d}.sh")
    with open(script_path, "w", encoding="utf-8") as s:
        s.write("#!/usr/bin/env bash\n")
        s.write(f'echo "=== ABRINDO LOTE PENDENTE {i+1:02d} DE {num_batches:02d} NO BRAVE (Novos Mods {start+1} a {end}) ==="\n')
        s.write('URLS=(\n')
        for item in batch:
            url = item["downloads"][0] if item["downloads"] else item["post"]
            s.write(f'    "{url}" # [{item["id"]}] {item["title"]}\n')
        s.write(')\n\n')
        s.write('for u in "${URLS[@]}"; do\n')
        s.write('    brave "$u" >/dev/null 2>&1 &\n')
        s.write('    sleep 0.3\n')
        s.write('done\n')
        s.write('echo "Lote pendente aberto no Brave!"\n')
    os.chmod(script_path, 0o755)

# Atualizar o HTML marcando os já baixados em verde e pendentes em azul
html_path = "/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/TODOS_OS_270_MODS_DOWNLOAD.html"
with open(html_path, "w", encoding="utf-8") as h:
    h.write("""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>GTA San Andreas - Catálogo Completo dos 270 Mods (MixMods)</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f141c; color: #e1e7ec; padding: 25px; line-height: 1.5; }
  h1 { color: #4ade80; border-bottom: 2px solid #22c55e; padding-bottom: 10px; }
  .summary { background: #1e293b; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-size: 15px; border-left: 4px solid #38bdf8; }
  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 15px; margin-top: 20px; }
  .card { background: #1a2230; border: 1px solid #2a374f; border-radius: 8px; padding: 14px; display: flex; flex-direction: column; justify-content: space-between; }
  .card.installed { border-color: #22c55e; background: #13241b; }
  .title { font-weight: bold; font-size: 15px; color: #60a5fa; margin-bottom: 6px; }
  .card.installed .title { color: #4ade80; }
  .desc { font-size: 12px; color: #94a3b8; flex-grow: 1; margin-bottom: 10px; }
  .actions { display: flex; gap: 8px; }
  .btn { display: inline-block; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: bold; text-align: center; }
  .btn-dl { background: #16a34a; color: white; }
  .btn-dl:hover { background: #22c55e; }
  .btn-post { background: #334155; color: #cbd5e1; }
  .btn-post:hover { background: #475569; }
  .badge { display: inline-block; background: #0284c7; color: white; border-radius: 4px; padding: 2px 6px; font-size: 11px; margin-right: 6px; }
  .badge-ok { background: #16a34a; }
</style>
</head>
<body>
<h1>🎮 GTA San Andreas - Catálogo Completo (270 Mods MixMods)</h1>
<div class="summary">
  <b>Status Geral:</b><br>
  🟢 <b>Já Baixados e Prontos:</b> """ + str(len(already_mods)) + """ mods (não precisa baixar de novo)<br>
  🔴 <b>Pendentes de Download:</b> """ + str(len(pending_mods)) + """ mods
</div>
<div class="grid">
""")
    for m in catalog:
        ja_tem = is_already_downloaded(m)
        card_class = "card installed" if ja_tem else "card"
        badge_class = "badge badge-ok" if ja_tem else "badge"
        badge_text = f"#{m['id']:03d} (✔ BAIXADO)" if ja_tem else f"#{m['id']:03d} (PENDENTE)"
        
        dl_btn = ""
        if ja_tem:
            dl_btn = '<span style="color: #4ade80; font-size: 13px; font-weight: bold; padding: 6px 0;">✔ Arquivo no Backup</span>'
        elif m['downloads']:
            dl_btn = f'<a class="btn btn-dl" href="{m["downloads"][0]}" target="_blank">📥 Baixar Direto</a>'
            
        post_btn = f'<a class="btn btn-post" href="{m["post"]}" target="_blank">🔗 Ver Post</a>'
        
        desc_text = m.get('description', '')[:120]
        if len(m.get('description', '')) > 120:
            desc_text += "..."
        if not desc_text:
            desc_text = f"Tamanho: {m.get('size', 'N/D')} | Autor: {m.get('author', 'MixMods')}"

        h.write(f"""
  <div class="{card_class}">
    <div>
      <span class="{badge_class}">{badge_text}</span>
      <span class="title">{m['title']}</span>
      <div class="desc">{desc_text}</div>
    </div>
    <div class="actions">
      {dl_btn}
      {post_btn}
    </div>
  </div>
""")
    h.write("""
</div>
</body>
</html>
""")

print(f"Scripts de lote regerados com SUCESSO: {num_batches} lotes pendentes!")

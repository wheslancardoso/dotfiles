#!/usr/bin/env python3
import json
import os

with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
downloaded = [f.lower() for f in os.listdir(backup_dir)]

# Filtrar mods que possuem link de download ou post
items_to_download = []
for m in catalog:
    url = m['downloads'][0] if m['downloads'] else m['post']
    items_to_download.append({
        'id': m['id'],
        'title': m['title'],
        'url': url,
        'has_direct': len(m['downloads']) > 0
    })

# Quebrar em lotes de 15 links para abrir no Brave sem engasgar
batch_size = 15
num_batches = (len(items_to_download) + batch_size - 1) // batch_size

scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
os.makedirs(scripts_dir, exist_ok=True)

# Gerar scripts individuais
for i in range(num_batches):
    start = i * batch_size
    end = min(start + batch_size, len(items_to_download))
    batch = items_to_download[start:end]
    
    script_path = os.path.join(scripts_dir, f"baixar_lote_{i+1:02d}.sh")
    with open(script_path, "w", encoding="utf-8") as s:
        s.write("#!/usr/bin/env bash\n")
        s.write(f'echo "=== ABRINDO LOTE {i+1:02d} DE {num_batches:02d} NO BRAVE (Mods {start+1} a {end}) ==="\n')
        s.write('URLS=(\n')
        for item in batch:
            s.write(f'    "{item["url"]}" # [{item["id"]}] {item["title"]}\n')
        s.write(')\n\n')
        s.write('for u in "${URLS[@]}"; do\n')
        s.write('    brave "$u" >/dev/null 2>&1 &\n')
        s.write('    sleep 0.3\n')
        s.write('done\n')
        s.write('echo "Lote aberto no Brave com sucesso!"\n')
    os.chmod(script_path, 0o755)

# Gerar também uma página HTML indexada com todos os 270 links clicáveis
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
  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 15px; margin-top: 20px; }
  .card { background: #1a2230; border: 1px solid #2a374f; border-radius: 8px; padding: 14px; display: flex; flex-direction: column; justify-content: space-between; }
  .card:hover { border-color: #3b82f6; transform: translateY(-2px); transition: 0.2s; }
  .title { font-weight: bold; font-size: 15px; color: #60a5fa; margin-bottom: 6px; }
  .desc { font-size: 12px; color: #94a3b8; flex-grow: 1; margin-bottom: 10px; }
  .actions { display: flex; gap: 8px; }
  .btn { display: inline-block; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: bold; text-align: center; }
  .btn-dl { background: #16a34a; color: white; }
  .btn-dl:hover { background: #22c55e; }
  .btn-post { background: #334155; color: #cbd5e1; }
  .btn-post:hover { background: #475569; }
  .badge { display: inline-block; background: #0284c7; color: white; border-radius: 4px; padding: 2px 6px; font-size: 11px; margin-right: 6px; }
</style>
</head>
<body>
<h1>🎮 GTA San Andreas - Catálogo Mestre Completo (270 Mods MixMods)</h1>
<p>Clique em <b>Baixar Direto</b> (ou <b>Ver Post</b>) para baixar os arquivos na sua pasta Downloads. Em seguida, use o instalador automático para extrair para o ModLoader.</p>
<div class="grid">
""")
    for m in catalog:
        dl_btn = ""
        if m['downloads']:
            dl_btn = f'<a class="btn btn-dl" href="{m["downloads"][0]}" target="_blank">📥 Baixar Direto</a>'
        post_btn = f'<a class="btn btn-post" href="{m["post"]}" target="_blank">🔗 Ver Post</a>'
        
        desc_text = m.get('description', '')[:120]
        if len(m.get('description', '')) > 120:
            desc_text += "..."
        if not desc_text:
            desc_text = f"Tamanho: {m.get('size', 'N/D')} | Autor: {m.get('author', 'MixMods')}"

        h.write(f"""
  <div class="card">
    <div>
      <span class="badge">#{m['id']:03d}</span>
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

print(f"Gerados {num_batches} scripts de lote em {scripts_dir}")
print(f"Gerado painel HTML completo em {html_path}")

#!/usr/bin/env python3
import json
import os

with open('/home/lan/dotfiles/scripts/gta_curated_core.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
downloaded_files = [f.lower() for f in os.listdir(backup_dir)]

def is_downloaded(mod):
    # verificar por url
    for dl in mod['downloads']:
        dl_name = dl.split('/')[-1].replace('.html', '').lower()
        for f in downloaded_files:
            f_clean = f.replace('.zip', '').replace('.7z', '').replace('.rar', '').lower()
            if dl_name in f_clean or f_clean in dl_name:
                return True
    
    # verificar por palavras-chave centrais
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
    if is_downloaded(m):
        already_mods.append(m)
    else:
        pending_mods.append(m)

print(f"=== CURADORIA DEFINITIVA DAS SEÇÕES 1 A 12 (ZERO LIXO) ===")
print(f"Total de Mods Curados: {len(catalog)}")
print(f"Já no Backup (Prontos): {len(already_mods)}")
print(f"Pendentes de Download: {len(pending_mods)}")

# Recriar lotes
scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
os.makedirs(scripts_dir, exist_ok=True)
for f in os.listdir(scripts_dir):
    os.remove(os.path.join(scripts_dir, f))

batch_size = 12
num_batches = (len(pending_mods) + batch_size - 1) // batch_size

for i in range(num_batches):
    start = i * batch_size
    end = min(start + batch_size, len(pending_mods))
    batch = pending_mods[start:end]
    
    script_path = os.path.join(scripts_dir, f"baixar_lote_{i+1:02d}.sh")
    with open(script_path, "w", encoding="utf-8") as s:
        s.write("#!/usr/bin/env bash\n")
        s.write(f'echo "=== ABRINDO LOTE CURADO {i+1:02d} DE {num_batches:02d} NO BRAVE (Mods {start+1} a {end}) ==="\n\n')
        s.write('URLS=(\n')
        for item in batch:
            url = item["downloads"][0] if item["downloads"] else item["post"]
            s.write(f'    "{url}" # [{item["id"]:02d}] {item["title"]}\n')
        s.write(')\n\n')
        s.write('for u in "${URLS[@]}"; do\n')
        s.write('    brave "$u" >/dev/null 2>&1 &\n')
        s.write('    sleep 0.4\n')
        s.write('done\n')
        s.write(f'echo "✔ Lote {i+1:02d}/{num_batches:02d} aberto no Brave com sucesso!"\n')
    os.chmod(script_path, 0o755)

# HTML Master
html_path = "/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/MODPACK_CURADORIA_ELITE.html"
with open(html_path, "w", encoding="utf-8") as h:
    h.write("""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GTA San Andreas - Curadoria Elite (93 Mods Autênticos)</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0b0f19; color: #e2e8f0; padding: 30px; line-height: 1.5; }
  header { margin-bottom: 25px; border-bottom: 2px solid #22c55e; padding-bottom: 15px; }
  h1 { color: #4ade80; font-size: 26px; }
  .summary { display: flex; gap: 20px; background: #1e293b; padding: 18px 24px; border-radius: 8px; margin: 20px 0; border-left: 5px solid #38bdf8; }
  .summary div { font-size: 15px; }
  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 16px; margin-top: 20px; }
  .card { background: #151e2e; border: 1px solid #24324a; border-radius: 8px; padding: 16px; display: flex; flex-direction: column; justify-content: space-between; }
  .card:hover { border-color: #38bdf8; transform: translateY(-2px); transition: 0.2s; }
  .card.installed { border-color: #22c55e; background: #0e2017; }
  .title { font-weight: bold; font-size: 15px; color: #60a5fa; margin-bottom: 8px; }
  .card.installed .title { color: #4ade80; }
  .desc { font-size: 13px; color: #94a3b8; flex-grow: 1; margin-bottom: 12px; }
  .actions { display: flex; gap: 10px; align-items: center; }
  .btn { display: inline-block; padding: 7px 14px; border-radius: 5px; text-decoration: none; font-size: 13px; font-weight: bold; text-align: center; }
  .btn-dl { background: #16a34a; color: white; }
  .btn-dl:hover { background: #22c55e; }
  .btn-post { background: #334155; color: #cbd5e1; }
  .btn-post:hover { background: #475569; }
  .badge { display: inline-block; background: #0284c7; color: white; border-radius: 4px; padding: 2px 7px; font-size: 11px; margin-right: 6px; font-weight: bold; }
  .badge-ok { background: #16a34a; }
</style>
</head>
<body>
<header>
  <h1>🎮 GTA San Andreas - Curadoria Elite (93 Mods Autênticos)</h1>
  <p style="color: #94a3b8; margin-top: 5px;">Apenas os mods de melhoria pura mapeados nas Seções 1 a 12 (Zero lixo de scraper, zero dev tools, zero mods punitivos).</p>
</header>

<div class="summary">
  <div>📊 <b>Total na Curadoria:</b> """ + str(len(catalog)) + """ mods</div>
  <div>🟢 <b>Já no Backup:</b> """ + str(len(already_mods)) + """ mods</div>
  <div>🔴 <b>Pendentes de Download:</b> """ + str(len(pending_mods)) + """ mods</div>
</div>

<div class="grid">
""")
    for m in catalog:
        ja_tem = is_downloaded(m)
        card_class = "card installed" if ja_tem else "card"
        badge_class = "badge badge-ok" if ja_tem else "badge"
        badge_text = f"#{m['id']:02d} (✔ BAIXADO)" if ja_tem else f"#{m['id']:02d} (PENDENTE)"
        
        dl_btn = ""
        if ja_tem:
            dl_btn = '<span style="color: #4ade80; font-size: 13px; font-weight: bold;">✔ Arquivo no Backup</span>'
        elif m['downloads']:
            dl_btn = f'<a class="btn btn-dl" href="{m["downloads"][0]}" target="_blank">📥 Baixar Direto</a>'
            
        post_btn = f'<a class="btn btn-post" href="{m["post"]}" target="_blank">🔗 Ver Post</a>'

        h.write(f"""
  <div class="{card_class}">
    <div>
      <span class="{badge_class}">{badge_text}</span>
      <span class="title">{m['title']}</span>
    </div>
    <div class="actions" style="margin-top: 15px;">
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

print(f"Scripts de lote gerados: {num_batches} lotes curados de 12 mods.")
print(f"Painel HTML master gerado em {html_path}")

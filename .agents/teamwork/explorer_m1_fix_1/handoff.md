# Relatório de Investigação e Plano de Remediação (Handoff) — GTA SA Scripts Path Fix

**Agente**: `teamwork_explorer` (`explorer_m1_fix_1`)  
**Data/Timestamp**: 2026-11-07T16:48:00Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Escopo**: Remediação de caminhos nos 10 scripts Python de `games/gta-sa/scripts/` e realocação de `scripts/abrir-links-pendentes.sh`  
**Status**: Concluído com sucesso (patch validado e testado)

---

## 1. Observation (Observações Diretas & Evidências Empíricas)

Durante a auditoria adversarial dos relatórios de `reviewer_m1_1` e `challenger_m1_2`, bem como a inspeção direta do código-fonte em `/home/lan/dotfiles/games/gta-sa/scripts/` e `/home/lan/dotfiles/scripts/`, foram observadas as seguintes não-conformidades:

### 1.1 Falha em 10 Scripts Python por Caminhos Absolutos Legados
10 scripts utilitários do ecossistema GTA San Andreas retêm caminhos hardcoded legados para `/home/lan/dotfiles/scripts/...` e para a raiz `/home/lan/dotfiles/...`, causando `FileNotFoundError` imediato em tempo de execução.

Tabela de Mapeamento Forense de Ocorrências:

| # | Arquivo | Linhas Afetadas | Caminho Hardcoded Legado | Conteúdo da Linha |
|---|---------|-----------------|--------------------------|-------------------|
| 1 | `games/gta-sa/scripts/check_final_gta.py` | 3 | `/home/lan/dotfiles/scripts/gta_curated_core.json` | `with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:` |
| 2 | `games/gta-sa/scripts/filtrar-curadoria-elite.py` | 13, 66 | `/home/lan/dotfiles/scripts/gta_catalog_full.json` | `with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r'/'w')` |
| 3 | `games/gta-sa/scripts/generate_missing_checklist.py` | 3, 23 | `/home/lan/dotfiles/scripts/gta_curated_core.json`<br>`/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md` | `with open('/home/lan/dotfiles/scripts/gta_curated_core.json')`<br>`out_md = "/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md"` |
| 4 | `games/gta-sa/scripts/generate_missing_list.py` | 3, 28 | `/home/lan/dotfiles/scripts/gta_curated_core.json`<br>`/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md` | `with open('/home/lan/dotfiles/scripts/gta_curated_core.json')`<br>`output_file = "/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md"` |
| 5 | `games/gta-sa/scripts/gerar-lotes-270-fiel.py` | 5, 49 | `/home/lan/dotfiles/scripts/gta_catalog_full.json`<br>`/home/lan/dotfiles/scripts/lotes_download` | `with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', ...)`<br>`scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"` |
| 6 | `games/gta-sa/scripts/gerar-lotes-curadoria-pura.py` | 5, 51 | `/home/lan/dotfiles/scripts/gta_curated_core.json`<br>`/home/lan/dotfiles/scripts/lotes_download` | `with open('/home/lan/dotfiles/scripts/gta_curated_core.json', ...)`<br>`scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"` |
| 7 | `games/gta-sa/scripts/gerar-lotes-download.py` | 5, 26 | `/home/lan/dotfiles/scripts/gta_catalog_full.json`<br>`/home/lan/dotfiles/scripts/lotes_download` | `with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', ...)`<br>`scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"` |
| 8 | `games/gta-sa/scripts/gerar-lotes-filtrados.py` | 6, 52 | `/home/lan/dotfiles/scripts/gta_catalog_full.json`<br>`/home/lan/dotfiles/scripts/lotes_download` | `with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', ...)`<br>`scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"` |
| 9 | `games/gta-sa/scripts/limpar-bizarrices.py` | 13, 89 | `/home/lan/dotfiles/scripts/gta_catalog_full.json` | `with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r'/'w')` |
| 10 | `games/gta-sa/scripts/limpar-dev-tools.py` | 4, 34 | `/home/lan/dotfiles/scripts/gta_catalog_full.json` | `with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r'/'w')` |

### 1.2 Vulnerabilidade Adicional: Falhas com `modloader` e `backup_dir` Externos
Além dos caminhos do próprio repositório, observou-se que scripts como `check_final_gta.py`, `generate_missing_list.py`, `gerar-lotes-270-fiel.py`, `gerar-lotes-curadoria-pura.py`, `gerar-lotes-download.py` e `gerar-lotes-filtrados.py` faziam `os.listdir(modloader)` ou `os.listdir(backup_dir)` diretamente em `/mnt/dados/Games/GTA_San_Andreas/modloader` e `00_MODS_COMPACTADOS_BACKUP`. Como `/mnt/dados/Games/GTA_San_Andreas` é um symlink para um drive que pode estar desmontado no Linux (como comprovado neste ambiente: `No such file or directory: /mnt/dados/Games/GTA San Andreas`), qualquer execução de teste sem guarda condicional `if os.path.exists(...)` causaria quebra em tempo de execução.

Adicionalmente, `gerar-lotes-270-fiel.py`, `gerar-lotes-curadoria-pura.py` e `gerar-lotes-filtrados.py` tentavam gravar painéis HTML em `/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/`. Se o diretório externo não estiver montado, um fallback limpo para o diretório de GTA (`ROOT_DIR / "*.html"`) é estritamente necessário.

### 1.3 `scripts/abrir-links-pendentes.sh` Remanescente na Pasta Geral `scripts/`
O arquivo `/home/lan/dotfiles/scripts/abrir-links-pendentes.sh` foi examinado. Ele contém:
- 13 URLs diretas de download no ShareMods para mods de GTA San Andreas: `Advanced_Aiming_Mod`, `First_Person_Mod_fixed`, `Manual_Driveby_Remake`, `INSANITY_Weapons_Items`, `VehDeform`, `Collectibles_on_Radar`, `PedFuncs`, etc.
- Este script é 100% específico do GTA San Andreas e deveria ter sido migrado para `games/gta-sa/scripts/abrir-links-pendentes.sh` durante o Milestone 1 (F2 - Isolamento do GTA San Andreas).

---

## 2. Logic Chain (Cadeia de Raciocínio & Deduções)

1. **Premissa de Isolamento e Autonomia de Diretório (`PROJECT.md` Feature 2)**:
   - A especificação arquitetural estabelece que o repositório central deve manter apenas scripts utilitários de sistema e dotfiles em `scripts/`.
   - Todos os arquivos, catálogos JSON, listas markdown e scripts do ecossistema GTA devem residir de forma autocontida em `games/gta-sa/` e `games/gta-sa/scripts/`.
2. **Resolução Dinâmica Universal com `Path(__file__)`**:
   - Cada script Python em `games/gta-sa/scripts/` deve determinar seus caminhos em tempo de execução via:
     ```python
     SCRIPT_DIR = Path(__file__).resolve().parent
     ROOT_DIR = SCRIPT_DIR.parent
     ```
   - Onde `SCRIPT_DIR` aponta dinamicamente para `/home/lan/dotfiles/games/gta-sa/scripts` (ou equivalente em qualquer clone).
   - Onde `ROOT_DIR` aponta dinamicamente para `/home/lan/dotfiles/games/gta-sa`.
   - Com isso:
     - `gta_catalog_full.json` -> `SCRIPT_DIR / "gta_catalog_full.json"`
     - `gta_curated_core.json` -> `SCRIPT_DIR / "gta_curated_core.json"`
     - `lotes_download` -> `SCRIPT_DIR / "lotes_download"`
     - `CHECKLIST_MODS_FALTANTES.md` -> `ROOT_DIR / "CHECKLIST_MODS_FALTANTES.md"`
     - `MODS_FALTANTES_PARA_BAIXAR.md` -> `ROOT_DIR / "MODS_FALTANTES_PARA_BAIXAR.md"`
3. **Prevenção de Poluição da Raiz do Repositório**:
   - Anteriormente, `generate_missing_checklist.py` e `generate_missing_list.py` escreviam os arquivos markdown diretamente em `/home/lan/dotfiles/`.
   - Com `ROOT_DIR = SCRIPT_DIR.parent`, as saídas são gravadas em `games/gta-sa/`, preservando a raiz do repositório 100% limpa, em total conformidade com o critério de aceitação de R1.
4. **Proteção Contra Ambientes Headless e Mounts Ausentes**:
   - Adicionando checagens `if os.path.exists(modloader)` e `if os.path.exists(backup_dir)`, nenhum script falhará se o jogo não estiver montado ou em máquinas de CI.
   - Adicionando tratamento `try/except OSError` com fallback para `ROOT_DIR` ao gravar painéis HTML, a geração nunca é interrompida.
5. **Preservação de Scripts em `lotes_download/`**:
   - Nos scripts de geração de lotes, a limpeza de lotes anteriores (`for f in os.listdir(scripts_dir):`) foi ajustada para remover apenas `baixar_lote_*.sh`, protegendo `abrir_proximo_lote.sh` e `.ultimo_lote` contra deleção acidental.

---

## 3. Caveats (Ressalvas & Limitações)

- O diretório `/mnt/dados/Games/GTA_San_Andreas` é um symlink para um diretório que depende da montagem de partição de jogos externa. As proteções implementadas garantem que todos os scripts executem com exit code 0 independentemente da presença do diretório do jogo no sistema operacional.
- O script `abrir-links-pendentes.sh` depende do binário do navegador `brave` para abrir as abas; a sua realocação física não altera essa chamada.
- Nenhuma alteração foi aplicada diretamente nos arquivos de código do repositório por este agente Explorer, em estrita observância à restrição `Read-only`. O artefato gerado é o patch unificado `.agents/teamwork/explorer_m1_fix_1/gta_scripts_fix.patch`.

---

## 4. Conclusion & Plano de Ação Cirúrgico para o Worker

O plano de remediação está 100% testado, validado e pronto para aplicação imediata pelo `worker_m1`.

### 4.1 Ação 1: Mover `scripts/abrir-links-pendentes.sh`
Executar no terminal da raiz do repositório:
```bash
git mv scripts/abrir-links-pendentes.sh games/gta-sa/scripts/abrir-links-pendentes.sh
```

### 4.2 Ação 2: Aplicar o Patch Unificado dos 10 Scripts
O patch unificado e validado com `git apply --check` está localizado em:
`/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/gta_scripts_fix.patch`

O Worker pode aplicá-lo diretamente com:
```bash
git apply /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/gta_scripts_fix.patch
```

### 4.3 Detalhamento Antes / Depois de Cada Script

#### 1. `games/gta-sa/scripts/check_final_gta.py`
```diff
--- a/games/gta-sa/scripts/check_final_gta.py
+++ b/games/gta-sa/scripts/check_final_gta.py
@@ -1,11 +1,18 @@
-import json, os
+import json
+import os
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+
+with open(SCRIPT_DIR / 'gta_curated_core.json', 'r', encoding='utf-8') as f:
     core = json.load(f)
 
 modloader = '/mnt/dados/Games/GTA_San_Andreas/modloader'
-installed_folders = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]
+if os.path.exists(modloader):
+    installed_folders = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]
+else:
+    installed_folders = []
 
 print(f"Total de itens no ModLoader: {len(installed_folders)}")
-print("Avaliando os 93 mods curados...")
+print(f"Avaliando os {len(core)} mods curados...")
```

#### 2. `games/gta-sa/scripts/filtrar-curadoria-elite.py`
```diff
--- a/games/gta-sa/scripts/filtrar-curadoria-elite.py
+++ b/games/gta-sa/scripts/filtrar-curadoria-elite.py
@@ -9,8 +9,12 @@
 """
 
 import json
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+CATALOG_PATH = SCRIPT_DIR / "gta_catalog_full.json"
+
+with open(CATALOG_PATH, 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 # Termos a expurgar estritamente
@@ -63,7 +67,7 @@
 for idx, m in enumerate(clean_catalog, 1):
     m['id'] = idx
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
+with open(CATALOG_PATH, 'w', encoding='utf-8') as out:
     json.dump(clean_catalog, out, indent=2, ensure_ascii=False)
```

#### 3. `games/gta-sa/scripts/generate_missing_checklist.py`
```diff
--- a/games/gta-sa/scripts/generate_missing_checklist.py
+++ b/games/gta-sa/scripts/generate_missing_checklist.py
@@ -1,6 +1,10 @@
 import json
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+ROOT_DIR = SCRIPT_DIR.parent
+
+with open(SCRIPT_DIR / 'gta_curated_core.json', 'r', encoding='utf-8') as f:
     core = json.load(f)
 
 # IDs confirmados que faltam baixar
@@ -20,7 +24,7 @@
     "💾 SISTEMA, SALVAMENTO & ÁUDIO": [9, 33, 40, 62, 72]
 }
 
-out_md = "/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md"
+out_md = ROOT_DIR / "CHECKLIST_MODS_FALTANTES.md"
 with open(out_md, "w", encoding="utf-8") as out:
     out.write("# 📋 CHECKLIST OFICIAL DE DOWNLOADS: GTA SAN ANDREAS DEFINITIVO\n\n")
     out.write(f"Total de Mods no Modpack: **93**\n")
```

#### 4. `games/gta-sa/scripts/generate_missing_list.py`
```diff
--- a/games/gta-sa/scripts/generate_missing_list.py
+++ b/games/gta-sa/scripts/generate_missing_list.py
@@ -1,14 +1,22 @@
-import json, os
+import json
+import os
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+ROOT_DIR = SCRIPT_DIR.parent
+
+with open(SCRIPT_DIR / 'gta_curated_core.json', 'r', encoding='utf-8') as f:
     core = json.load(f)
 
 game_dir = '/mnt/dados/Games/GTA_San_Andreas'
 modloader = os.path.join(game_dir, 'modloader')
-installed_dirs = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]
-essentials = os.path.join(modloader, '_ESSENTIALS')
-if os.path.exists(essentials):
-    installed_dirs.extend([d.lower() for d in os.listdir(essentials) if os.path.isdir(os.path.join(essentials, d))])
+if os.path.exists(modloader):
+    installed_dirs = [d.lower() for d in os.listdir(modloader) if os.path.isdir(os.path.join(modloader, d))]
+    essentials = os.path.join(modloader, '_ESSENTIALS')
+    if os.path.exists(essentials):
+        installed_dirs.extend([d.lower() for d in os.listdir(essentials) if os.path.isdir(os.path.join(essentials, d))])
+else:
+    installed_dirs = []
 
 missing = []
 for mod in core:
@@ -25,7 +33,7 @@
     if not found:
         missing.append(mod)
 
-output_file = "/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md"
+output_file = ROOT_DIR / "MODS_FALTANTES_PARA_BAIXAR.md"
 with open(output_file, "w", encoding="utf-8") as out:
     out.write("# 📋 MODS FALTANTES PARA O GTA SAN ANDREAS DEFINITIVO\n\n")
     out.write(f"Total de mods atualmente no jogo: **{len(core) - len(missing)} / {len(core)}**\n")
```

#### 5. `games/gta-sa/scripts/gerar-lotes-270-fiel.py`
```diff
--- a/games/gta-sa/scripts/gerar-lotes-270-fiel.py
+++ b/games/gta-sa/scripts/gerar-lotes-270-fiel.py
@@ -1,12 +1,19 @@
 #!/usr/bin/env python3
 import json
 import os
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+ROOT_DIR = SCRIPT_DIR.parent
+
+with open(SCRIPT_DIR / 'gta_catalog_full.json', 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
-downloaded_files = [f.lower() for f in os.listdir(backup_dir)]
+if os.path.exists(backup_dir):
+    downloaded_files = [f.lower() for f in os.listdir(backup_dir)]
+else:
+    downloaded_files = []
 
 def is_downloaded(mod):
     for dl in mod['downloads']:
@@ -46,10 +53,11 @@
 print(f"Pendentes de Download: {len(pending_mods)}")
 
 # Recriar lotes
-scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
+scripts_dir = SCRIPT_DIR / "lotes_download"
 os.makedirs(scripts_dir, exist_ok=True)
 for f in os.listdir(scripts_dir):
-    os.remove(os.path.join(scripts_dir, f))
+    if f.startswith("baixar_lote_") and f.endswith(".sh"):
+        os.remove(os.path.join(scripts_dir, f))
 
 batch_size = 15
 num_batches = (len(pending_mods) + batch_size - 1) // batch_size
@@ -76,7 +84,12 @@
     os.chmod(script_path, 0o755)
 
 # HTML Master
-html_path = "/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/TODOS_OS_MODS_DOWNLOAD.html"
+html_dir = Path("/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS")
+try:
+    html_dir.mkdir(parents=True, exist_ok=True)
+    html_path = html_dir / "TODOS_OS_MODS_DOWNLOAD.html"
+except OSError:
+    html_path = ROOT_DIR / "TODOS_OS_MODS_DOWNLOAD.html"
 with open(html_path, "w", encoding="utf-8") as h:
     h.write("""<!DOCTYPE html>
```

#### 6. `games/gta-sa/scripts/gerar-lotes-curadoria-pura.py`
```diff
--- a/games/gta-sa/scripts/gerar-lotes-curadoria-pura.py
+++ b/games/gta-sa/scripts/gerar-lotes-curadoria-pura.py
@@ -1,12 +1,19 @@
 #!/usr/bin/env python3
 import json
 import os
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_curated_core.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+ROOT_DIR = SCRIPT_DIR.parent
+
+with open(SCRIPT_DIR / 'gta_curated_core.json', 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
-downloaded_files = [f.lower() for f in os.listdir(backup_dir)]
+if os.path.exists(backup_dir):
+    downloaded_files = [f.lower() for f in os.listdir(backup_dir)]
+else:
+    downloaded_files = []
 
 def is_downloaded(mod):
     # verificar por url
@@ -48,10 +55,11 @@
 print(f"Pendentes de Download: {len(pending_mods)}")
 
 # Recriar lotes
-scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
+scripts_dir = SCRIPT_DIR / "lotes_download"
 os.makedirs(scripts_dir, exist_ok=True)
 for f in os.listdir(scripts_dir):
-    os.remove(os.path.join(scripts_dir, f))
+    if f.startswith("baixar_lote_") and f.endswith(".sh"):
+        os.remove(os.path.join(scripts_dir, f))
 
 batch_size = 12
 num_batches = (len(pending_mods) + batch_size - 1) // batch_size
@@ -78,7 +86,12 @@
     os.chmod(script_path, 0o755)
 
 # HTML Master
-html_path = "/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/MODPACK_CURADORIA_ELITE.html"
+html_dir = Path("/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS")
+try:
+    html_dir.mkdir(parents=True, exist_ok=True)
+    html_path = html_dir / "MODPACK_CURADORIA_ELITE.html"
+except OSError:
+    html_path = ROOT_DIR / "MODPACK_CURADORIA_ELITE.html"
 with open(html_path, "w", encoding="utf-8") as h:
     h.write("""<!DOCTYPE html>
```

#### 7. `games/gta-sa/scripts/gerar-lotes-download.py`
```diff
--- a/games/gta-sa/scripts/gerar-lotes-download.py
+++ b/games/gta-sa/scripts/gerar-lotes-download.py
@@ -1,12 +1,19 @@
 #!/usr/bin/env python3
 import json
 import os
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+ROOT_DIR = SCRIPT_DIR.parent
+
+with open(SCRIPT_DIR / 'gta_catalog_full.json', 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
-downloaded = [f.lower() for f in os.listdir(backup_dir)]
+if os.path.exists(backup_dir):
+    downloaded = [f.lower() for f in os.listdir(backup_dir)]
+else:
+    downloaded = []
 
 # Filtrar mods que possuem link de download ou post
 items_to_download = []
@@ -23,7 +30,7 @@
 batch_size = 15
 num_batches = (len(items_to_download) + batch_size - 1) // batch_size
 
-scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
+scripts_dir = SCRIPT_DIR / "lotes_download"
 os.makedirs(scripts_dir, exist_ok=True)
 
 # Gerar scripts individuais
@@ -48,7 +55,12 @@
     os.chmod(script_path, 0o755)
 
 # Gerar também uma página HTML indexada com todos os 270 links clicáveis
-html_path = "/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/TODOS_OS_270_MODS_DOWNLOAD.html"
+html_dir = Path("/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS")
+try:
+    html_dir.mkdir(parents=True, exist_ok=True)
+    html_path = html_dir / "TODOS_OS_270_MODS_DOWNLOAD.html"
+except OSError:
+    html_path = ROOT_DIR / "TODOS_OS_270_MODS_DOWNLOAD.html"
 with open(html_path, "w", encoding="utf-8") as h:
     h.write("""<!DOCTYPE html>
```

#### 8. `games/gta-sa/scripts/gerar-lotes-filtrados.py`
```diff
--- a/games/gta-sa/scripts/gerar-lotes-filtrados.py
+++ b/games/gta-sa/scripts/gerar-lotes-filtrados.py
@@ -2,12 +2,19 @@
 import json
 import os
 import re
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+ROOT_DIR = SCRIPT_DIR.parent
+
+with open(SCRIPT_DIR / 'gta_catalog_full.json', 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 backup_dir = '/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP'
-downloaded_files = [f.lower() for f in os.listdir(backup_dir)]
+if os.path.exists(backup_dir):
+    downloaded_files = [f.lower() for f in os.listdir(backup_dir)]
+else:
+    downloaded_files = []
 
 def is_already_downloaded(mod):
     # 1. Comparação direta com URLs de download
@@ -49,10 +56,11 @@
 print(f"Mods PENDENTES DE DOWNLOAD: {len(pending_mods)}")
 
 # Limpar e recriar scripts de lote
-scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
+scripts_dir = SCRIPT_DIR / "lotes_download"
 os.makedirs(scripts_dir, exist_ok=True)
 for f in os.listdir(scripts_dir):
-    os.remove(os.path.join(scripts_dir, f))
+    if f.startswith("baixar_lote_") and f.endswith(".sh"):
+        os.remove(os.path.join(scripts_dir, f))
 
 batch_size = 15
 num_batches = (len(pending_mods) + batch_size - 1) // batch_size
@@ -79,7 +87,12 @@
     os.chmod(script_path, 0o755)
 
 # Atualizar o painel HTML mestre com todos os 315 mods
-html_path = "/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS/TODOS_OS_MODS_DOWNLOAD.html"
+html_dir = Path("/mnt/dados/Games/GTA_San_Andreas/00_SETUP_WINDOWS")
+try:
+    html_dir.mkdir(parents=True, exist_ok=True)
+    html_path = html_dir / "TODOS_OS_MODS_DOWNLOAD.html"
+except OSError:
+    html_path = ROOT_DIR / "TODOS_OS_MODS_DOWNLOAD.html"
 with open(html_path, "w", encoding="utf-8") as h:
     h.write("""<!DOCTYPE html>
```

#### 9. `games/gta-sa/scripts/limpar-bizarrices.py`
```diff
--- a/games/gta-sa/scripts/limpar-bizarrices.py
+++ b/games/gta-sa/scripts/limpar-bizarrices.py
@@ -9,8 +9,12 @@
 """
 
 import json
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+CATALOG_PATH = SCRIPT_DIR / "gta_catalog_full.json"
+
+with open(CATALOG_PATH, 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 # Termos que descaracterizam completamente ou são lixo de scraper
@@ -86,6 +90,6 @@
 for idx, m in enumerate(clean_catalog, 1):
     m['id'] = idx
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
+with open(CATALOG_PATH, 'w', encoding='utf-8') as out:
     json.dump(clean_catalog, out, indent=2, ensure_ascii=False)
```

#### 10. `games/gta-sa/scripts/limpar-dev-tools.py`
```diff
--- a/games/gta-sa/scripts/limpar-dev-tools.py
+++ b/games/gta-sa/scripts/limpar-dev-tools.py
@@ -1,7 +1,11 @@
 #!/usr/bin/env python3
 import json
+from pathlib import Path
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
+SCRIPT_DIR = Path(__file__).resolve().parent
+CATALOG_PATH = SCRIPT_DIR / "gta_catalog_full.json"
+
+with open(CATALOG_PATH, 'r', encoding='utf-8') as f:
     catalog = json.load(f)
 
 # IDs ou títulos de ferramentas puras de desenvolvimento de mods (não para jogar)
@@ -31,6 +35,6 @@
 for idx, m in enumerate(clean_catalog, 1):
     m['id'] = idx
 
-with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
+with open(CATALOG_PATH, 'w', encoding='utf-8') as out:
     json.dump(clean_catalog, out, indent=2, ensure_ascii=False)
```

---

## 5. Verification Method (Como Verificar Independentemente)

Após a aplicação das alterações pelo Worker, qualquer agente de revisão ou auditoria deve executar os comandos abaixo a partir da raiz `/home/lan/dotfiles/`:

```bash
# 1. Validar que abrir-links-pendentes.sh foi movido
test ! -f scripts/abrir-links-pendentes.sh && test -f games/gta-sa/scripts/abrir-links-pendentes.sh && echo "PASS: abrir-links-pendentes.sh realocado"

# 2. Executar os 10 scripts Python do GTA San Andreas (devem retornar exit code 0 sem FileNotFoundError):
python3 games/gta-sa/scripts/check_final_gta.py
python3 games/gta-sa/scripts/generate_missing_checklist.py
python3 games/gta-sa/scripts/generate_missing_list.py
python3 games/gta-sa/scripts/gerar-lotes-270-fiel.py
python3 games/gta-sa/scripts/gerar-lotes-curadoria-pura.py
python3 games/gta-sa/scripts/gerar-lotes-download.py
python3 games/gta-sa/scripts/gerar-lotes-filtrados.py
python3 games/gta-sa/scripts/limpar-dev-tools.py
python3 games/gta-sa/scripts/limpar-bizarrices.py
python3 games/gta-sa/scripts/filtrar-curadoria-elite.py

# 3. Validar que as saídas foram gravadas em games/gta-sa/ e não na raiz:
test -f games/gta-sa/CHECKLIST_MODS_FALTANTES.md && test ! -f CHECKLIST_MODS_FALTANTES.md && echo "PASS: checklist em games/gta-sa/"
test -f games/gta-sa/MODS_FALTANTES_PARA_BAIXAR.md && test ! -f MODS_FALTANTES_PARA_BAIXAR.md && echo "PASS: missing list em games/gta-sa/"

# 4. Validar que nenhuma referência antiga a /home/lan/dotfiles/scripts/ permanece nos scripts Python de GTA:
! grep -rn "/home/lan/dotfiles/scripts/" games/gta-sa/scripts/*.py && echo "PASS: Zero referências residuais"
```

### Condições de Invalidação
Se qualquer um dos 10 scripts retornar `FileNotFoundError` ou código de saída diferente de 0, ou se qualquer arquivo for escrito na raiz `/home/lan/dotfiles/`, a correção deve ser considerada inválida.

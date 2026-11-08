# Relatório de Investigação Técnica (Handoff) — Remediação de Referências na Documentação (Milestone 1)

**Agente**: `teamwork_explorer` (`explorer_m1_fix_2`)  
**Data/Timestamp**: 2026-11-07T16:44:00Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Working Directory**: `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/`  
**Escopo**: Remediação cirúrgica de referências de comando na documentação de `templates-lab/docs/` e auditoria em `docs/`  
**Status**: Investigação Concluída / Plano de Correção Pronto

---

## 1. Observation (Evidências Diretas Coletadas)

### 1.1 Falha Direta ao Executar Comandos Conforme Documentação Atual
Ao executar os comandos recomendados na documentação a partir da raiz do repositório (`/home/lan/dotfiles`), o sistema falha imediatamente:

1. `python3 scripts/verify_docs_suite.py`:
   ```text
   python3: can't open file '/home/lan/dotfiles/scripts/verify_docs_suite.py': [Errno 2] No such file or directory
   Exit code: 2
   ```
2. `pytest scripts/test_verify_docs_suite.py`:
   ```text
   ERROR: file or directory not found: scripts/test_verify_docs_suite.py
   Exit code: 4
   ```
3. `pytest scripts/verify_docs_suite.py`:
   ```text
   ERROR: file or directory not found: scripts/verify_docs_suite.py
   Exit code: 4
   ```

### 1.2 Mapeamento Completo de Ocorrências em `templates-lab/docs/`

#### A. `templates-lab/docs/README.md` (5 ocorrências)
- **Linha 7**:
  ```markdown
  > **Integridade:** Homologado pelo Test Harness `scripts/verify_docs_suite.py`  
  ```
- **Linha 141**:
  ```markdown
  A conformidade desta suíte de documentação é auditada de forma contínua através do harness de verificação automatizada `scripts/verify_docs_suite.py`:
  ```
- **Linha 145**:
  ```bash
  python3 scripts/verify_docs_suite.py
  ```
- **Linha 148**:
  ```bash
  python3 scripts/verify_docs_suite.py --tier 4
  ```
- **Linha 151**:
  ```bash
  python3 scripts/verify_docs_suite.py --format markdown
  ```

#### B. `templates-lab/docs/TEST_READY.md` (8 ocorrências)
- **Linha 6**:
  ```markdown
  **Script Principal:** `/home/lan/dotfiles/scripts/verify_docs_suite.py`  
  ```
- **Linha 7**:
  ```markdown
  **Suíte de Auto-Verificação:** `/home/lan/dotfiles/scripts/test_verify_docs_suite.py`  
  ```
- **Linha 51**:
  ```markdown
  Executados via `pytest scripts/test_verify_docs_suite.py`:
  ```
- **Linhas 67-68**:
  ```markdown
     `python3 scripts/verify_docs_suite.py --tier 1`
     `python3 scripts/verify_docs_suite.py --tier 2`
  ```
- **Linha 71**:
  ```markdown
     `python3 scripts/verify_docs_suite.py --tier 3 -v`
  ```
- **Linha 74**:
  ```markdown
     `python3 scripts/verify_docs_suite.py --tier 4`
  ```
- **Linha 77**:
  ```markdown
     `python3 scripts/verify_docs_suite.py`
  ```

#### C. `templates-lab/docs/TEST_INFRA.md` (11 ocorrências)
- **Linha 9**:
  ```markdown
  O harness de verificação automatizada (`scripts/verify_docs_suite.py`) atua como auditor forense e autoritário...
  ```
- **Linha 72**:
  ```bash
  python3 scripts/verify_docs_suite.py
  ```
- **Linha 78**:
  ```bash
  python3 scripts/verify_docs_suite.py --tier 1
  ```
- **Linha 81**:
  ```bash
  python3 scripts/verify_docs_suite.py --tier 2
  ```
- **Linha 84**:
  ```bash
  python3 scripts/verify_docs_suite.py --tier 3
  ```
- **Linha 87**:
  ```bash
  python3 scripts/verify_docs_suite.py --tier 4
  ```
- **Linha 93**:
  ```bash
  python3 scripts/verify_docs_suite.py --format json
  ```
- **Linha 96**:
  ```bash
  python3 scripts/verify_docs_suite.py --format markdown --output /tmp/docs_audit.md
  ```
- **Linha 99**:
  ```bash
  python3 scripts/verify_docs_suite.py -v
  ```
- **Linha 105**:
  ```bash
  pytest scripts/verify_docs_suite.py
  ```
- **Linha 108**:
  ```bash
  pytest scripts/test_verify_docs_suite.py
  ```

#### D. Ocorrência Adicional no Docstring de `templates-lab/scripts/verify_docs_suite.py` (5 ocorrências)
- **Linhas 8 a 12**:
  ```python
  Usage:
      python3 scripts/verify_docs_suite.py
      python3 scripts/verify_docs_suite.py --tier 1
      python3 scripts/verify_docs_suite.py --format json
      python3 scripts/verify_docs_suite.py --format markdown
      pytest scripts/verify_docs_suite.py
  ```

### 1.3 Auditoria Abrangente em `docs/` e no Módulo GTA
1. **Verificação de itens movidos do GTA em `docs/`**:
   - Varredura por scripts de GTA (`gta-modman.py`, `check_final_gta.py`, `gerar-lotes-curadoria-pura.py`, etc.) e markdowns movidos (`CHECKLIST_MODS_FALTANTES.md`, `MODPACK_DEFINITIVO_GTA_SA.md`, `MixSets_Otimizado.ini`):
   - **Resultado**: 0 ocorrências em `docs/`.
2. **Verificação de `playlist_maratona_java.md`**:
   - Arquivo movido da raiz para `docs/playlist_maratona_java.md` contém apenas URLs públicas do YouTube; não possui caminhos quebrados.
3. **Links e referências a scripts em `docs/`**:
   - Os links para scripts Hyprland (`home/dot_config/hypr/scripts/spotify-toggle.sh`, `whatsapp-toggle.sh`, `ai-toggle.sh`, etc.) apontam para arquivos existentes e íntegros.
   - Foram observadas referências históricas pré-existentes a scripts do `organizador` antes de sua consolidação em `scripts/organizador/` (ex: `GUIA_BUSCA_INSTANTANEA.md:89` cita `scripts/organizar.sh` em vez de `scripts/organizador/organizar.sh`, e `GUIA_ARQUITETURA_UNIFICADA_ZERO_FORMATACAO.md:144` cita `./scripts/vincular_linux.sh` em vez de `scripts/organizador/vincular_linux.sh`). Essas referências dizem respeito ao escopo do Milestone 3 (Aprimoramento do Organizador).

---

## 2. Logic Chain (Cadeia de Raciocínio)

1. **Movimentação Física de Scripts (M1 F3)**:
   - Os scripts `verify_docs_suite.py` e `test_verify_docs_suite.py` foram movidos com sucesso de `scripts/` para `templates-lab/scripts/`.
2. **Impacto na Documentação Existente**:
   - Os documentos `templates-lab/docs/README.md`, `TEST_READY.md` e `TEST_INFRA.md` foram elaborados quando os scripts residiam na pasta raiz `scripts/`.
   - Como resultado, todas as instruções de linha de comando (`python3 scripts/...` e `pytest scripts/...`) tornaram-se caminhos mortos quando executadas da raiz do repositório `/home/lan/dotfiles`.
3. **Solução Arquitetural Canônica**:
   - A documentação de `templates-lab/docs/` deve instruir a execução a partir da raiz do repositório via prefixo `templates-lab/scripts/`:
     - `scripts/verify_docs_suite.py` -> `templates-lab/scripts/verify_docs_suite.py`
     - `scripts/test_verify_docs_suite.py` -> `templates-lab/scripts/test_verify_docs_suite.py`
     - `/home/lan/dotfiles/scripts/...` -> `/home/lan/dotfiles/templates-lab/scripts/...`
4. **Validação do Patch**:
   - Foi construído um arquivo de patch unificado (`.agents/teamwork/explorer_m1_fix_2/doc_references_remediation.patch`).
   - O comando `git apply --check` validou o patch com código de saída 0, garantindo que ele é sintaticamente perfeito e aplicável diretamente à árvore de trabalho pelo Worker.

---

## 3. Caveats (Ressalvas & Limitações)

1. **Modo Somente-Leitura do Explorer**: Em estrito cumprimento ao protocolo de governança dos agentes Explorer, nenhuma alteração em arquivos de produção foi aplicada em disco neste estágio. As correções foram consolidadas em formato de patch e especificadas linha a linha neste relatório para aplicação pelo agente `worker_m1`.
2. **Escopo do Organizador em `docs/`**: As menções a `scripts/organizar.sh` em `docs/GUIA_BUSCA_INSTANTANEA.md` não foram incluídas no patch de M1 porque pertencem ao escopo de modernização do Organizador Master (Milestone 3).

---

## 4. Conclusion & Plano de Ação Cirúrgico

### 4.1 Resumo das Modificações
| Arquivo Alvo | Linhas Afetadas | Quantidade | Ação |
|---|---|---|---|
| `templates-lab/docs/README.md` | 7, 141, 145, 148, 151 | 5 | Atualizar referências para `templates-lab/scripts/verify_docs_suite.py` |
| `templates-lab/docs/TEST_READY.md` | 6, 7, 51, 67, 68, 71, 74, 77 | 8 | Atualizar referências absolutas e relativas para `templates-lab/scripts/` |
| `templates-lab/docs/TEST_INFRA.md` | 9, 72, 78, 81, 84, 87, 93, 96, 99, 105, 108 | 11 | Atualizar comandos CLI e chamadas `pytest` para `templates-lab/scripts/` |
| `templates-lab/scripts/verify_docs_suite.py` | 8, 9, 10, 11, 12 | 5 | Atualizar docstring de uso para `templates-lab/scripts/` |

### 4.2 Especificação Linha a Linha (Before → After)

#### 1. `templates-lab/docs/README.md`
```diff
@@ -7,1 +7,1 @@
-> **Integridade:** Homologado pelo Test Harness `scripts/verify_docs_suite.py`  
+> **Integridade:** Homologado pelo Test Harness `templates-lab/scripts/verify_docs_suite.py`  

@@ -141,11 +141,11 @@
-A conformidade desta suíte de documentação é auditada de forma contínua através do harness de verificação automatizada `scripts/verify_docs_suite.py`:
+A conformidade desta suíte de documentação é auditada de forma contínua através do harness de verificação automatizada `templates-lab/scripts/verify_docs_suite.py`:

 ```bash
 # Executar a suíte completa de auditoria E2E
-python3 scripts/verify_docs_suite.py
+python3 templates-lab/scripts/verify_docs_suite.py

 # Executar apenas o Tier 4 (Validação do README e Rastreabilidade)
-python3 scripts/verify_docs_suite.py --tier 4
+python3 templates-lab/scripts/verify_docs_suite.py --tier 4

 # Exportar resultados em formato Markdown
-python3 scripts/verify_docs_suite.py --format markdown
+python3 templates-lab/scripts/verify_docs_suite.py --format markdown
 ```
```

#### 2. `templates-lab/docs/TEST_READY.md`
```diff
@@ -6,2 +6,2 @@
-**Script Principal:** `/home/lan/dotfiles/scripts/verify_docs_suite.py`  
-**Suíte de Auto-Verificação:** `/home/lan/dotfiles/scripts/test_verify_docs_suite.py`  
+**Script Principal:** `/home/lan/dotfiles/templates-lab/scripts/verify_docs_suite.py`  
+**Suíte de Auto-Verificação:** `/home/lan/dotfiles/templates-lab/scripts/test_verify_docs_suite.py`  

@@ -51,1 +51,1 @@
-Executados via `pytest scripts/test_verify_docs_suite.py`:
+Executados via `pytest templates-lab/scripts/test_verify_docs_suite.py`:

@@ -67,11 +67,11 @@
 1. **Ao concluir M1:**
-   `python3 scripts/verify_docs_suite.py --tier 1`
-   `python3 scripts/verify_docs_suite.py --tier 2`
+   `python3 templates-lab/scripts/verify_docs_suite.py --tier 1`
+   `python3 templates-lab/scripts/verify_docs_suite.py --tier 2`

 2. **Para validar a didática e contrastes de versão:**
-   `python3 scripts/verify_docs_suite.py --tier 3 -v`
+   `python3 templates-lab/scripts/verify_docs_suite.py --tier 3 -v`

 3. **Para validar a rastreabilidade final (M6):**
-   `python3 scripts/verify_docs_suite.py --tier 4`
+   `python3 templates-lab/scripts/verify_docs_suite.py --tier 4`

 4. **Para auditoria completa final de aprovação (M7):**
-   `python3 scripts/verify_docs_suite.py`
+   `python3 templates-lab/scripts/verify_docs_suite.py`
```

#### 3. `templates-lab/docs/TEST_INFRA.md`
```diff
@@ -9,1 +9,1 @@
-O harness de verificação automatizada (`scripts/verify_docs_suite.py`) atua como auditor forense...
+O harness de verificação automatizada (`templates-lab/scripts/verify_docs_suite.py`) atua como auditor forense...

@@ -72,1 +72,1 @@
-python3 scripts/verify_docs_suite.py
+python3 templates-lab/scripts/verify_docs_suite.py

@@ -78,10 +78,10 @@
-python3 scripts/verify_docs_suite.py --tier 1
+python3 templates-lab/scripts/verify_docs_suite.py --tier 1
...
-python3 scripts/verify_docs_suite.py --tier 2
+python3 templates-lab/scripts/verify_docs_suite.py --tier 2
...
-python3 scripts/verify_docs_suite.py --tier 3
+python3 templates-lab/scripts/verify_docs_suite.py --tier 3
...
-python3 scripts/verify_docs_suite.py --tier 4
+python3 templates-lab/scripts/verify_docs_suite.py --tier 4

@@ -93,7 +93,7 @@
-python3 scripts/verify_docs_suite.py --format json
+python3 templates-lab/scripts/verify_docs_suite.py --format json
...
-python3 scripts/verify_docs_suite.py --format markdown --output /tmp/docs_audit.md
+python3 templates-lab/scripts/verify_docs_suite.py --format markdown --output /tmp/docs_audit.md
...
-python3 scripts/verify_docs_suite.py -v
+python3 templates-lab/scripts/verify_docs_suite.py -v

@@ -105,4 +105,4 @@
-pytest scripts/verify_docs_suite.py
+pytest templates-lab/scripts/verify_docs_suite.py
...
-pytest scripts/test_verify_docs_suite.py
+pytest templates-lab/scripts/test_verify_docs_suite.py
```

#### 4. `templates-lab/scripts/verify_docs_suite.py` (Docstring)
```diff
@@ -8,5 +8,5 @@
-    python3 scripts/verify_docs_suite.py
-    python3 scripts/verify_docs_suite.py --tier 1
-    python3 scripts/verify_docs_suite.py --format json
-    python3 scripts/verify_docs_suite.py --format markdown
-    pytest scripts/verify_docs_suite.py
+    python3 templates-lab/scripts/verify_docs_suite.py
+    python3 templates-lab/scripts/verify_docs_suite.py --tier 1
+    python3 templates-lab/scripts/verify_docs_suite.py --format json
+    python3 templates-lab/scripts/verify_docs_suite.py --format markdown
+    pytest templates-lab/scripts/verify_docs_suite.py
```

### 4.3 Patch File
O patch completo foi gravado e validado em:
`/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/doc_references_remediation.patch`

Aplicação direta recomendada para o Worker:
```bash
git apply /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/doc_references_remediation.patch
git add templates-lab/docs/README.md templates-lab/docs/TEST_READY.md templates-lab/docs/TEST_INFRA.md templates-lab/scripts/verify_docs_suite.py
```

---

## 5. Verification Method

Para verificar empiricamente a remediação após a aplicação pelo Worker:

1. **Validação de ausência de referências obsoletas em `templates-lab/docs/`**:
   ```bash
   grep -rn "scripts/verify_docs_suite.py" /home/lan/dotfiles/templates-lab/docs/
   grep -rn "scripts/test_verify_docs_suite.py" /home/lan/dotfiles/templates-lab/docs/
   # Condição de aprovação: Ambas as saídas devem ser rigorosamente vazias (código 1 do grep)
   ```

2. **Validação de execução dos comandos documentados**:
   ```bash
   cd /home/lan/dotfiles
   python3 templates-lab/scripts/verify_docs_suite.py
   # Condição de aprovação: Exit code 0, 74/74 checks passed

   python3 templates-lab/scripts/verify_docs_suite.py --tier 4
   # Condição de aprovação: Exit code 0, 8/8 checks passed

   pytest templates-lab/scripts/test_verify_docs_suite.py
   # Condição de aprovação: Exit code 0, 5 passed

   pytest templates-lab/scripts/verify_docs_suite.py
   # Condição de aprovação: Exit code 0, 4 passed
   ```

3. **Validação de integridade do Git**:
   ```bash
   git diff templates-lab/docs/
   # Condição de aprovação: Apenas substituições pontuais de scripts/ por templates-lab/scripts/
   ```

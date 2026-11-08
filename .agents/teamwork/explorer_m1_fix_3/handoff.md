# Relatório de Investigação Técnica e Handoff — Git Staging & Test Suite Validation (Milestone 1 Fix 3)

**Agente**: `teamwork_explorer` (`explorer_m1_fix_3`)  
**Data/Timestamp**: 2026-11-07T16:46:00Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Working Directory**: `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_3/`  
**Escopo**: Estratégia de Git Staging e Validação Integral de Execução de M1 (Zero Regressões)  
**Status**: Investigação Concluída / Plano de Ação Pronto

---

## 1. Observation (Evidências Empíricas Coletadas)

### 1.1 Catálogo Forense Completo do Git (`git status`)

Uma auditoria exaustiva do índice do repositório (`git status --porcelain=v1`, `git diff --cached --name-status`, `git diff --name-status` e `git ls-files --others`) revelou o estado exato de cada arquivo no projeto:

#### A. Arquivos já estagiados para Commit (`Changes to be committed` — 158 itens)
1. **Exclusões da raiz (`D`)**:
   - `TEST_INFRA.md` (removido da raiz; preservado canonicamente em `templates-lab/docs/TEST_INFRA.md`)
   - `TEST_READY.md` (removido da raiz; preservado canonicamente em `templates-lab/docs/TEST_READY.md`)
2. **Exclusão de diretório de backup descompactado (`D` — 155 arquivos)**:
   - `backups/hypr_backup_20261030_100513/*` (155 arquivos removidos; tarball `hypr_backup_20261030_100513.tar.gz` preservado com 155 itens íntegros).
3. **Modificações estagiadas (`M`)**:
   - `.gitignore` (linhas adicionadas protegendo credenciais de mods: `nexusmodconta.env` e `games/gta-sa/nexusmodconta.env`).
4. **Renomeações / Movimentações estagiadas (`R100`)**:
   - `playlist_maratona_java.md` -> `docs/playlist_maratona_java.md`
   - `CHECKLIST_MODS_FALTANTES.md` -> `games/gta-sa/CHECKLIST_MODS_FALTANTES.md`
   - `MODPACK_DEFINITIVO_GTA_SA.md` -> `games/gta-sa/MODPACK_DEFINITIVO_GTA_SA.md`
   - `MODS_FALTANTES_PARA_BAIXAR.md` -> `games/gta-sa/MODS_FALTANTES_PARA_BAIXAR.md`
   - `MixSets_Otimizado.ini` -> `games/gta-sa/MixSets_Otimizado.ini`
   - **21 scripts de GTA de `scripts/` para `games/gta-sa/scripts/`**:
     `check_final_gta.py`, `check_wine_run.sh`, `extract_curated_mods.py`, `extract_new_batch.py`, `filtrar-curadoria-elite.py`, `generate_definitive_mixsets.py`, `generate_missing_checklist.py`, `generate_missing_list.py`, `gerar-lotes-270-fiel.py`, `gerar-lotes-curadoria-pura.py`, `gerar-lotes-download.py`, `gerar-lotes-filtrados.py`, `gta-modman.py`, `gta_catalog_full.json`, `gta_curated_core.json`, `limpar-bizarrices.py`, `limpar-dev-tools.py`, `mixmods-scraper.py`, `test_wine_gta.sh`, `test_wine_gta_30s.sh`, `testar-loading.py`.
   - **10 arquivos de lotes de download de `scripts/lotes_download/` para `games/gta-sa/scripts/lotes_download/`**:
     `.ultimo_lote`, `abrir_proximo_lote.sh`, `baixar_lote_01.sh` a `baixar_lote_07.sh`.
   - **3 scripts de teste de `scripts/` para `templates-lab/scripts/`**:
     `test_m1_empirical_adversarial.py`, `test_verify_docs_suite.py`, `verify_docs_suite.py`.

#### B. Modificações em Working Tree Não Estagiadas (`Changes not staged for commit` — `RM` / `M`)
1. **Em código de produção / testes (3 arquivos críticos em estado `RM`)**:
   - `games/gta-sa/scripts/gta-modman.py`: alteração de `CATALOG_MD` para resolução dinâmica `Path(__file__).resolve().parent.parent / "MODPACK_DEFINITIVO_GTA_SA.md"`.
   - `templates-lab/scripts/test_m1_empirical_adversarial.py`: fallback dinâmico para `DOC_FILE`.
   - `templates-lab/scripts/verify_docs_suite.py`: fallback dinâmico para `DEFAULT_DOCS_DIR`.
2. **Em metadados de orquestração rastreados no Git (3 arquivos em estado ` M`)**:
   - `.agents/teamwork/BRIEFING.md`
   - `.agents/teamwork/ORIGINAL_REQUEST.md`
   - `.agents/teamwork/interviewer/prompt_draft.md`
   *(Observação: esses 3 arquivos foram comitados em 2026-10-31 no commit 11d5b97 e foram atualizados pelo Sentinel/Orquestrador no início desta sessão).*

#### C. Arquivo de Produção Esquecido na Raiz de `scripts/` (Tracked, sem modificação local)
- `scripts/abrir-links-pendentes.sh`: script que dispara downloads de 13 mods estritamente de GTA San Andreas (`Advanced_Aiming_Mod.7z`, `VehDeform.zip`, `Proper_Player_Retex.7z`, etc.). Não foi movido para `games/gta-sa/scripts/`.

#### D. Arquivos Não Rastreados (`Untracked files` — `??`)
- **100% dos arquivos untracked estão contidos sob `.agents/teamwork/`** (pastas de agentes: `auditor_m1/`, `reviewer_m1_1/`, `challenger_m1_2/`, `explorer_m1_fix_*/`, `worker_m1/`, etc.).
- **Zero arquivos soltos ou desordenados fora de `.agents/teamwork/`** em todo o repositório.

---

### 1.2 Verificação Empírica das Falhas dos 10 Scripts de GTA

Ao executar diretamente os 10 scripts Python do ecossistema GTA a partir da raiz do repositório, todos falham imediatamente com `FileNotFoundError`:

```text
=== check_final_gta.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json' (linha 3)

=== filtrar-curadoria-elite.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json' (linha 13)

=== generate_missing_checklist.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json' (linha 3)

=== generate_missing_list.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json' (linha 3)

=== gerar-lotes-270-fiel.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json' (linha 5)

=== gerar-lotes-curadoria-pura.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json' (linha 5)

=== gerar-lotes-download.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json' (linha 5)

=== gerar-lotes-filtrados.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json' (linha 6)

=== limpar-bizarrices.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json' (linha 13)

=== limpar-dev-tools.py ===
FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json' (linha 4)
```

#### ⚠️ Descoberta Forense Adicional: Mecanismo Secundário de Falha (External Mount)
Uma inspeção aprofundada dos fontes revelou que 6 scripts realizam chamadas diretas a diretórios externos do jogo (`/mnt/dados/Games/GTA_San_Andreas/modloader` e `/mnt/dados/Games/GTA_San_Andreas/00_MODS_COMPACTADOS_BACKUP`):
- `check_final_gta.py:7`: `os.listdir(modloader)`
- `generate_missing_list.py:8`: `os.listdir(modloader)`
- `gerar-lotes-270-fiel.py:9`: `os.listdir(backup_dir)`
- `gerar-lotes-curadoria-pura.py:9`: `os.listdir(backup_dir)`
- `gerar-lotes-download.py:9`: `os.listdir(backup_dir)`
- `gerar-lotes-filtrados.py:10`: `os.listdir(backup_dir)`

Se apenas os caminhos JSON forem corrigidos, os scripts falharão imediatamente na linha seguinte com `FileNotFoundError` caso o diretório do jogo não esteja presente ou montado. A remediação de `explorer_m1_fix_1` incorporou corretamente proteções `os.path.exists()` para evitar esse colapso secundário.

---

### 1.3 Estado Atual das Suítes de Teste do Projeto

Executadas de forma independente com sucesso absoluto:
1. `pytest scripts/organizador/tests/`: **22 passed in 0.08s** (100% de conformidade com motor de organização).
2. `pytest templates-lab/scripts/test_verify_docs_suite.py`: **5 passed in 0.02s** (100% de conformidade de auto-teste).
3. `python3 templates-lab/scripts/verify_docs_suite.py`: **74/74 checks passed across 4 tiers** (100% de integridade pedagógica e rastreabilidade).
4. `pytest templates-lab/scripts/test_m1_empirical_adversarial.py`: **8 passed in 4.33s** (100% dos testes Playwright de renderização de interface).
5. Links simbólicos órfãos (`find /home/lan/dotfiles -xtype l`): **0 symlinks quebrados**.
6. Tarball de backup (`tar -tzf backups/hypr_backup_20261030_100513.tar.gz | wc -l`): **155 itens íntegros**.

---

## 2. Logic Chain (Cadeia de Raciocínio & Deduções)

1. **Origem do Estado `RM`**:
   - `worker_m1` executou `git mv` para mover `gta-modman.py`, `test_m1_empirical_adversarial.py` e `verify_docs_suite.py`. O `git mv` adiciona automaticamente a operação de renomeação ao índice (`R100`).
   - Posteriormente, o worker aplicou edições de código via `replace_file_content` para corrigir caminhos internos nos novos locais dos scripts, mas **não executou `git add`** após a edição.
   - Isso gerou a divergência em que o Git registrou a renomeação no stage, mas as alterações de código essenciais permaneceram soltas na árvore de trabalho (`Changes not staged for commit` / `RM`). Se um commit for executado sobre o stage atual, as alterações de caminho são descartadas e o repositório regride para scripts quebrados.

2. **Causa da Quebra dos 10 Scripts de GTA**:
   - Os arquivos de dados `gta_catalog_full.json`, `gta_curated_core.json` e o diretório `lotes_download` foram transferidos de `scripts/` para `games/gta-sa/scripts/`.
   - Os 10 scripts continuaram consumindo literais `/home/lan/dotfiles/scripts/gta_...`.
   - Adicionalmente, `generate_missing_checklist.py` e `generate_missing_list.py` gravavam seus arquivos de saída na raiz `/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md` e `/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md`, re-poluindo a raiz limpa do repositório a cada execução.

3. **Inconsistência Documental**:
   - `templates-lab/docs/` manteve 24 comandos referenciando os caminhos antigos `scripts/verify_docs_suite.py` e `scripts/test_verify_docs_suite.py`. Desenvolvedores executando os comandos documentados na raiz sofrem erro imediato `[Errno 2] No such file or directory`.

4. **Princípio de Staging Atômico e Não-Poluente**:
   - Para que o commit semântico do Milestone 1 seja cirúrgico, robusto e livre de inconsistências:
     - Devemos garantir que **todas as alterações de código de produção estejam estagiadas (`git add`)**.
     - O script `scripts/abrir-links-pendentes.sh` deve ser movido para `games/gta-sa/scripts/` via `git mv`.
     - Nenhum arquivo de produção deve figurar com status `RM` ou ` M`.
     - Não devemos misturar artefatos de agentes não relacionados em `.agents/teamwork/`.

---

## 3. Caveats (Ressalvas & Limitações)

1. **Metadados Rastreáveis de `.agents/teamwork/`**:
   - Os arquivos `.agents/teamwork/BRIEFING.md`, `.agents/teamwork/ORIGINAL_REQUEST.md` e `.agents/teamwork/interviewer/prompt_draft.md` foram versionados no passado.
   - Se o comando genérico `git add -u` for executado, esses 3 arquivos de metadados entrarão no stage.
   - **Recomendação**: Usar comando de staging direcionado aos módulos de produção (`git add games/ templates-lab/ docs/ scripts/ .gitignore`) para manter o escopo do commit puramente focado nos entregáveis de Milestone 1. Caso a política da equipe exija atualizar o status do orquestrador no git, executar `git add .agents/teamwork/BRIEFING.md .agents/teamwork/ORIGINAL_REQUEST.md`.
2. **Scripts que Mutam Arquivos de Dados**:
   - Scripts como `filtrar-curadoria-elite.py`, `limpar-bizarrices.py` e `limpar-dev-tools.py` reescrevem `games/gta-sa/scripts/gta_catalog_full.json`.
   - `generate_missing_checklist.py` e `generate_missing_list.py` regravam `games/gta-sa/CHECKLIST_MODS_FALTANTES.md` e `games/gta-sa/MODS_FALTANTES_PARA_BAIXAR.md`.
   - A suíte de testes de verificação foi desenhada para levar isso em conta, e os arquivos gerados/atualizados devem ser incluídos no `git add games/gta-sa/`.
3. **Ambientes sem Jogo Instalado**:
   - Como os caminhos de `/mnt/dados/Games/GTA_San_Andreas` dependem de montagem em disco, a verificação de código deve validar que a ausência do jogo não levanta `FileNotFoundError`, reportando 0 itens de forma graciosa.

---

## 4. Conclusion (Diretrizes Operacionais & Sequência de Staging)

O Worker deve executar exatamente as ações abaixo, na ordem descrita:

### 4.1 Ações de Remediação de Código e Documentação
1. **Mover script esquecido**:
   ```bash
   git mv scripts/abrir-links-pendentes.sh games/gta-sa/scripts/abrir-links-pendentes.sh
   ```
2. **Aplicar correções de caminhos nos 10 scripts de GTA**:
   - Copiar/aplicar os arquivos propostos por `explorer_m1_fix_1` localizados em:
     `/home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_1/proposed/`
     (ou substituir as linhas literais `/home/lan/dotfiles/scripts/` por `Path(__file__).resolve().parent` e saídas markdowns para `Path(__file__).resolve().parent.parent`).
3. **Aplicar correções de documentação em `templates-lab/docs/`**:
   - Aplicar o patch gerado por `explorer_m1_fix_2`:
     ```bash
     git apply /home/lan/dotfiles/.agents/teamwork/explorer_m1_fix_2/doc_references_remediation.patch
     ```

### 4.2 Comandos Exatos de Git Staging para o Worker

Após aplicar as correções e rodar o harness de testes, o Worker deve executar a seguinte sequência de staging:

```bash
cd /home/lan/dotfiles

# 1. Estagiar todas as alterações dos módulos afetados por M1
git add games/gta-sa/
git add templates-lab/
git add docs/
git add scripts/
git add .gitignore

# 2. Auditar que a área de staging está 100% limpa (0 RM, 0 M em produção):
git status --short | grep -E "^RM|^ M" | grep -v "\.agents/teamwork"
# Condição de saída: DEVE SER VAZIA (exit code 1 do grep)
```

---

## 5. Verification Method (Harness Completo de Verificação Zero-Regressão)

Para auditar e aprovar formalmente o Milestone 1 após a atuação do Worker, execute o script de verificação integral abaixo:

```bash
#!/usr/bin/env bash
set -e
cd /home/lan/dotfiles

echo "================================================================="
echo "🔬 HARNESS INTEGRAL DE VERIFICAÇÃO M1 (ZERO REGRESSIONS)"
echo "================================================================="

echo "--- [1/6] Testando Execução dos 10 Scripts GTA San Andreas ---"
python3 games/gta-sa/scripts/check_final_gta.py
python3 games/gta-sa/scripts/filtrar-curadoria-elite.py
python3 games/gta-sa/scripts/generate_missing_checklist.py
python3 games/gta-sa/scripts/generate_missing_list.py
python3 games/gta-sa/scripts/gerar-lotes-270-fiel.py
python3 games/gta-sa/scripts/gerar-lotes-curadoria-pura.py
python3 games/gta-sa/scripts/gerar-lotes-download.py
python3 games/gta-sa/scripts/gerar-lotes-filtrados.py
python3 games/gta-sa/scripts/limpar-bizarrices.py
python3 games/gta-sa/scripts/limpar-dev-tools.py
echo "✔ Todos os 10 scripts GTA executaram com exit code 0 sem FileNotFoundError!"

echo "--- [2/6] Verificando Realocação de abrir-links-pendentes.sh ---"
test ! -f scripts/abrir-links-pendentes.sh
test -f games/gta-sa/scripts/abrir-links-pendentes.sh
bash -n games/gta-sa/scripts/abrir-links-pendentes.sh
echo "✔ abrir-links-pendentes.sh alocado e sintaticamente válido!"

echo "--- [3/6] Verificando Ausência de Poluição na Raiz ---"
test ! -f CHECKLIST_MODS_FALTANTES.md
test ! -f MODS_FALTANTES_PARA_BAIXAR.md
test ! -f TEST_INFRA.md
test ! -f TEST_READY.md
test ! -f MODPACK_DEFINITIVO_GTA_SA.md
test ! -f MixSets_Otimizado.ini
test ! -f nexusmodconta.env
test ! -f playlist_maratona_java.md
echo "✔ Zero arquivos soltos ou poluídos na raiz do repositório!"

echo "--- [4/6] Verificando Referências em templates-lab/docs/ ---"
! grep -rn "scripts/verify_docs_suite.py" templates-lab/docs/
! grep -rn "scripts/test_verify_docs_suite.py" templates-lab/docs/
echo "✔ 0 referências obsoletas na documentação!"

echo "--- [5/6] Executando Suítes Automatizadas de Teste ---"
pytest scripts/organizador/tests/
pytest templates-lab/scripts/test_verify_docs_suite.py
python3 templates-lab/scripts/verify_docs_suite.py
pytest templates-lab/scripts/test_m1_empirical_adversarial.py
echo "✔ 100% das suítes de testes passaram!"

echo "--- [6/6] Verificando Higiene do Git Staging Area ---"
# Não deve haver nenhum status RM ou modificação unstaged em arquivos de produção
UNSTAGED_PROD=$(git status --short | grep -E "^RM|^ M" | grep -v "\.agents/teamwork" || true)
if [ -n "$UNSTAGED_PROD" ]; then
    echo "❌ ERRO: Existem modificações de produção não estagiadas:"
    echo "$UNSTAGED_PROD"
    exit 1
fi

UNTRACKED_PROD=$(git status --short | grep "^\?\?" | grep -v "\.agents/teamwork" || true)
if [ -n "$UNTRACKED_PROD" ]; then
    echo "❌ ERRO: Existem arquivos untracked fora de .agents/teamwork:"
    echo "$UNTRACKED_PROD"
    exit 1
fi
echo "✔ Staging area do Git rigorosamente alinhada e pronta para commit!"

echo "================================================================="
echo "🎉 MILESTONE 1 VERIFICADO COM SUCESSO ABSOLUTO!"
echo "================================================================="
```

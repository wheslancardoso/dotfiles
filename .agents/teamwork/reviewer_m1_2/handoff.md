# Relatório de Revisão Adversarial (Handoff) — Milestone 1: Organização e Limpeza Geral

**Agente**: `teamwork_reviewer` (`reviewer_m1_2`)  
**Data/Timestamp**: 2026-11-07T16:35:30Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Escopo**: Revisão e Verificação Adversarial Independente do Milestone 1  
**Veredito Final**: `REQUEST_CHANGES`

---

## 1. Review Summary & Veredito

**Veredito Oficial**: `REQUEST_CHANGES`  
**Avaliação Geral de Risco**: `CRITICAL`

A execução do Milestone 1 pelo Worker (`worker_m1`) moveu com sucesso a maioria dos arquivos da raiz e preservou a integridade byte a byte dos arquivos movidos, além de manter os testes do `organizador` e de `templates-lab` funcionais.

Entretanto, uma análise adversarial aprofundada revelou **múltiplas falhas críticas de quebra de referências em scripts movidos**, **scripts funcionais que quebram imediatamente com `FileNotFoundError` ao serem executados**, **scripts de GTA esquecidos em `scripts/`**, e **modificações em árvore de trabalho não adicionadas ao índice git (unstaged modifications em arquivos renomeados)**.

---

## 2. Findings (Achados Adversariais e Defeitos Confirmados)

### 🔴 [Critical] Finding 1: 10 scripts em `games/gta-sa/scripts/` quebram com `FileNotFoundError`
- **O que**: Ao mover os scripts de GTA de `scripts/` para `games/gta-sa/scripts/`, apenas o script `gta-modman.py` teve seus caminhos ajustados. Os outros scripts mantiveram caminhos absolutos legados apontando para `/home/lan/dotfiles/scripts/gta_catalog_full.json`, `/home/lan/dotfiles/scripts/gta_curated_core.json` e `/home/lan/dotfiles/scripts/lotes_download`.
- **Onde**:
  1. `games/gta-sa/scripts/check_final_gta.py:3`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
     ```
     *Comportamento real*: Executar `python3 games/gta-sa/scripts/check_final_gta.py` falha com `FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'`.
  2. `games/gta-sa/scripts/generate_missing_checklist.py:3, 23`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
     out_md = "/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md"
     ```
     *Comportamento real*: Falha com `FileNotFoundError`. Se o JSON fosse resolvido, gravaria o output de volta na raiz do repositório (`/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md`) em vez de `games/gta-sa/`.
  3. `games/gta-sa/scripts/generate_missing_list.py:3, 28`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
     output_file = "/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md"
     ```
     *Comportamento real*: Falha com `FileNotFoundError`. Se o JSON fosse resolvido, poluiria a raiz gravando em `/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md`.
  4. `games/gta-sa/scripts/gerar-lotes-curadoria-pura.py:5, 51`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_curated_core.json', 'r', encoding='utf-8') as f:
     scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
     ```
     *Comportamento real*: Falha com `FileNotFoundError`.
  5. `games/gta-sa/scripts/gerar-lotes-270-fiel.py:5, 49`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
     scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
     ```
     *Comportamento real*: Falha com `FileNotFoundError`.
  6. `games/gta-sa/scripts/limpar-bizarrices.py:13, 89`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
     ```
     *Comportamento real*: Falha com `FileNotFoundError`.
  7. `games/gta-sa/scripts/filtrar-curadoria-elite.py:13, 66`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
     ```
     *Comportamento real*: Falha com `FileNotFoundError`.
  8. `games/gta-sa/scripts/limpar-dev-tools.py:4, 34`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'w', encoding='utf-8') as out:
     ```
     *Comportamento real*: Falha com `FileNotFoundError`.
  9. `games/gta-sa/scripts/gerar-lotes-download.py:5, 26`:
     ```python
     with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
     scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
     ```
     *Comportamento real*: Falha com `FileNotFoundError`.
  10. `games/gta-sa/scripts/gerar-lotes-filtrados.py:6, 52`:
      ```python
      with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
      scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"
      ```
      *Comportamento real*: Falha com `FileNotFoundError`.
- **Por que é problema**: Viola diretamente o objetivo do Milestone 1 de "Isolamento do Ecossistema GTA San Andreas" e quebra ferramentas de trabalho ativas do repositório.
- **Sugestão de Correção**: Substituir caminhos absolutos fixos por caminhos dinâmicos relativos a `Path(__file__).resolve().parent` ou `Path(__file__).resolve().parent.parent`.

---

### 🟠 [Major] Finding 2: Modificações de código em arquivos renomeados estão "unstaged" no git (`RM`)
- **O que**: O worker moveu arquivos usando `git mv` (o que colocou os renames no stage do Git), mas após aplicar as alterações de código (`replace_file_content`), não executou `git add` nos arquivos modificados.
- **Onde**:
  - `games/gta-sa/scripts/gta-modman.py` (`RM`)
  - `templates-lab/scripts/test_m1_empirical_adversarial.py` (`RM`)
  - `templates-lab/scripts/verify_docs_suite.py` (`RM`)
- **Por que é problema**: Se um commit de stage for realizado (`git commit -m ...`), o git incluirá apenas o rename sem as alterações de código, revertendo os scripts ao estado quebrado de caminhos pré-existentes.
- **Sugestão de Correção**: Executar `git add games/gta-sa/scripts/gta-modman.py templates-lab/scripts/test_m1_empirical_adversarial.py templates-lab/scripts/verify_docs_suite.py`.

---

### 🟠 [Major] Finding 3: Script de download de mods de GTA esquecido em `scripts/abrir-links-pendentes.sh`
- **O que**: O arquivo `scripts/abrir-links-pendentes.sh` é um script específico de GTA San Andreas que envia 13 URLs de download de mods para o navegador Brave (ex: `Advanced_Aiming_Mod.7z`, `First_Person_Mod_fixed.7z`, `Manual_Driveby_Remake.7z`, `Proper_Player_Retex.7z`, etc.).
- **Onde**: `scripts/abrir-links-pendentes.sh`
- **Por que é problema**: Contradiz a arquitetura de limpeza de `scripts/` e isolamento dos utilitários de GTA em `games/gta-sa/scripts/`.
- **Sugestão de Correção**: Mover `scripts/abrir-links-pendentes.sh` para `games/gta-sa/scripts/abrir-links-pendentes.sh` via `git mv`.

---

### 🟡 [Minor] Finding 4: Comandos de execução desatualizados na documentação de `templates-lab/docs/`
- **O que**: Os arquivos `templates-lab/docs/TEST_READY.md`, `TEST_INFRA.md` e `README.md` contêm instruções de execução como `python3 scripts/verify_docs_suite.py` e `pytest scripts/test_verify_docs_suite.py`.
- **Onde**:
  - `templates-lab/docs/README.md:7, 145, 148, 151`
  - `templates-lab/docs/TEST_READY.md:6, 7, 51, 67, 71, 74, 77`
  - `templates-lab/docs/TEST_INFRA.md:9, 72, 78, 81, 84, 87, 93, 96, 99, 105, 108`
- **Por que é problema**: Um desenvolvedor que tentar rodar os comandos a partir da raiz terá erro `[Errno 2] No such file or directory`.
- **Sugestão de Correção**: Atualizar os comandos na documentação para refletir o novo caminho `templates-lab/scripts/verify_docs_suite.py` ou executar a partir de `templates-lab/`.

---

## 3. Observation (Evidências Diretas Coletadas)

1. **Tentativa de execução de scripts de GTA após movimentação**:
   ```bash
   $ python3 games/gta-sa/scripts/check_final_gta.py
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/check_final_gta.py", line 3, in <module>
       with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
   ```
   ```bash
   $ python3 games/gta-sa/scripts/generate_missing_checklist.py
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/generate_missing_checklist.py", line 3, in <module>
       with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
   ```
   ```bash
   $ python3 games/gta-sa/scripts/gerar-lotes-curadoria-pura.py
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-curadoria-pura.py", line 5, in <module>
       with open('/home/lan/dotfiles/scripts/gta_curated_core.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
   ```

2. **Status Git com modificações unstaged**:
   ```bash
   $ git status -s
   ...
   RM scripts/gta-modman.py -> games/gta-sa/scripts/gta-modman.py
   RM scripts/test_m1_empirical_adversarial.py -> templates-lab/scripts/test_m1_empirical_adversarial.py
   RM scripts/verify_docs_suite.py -> templates-lab/scripts/verify_docs_suite.py
   ```

3. **Verificação de `scripts/abrir-links-pendentes.sh`**:
   Contém links para mods do GTA: `Advanced_Aiming_Mod.7z`, `First_Person_Mod_fixed.7z`, `VehDeform.zip`, `Proper_Player_Retex.7z`, `PedFuncs.7z`.

4. **Verificação da Integridade Byte a Byte dos Arquivos da Raiz**:
   - `diff -u <(git cat-file -p HEAD:TEST_INFRA.md) templates-lab/docs/TEST_INFRA.md` -> Saída nula (100% idêntico).
   - `diff -u <(git cat-file -p HEAD:TEST_READY.md) templates-lab/docs/TEST_READY.md` -> Saída nula (100% idêntico).
   - `diff -u <(git cat-file -p HEAD:CHECKLIST_MODS_FALTANTES.md) games/gta-sa/CHECKLIST_MODS_FALTANTES.md` -> Saída nula.
   - `diff -u <(git cat-file -p HEAD:MODPACK_DEFINITIVO_GTA_SA.md) games/gta-sa/MODPACK_DEFINITIVO_GTA_SA.md` -> Saída nula.
   - `diff -u <(git cat-file -p HEAD:MODS_FALTANTES_PARA_BAIXAR.md) games/gta-sa/MODS_FALTANTES_PARA_BAIXAR.md` -> Saída nula.
   - `diff -u <(git cat-file -p HEAD:MixSets_Otimizado.ini) games/gta-sa/MixSets_Otimizado.ini` -> Saída nula.
   - `diff -u <(git cat-file -p HEAD:playlist_maratona_java.md) docs/playlist_maratona_java.md` -> Saída nula.

5. **Verificação de `backups/hypr_backup_20261030_100513.tar.gz`**:
   - `tar -tzf backups/hypr_backup_20261030_100513.tar.gz > /dev/null` retornou código de saída 0.
   - O arquivo compactado contém todos os 155 itens da pasta excluída.

6. **Verificação de Testes Existentes**:
   - `pytest templates-lab/scripts/test_verify_docs_suite.py`: 5 passed.
   - `python3 templates-lab/scripts/verify_docs_suite.py`: 74/74 passed.
   - `pytest templates-lab/scripts/test_m1_empirical_adversarial.py`: 8 passed.
   - `pytest scripts/organizador/tests/`: 22 passed.

---

## 4. Logic Chain

1. **Hipótese**: O isolamento de arquivos em `games/gta-sa/scripts/` foi completado e os scripts mantêm funcionalidade plena.
2. **Teste Empírico**: Execução direta de `python3 games/gta-sa/scripts/check_final_gta.py`, `generate_missing_checklist.py` e `gerar-lotes-curadoria-pura.py`.
3. **Resultado**: Todos falharam com `FileNotFoundError` ao tentar abrir `/home/lan/dotfiles/scripts/gta_curated_core.json`.
4. **Inspeção de Código**: Constatou-se que 10 scripts possuem caminhos hardcoded para o diretório antigo (`scripts/`).
5. **Conclusão**: O isolamento não foi devidamente concluído, quebrando utilitários essenciais do ecossistema GTA.

---

## 5. Caveats

- Os testes de Playwright e verificador de documentação em `templates-lab/scripts/` funcionam com sucesso quando invocados por seus novos caminhos, comprovando que a alteração conceitual é válida.
- A exclusão de arquivos da raiz não causou perda de dados, pois todos os conteúdos foram auditados e preservados em seus destinos.

---

## 6. Conclusion & Ações Requeridas

O Milestone 1 **NÃO PODE SER APROVADO** no estado atual devido a quebras de execução direta em scripts movidos e inconsistências no stage do git.

### Ações Mandatórias para o Worker:
1. **Corrigir os 10 scripts em `games/gta-sa/scripts/`**:
   - `check_final_gta.py`
   - `generate_missing_checklist.py` (corrigir caminho de entrada do JSON e caminho de saída para `games/gta-sa/CHECKLIST_MODS_FALTANTES.md`)
   - `generate_missing_list.py` (corrigir caminho de entrada do JSON e caminho de saída para `games/gta-sa/MODS_FALTANTES_PARA_BAIXAR.md`)
   - `gerar-lotes-curadoria-pura.py` (corrigir JSON e pasta `lotes_download`)
   - `gerar-lotes-270-fiel.py` (corrigir JSON e pasta `lotes_download`)
   - `limpar-bizarrices.py`
   - `filtrar-curadoria-elite.py`
   - `limpar-dev-tools.py`
   - `gerar-lotes-download.py` (corrigir JSON e pasta `lotes_download`)
   - `gerar-lotes-filtrados.py` (corrigir JSON e pasta `lotes_download`)
2. **Mover `scripts/abrir-links-pendentes.sh`** para `games/gta-sa/scripts/abrir-links-pendentes.sh`.
3. **Atualizar a documentação de `templates-lab/docs/`** (`TEST_READY.md`, `TEST_INFRA.md`, `README.md`) para referenciar os novos caminhos em `templates-lab/scripts/`.
4. **Executar `git add -u`** para garantir que todas as modificações nos arquivos renomeados estejam devidamente no stage.

---

## 7. Verification Method

Para verificar a resolução completa:
```bash
cd /home/lan/dotfiles

# 1. Executar os scripts corrigidos para validar ausência de FileNotFoundError
python3 games/gta-sa/scripts/check_final_gta.py
python3 games/gta-sa/scripts/generate_missing_checklist.py
python3 games/gta-sa/scripts/generate_missing_list.py
python3 games/gta-sa/scripts/gerar-lotes-curadoria-pura.py

# 2. Validar que abrir-links-pendentes.sh foi movido
test ! -f scripts/abrir-links-pendentes.sh && test -f games/gta-sa/scripts/abrir-links-pendentes.sh

# 3. Validar ausência de status RM ou unstaged modifications nos scripts
git status -s | grep -E "^RM|^ M"
# Esperado: Nenhum retorno para scripts de produção

# 4. Validar suíte de testes
pytest templates-lab/scripts/test_verify_docs_suite.py
python3 templates-lab/scripts/verify_docs_suite.py
pytest templates-lab/scripts/test_m1_empirical_adversarial.py
pytest scripts/organizador/tests/
```

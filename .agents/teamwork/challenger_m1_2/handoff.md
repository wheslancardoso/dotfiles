# Relatório de Handoff Adversarial — Milestone 1: Organização e Limpeza Geral

**Agente**: `teamwork_challenger` (`challenger_m1_2`)  
**Data/Timestamp**: 2026-11-07T16:36:00Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Escopo**: Stress-Test Adversarial e Validação Empírica do Milestone 1 (R1 - Organização e Limpeza Geral)  
**Veredito**: `REQUEST_CHANGES`

---

## 1. Observation (Evidências Diretas Coletadas)

### 1.1 Falha em 10 Scripts do Ecossistema GTA San Andreas (`games/gta-sa/scripts/`)
Ao executar varredura e testes empíricos nos scripts movidos de `scripts/` para `games/gta-sa/scripts/`, constatou-se que 10 scripts contêm caminhos absolutos legados rígidos apontando para `/home/lan/dotfiles/scripts/gta_catalog_full.json`, `/home/lan/dotfiles/scripts/gta_curated_core.json` e `/home/lan/dotfiles/scripts/lotes_download`.

Comandos executados e saídas literais observadas:

1. `python3 games/gta-sa/scripts/limpar-dev-tools.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/limpar-dev-tools.py", line 4, in <module>
       with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 4 e 34.

2. `python3 games/gta-sa/scripts/limpar-bizarrices.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/limpar-bizarrices.py", line 13, in <module>
       with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 13 e 89.

3. `python3 games/gta-sa/scripts/gerar-lotes-download.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-download.py", line 5, in <module>
       with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 5 (`gta_catalog_full.json`) e 26 (`scripts_dir = "/home/lan/dotfiles/scripts/lotes_download"`).

4. `python3 games/gta-sa/scripts/gerar-lotes-filtrados.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-filtrados.py", line 6, in <module>
       with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 6 e 52.

5. `python3 games/gta-sa/scripts/gerar-lotes-curadoria-pura.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-curadoria-pura.py", line 5, in <module>
       with open('/home/lan/dotfiles/scripts/gta_curated_core.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 5 e 51.

6. `python3 games/gta-sa/scripts/gerar-lotes-270-fiel.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-270-fiel.py", line 5, in <module>
       with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 5 e 49.

7. `python3 games/gta-sa/scripts/generate_missing_list.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/generate_missing_list.py", line 3, in <module>
       with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 3 (`gta_curated_core.json`) e 28 (`output_file = "/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md"` — aponta para a raiz ao invés de `games/gta-sa/`).

8. `python3 games/gta-sa/scripts/generate_missing_checklist.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/generate_missing_checklist.py", line 3, in <module>
       with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 3 (`gta_curated_core.json`) e 23 (`out_md = "/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md"` — aponta para a raiz ao invés de `games/gta-sa/`).

9. `python3 games/gta-sa/scripts/filtrar-curadoria-elite.py`:
   ```text
   Traceback (most recent call last):
     File "/home/lan/dotfiles/games/gta-sa/scripts/filtrar-curadoria-elite.py", line 13, in <module>
       with open('/home/lan/dotfiles/scripts/gta_catalog_full.json', 'r', encoding='utf-8') as f:
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_catalog_full.json'
   Exit code: 1
   ```
   *Linhas afetadas:* 13 e 66.

10. `python3 games/gta-sa/scripts/check_final_gta.py`:
    ```text
    Traceback (most recent call last):
      File "/home/lan/dotfiles/games/gta-sa/scripts/check_final_gta.py", line 3, in <module>
        with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
    Exit code: 1
    ```
    *Linhas afetadas:* 3.

### 1.2 Modificações Não Estagiadas no Git (`git status`)
Execução de `git status --porcelain`:
```text
RM games/gta-sa/scripts/gta-modman.py
RM templates-lab/scripts/test_m1_empirical_adversarial.py
RM scripts/verify_docs_suite.py -> templates-lab/scripts/verify_docs_suite.py
```
O `git mv` (renomeação) foi adicionado à área de staging (`Changes to be committed`), mas as alterações de conteúdo feitas posteriormente nesses três arquivos não foram adicionadas via `git add` (`Changes not staged for commit`). Qualquer commit gerará uma árvore inconsistente ou deixará alterações pendentes na árvore de trabalho.

### 1.3 Referências Quebradas na Documentação do `templates-lab`
Execução de busca por `scripts/verify_docs_suite.py`:
- `templates-lab/docs/TEST_READY.md`: Linhas 6, 7, 51, 67, 68, 71, 74, 77 instruem a execução de `python3 scripts/verify_docs_suite.py` e `pytest scripts/test_verify_docs_suite.py`.
- `templates-lab/docs/TEST_INFRA.md`: Linhas 9, 72, 78, 81, 84, 87, 93, 96, 99, 105, 108 instruem a execução via `scripts/verify_docs_suite.py`.
- `templates-lab/docs/README.md`: Linhas 7, 141, 145, 148, 151 instruem a execução via `scripts/verify_docs_suite.py`.

Execução do comando documentado a partir da raiz do repositório:
```bash
python3 scripts/verify_docs_suite.py
# Saída observada:
# python3: can't open file '/home/lan/dotfiles/scripts/verify_docs_suite.py': [Errno 2] No such file or directory
# Exit code: 2
```

### 1.4 Verificações com Sucesso (Itens Válidos)
1. **Redundâncias na raiz**:
   - `git diff HEAD:TEST_INFRA.md templates-lab/docs/TEST_INFRA.md` -> diff vazio (100% idêntico, conservação perfeita).
   - `git diff HEAD:TEST_READY.md templates-lab/docs/TEST_READY.md` -> diff vazio (100% idêntico).
2. **Backups e tar.gz**:
   - `tar -ztvf backups/hypr_backup_20261030_100513.tar.gz | wc -l` -> 155 arquivos preservados.
   - `tar -tzf backups/hypr_backup_20261030_100513.tar.gz > /dev/null` -> exit code 0 (tarball íntegro e legível).
3. **Credenciais no `.gitignore`**:
   - `git check-ignore games/gta-sa/nexusmodconta.env` -> `games/gta-sa/nexusmodconta.env` (ignorado com sucesso).
4. **Symlinks**:
   - `find /home/lan/dotfiles -xtype l` -> 0 symlinks quebrados.
5. **Testes do Organizador e Templates-Lab**:
   - `pytest scripts/organizador/tests/` -> 22 passed.
   - `pytest templates-lab/scripts/test_verify_docs_suite.py` -> 5 passed.
   - `pytest templates-lab/scripts/test_m1_empirical_adversarial.py` -> 8 passed.

---

## 2. Logic Chain (Cadeia de Raciocínio & Deduções)

1. **Premissa de Isolamento do Módulo GTA San Andreas**:
   - O handoff de `worker_m1` e o plano de arquitetura declararam que o módulo `games/gta-sa/` estava isolado e funcional.
   - Porém, a verificação empírica demonstrou que 10 scripts falham com `FileNotFoundError` porque dependem de arquivos que foram movidos (`gta_catalog_full.json`, `gta_curated_core.json`, `lotes_download`) sem que as referências internas fossem atualizadas para caminhos relativos ao script (`Path(__file__).resolve().parent`).
   - Além disso, dois scripts de geração de listas gravam arquivos de volta na raiz do dotfiles (`/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md` e `/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md`), o que re-poluiria a raiz que acabou de ser limpa.
2. **Higiene e Integridade do Git**:
   - Os arquivos `games/gta-sa/scripts/gta-modman.py`, `templates-lab/scripts/test_m1_empirical_adversarial.py` e `templates-lab/scripts/verify_docs_suite.py` foram movidos com `git mv` (staged), mas as edições subsequentes ficaram unstaged. Se for feito commit apenas do staged, as correções vitais de caminho não entrarão no commit.
3. **Contrato de Documentação e Testabilidade**:
   - `templates-lab/docs/` é a referência oficial para o test harness. Deixar caminhos desatualizados (`scripts/verify_docs_suite.py`) faz com que qualquer usuário ou automação que siga a documentação obtenha erro imediato de execução (`No such file or directory`).
4. **Conclusão Lógica**:
   - O Milestone 1 não pode ser aprovado enquanto 10 scripts estiverem quebrados, o git estiver com alterações críticas pendentes fora da staging area e a documentação contiver instruções de execução inválidas.

---

## 3. Caveats (Ressalvas & Limitações)

- Testes de renderização física 3D do GTA San Andreas via Wine (`testar-loading.py`, `test_wine_gta.sh`) dependem de prefixo de Wine instalado e arquivos proprietários do jogo em `/mnt/dados/Games/GTA_San_Andreas`, não sendo executáveis em ambiente headless de CI sem display físico.
- Nenhuma alteração no código de produção foi feita por este agente Challenger, em estrita conformidade com a restrição `Review-only`.

---

## 4. Conclusion (Conclusão & Ações Necessárias)

**Veredito Oficial**: `REQUEST_CHANGES`

Para que o Milestone 1 atinja o critério de aceitação e estabilidade total, o Worker deve aplicar as seguintes correções:

1. **Atualizar os 10 scripts em `games/gta-sa/scripts/`** para usar resolução dinâmica relativa ao diretório do script (`Path(__file__).resolve().parent` ou caminhos relativos):
   - `limpar-dev-tools.py`
   - `limpar-bizarrices.py`
   - `gerar-lotes-filtrados.py`
   - `gerar-lotes-download.py`
   - `gerar-lotes-curadoria-pura.py`
   - `gerar-lotes-270-fiel.py`
   - `generate_missing_list.py` (corrigir entrada json e saída `MODS_FALTANTES_PARA_BAIXAR.md` para `games/gta-sa/`)
   - `generate_missing_checklist.py` (corrigir entrada json e saída `CHECKLIST_MODS_FALTANTES.md` para `games/gta-sa/`)
   - `filtrar-curadoria-elite.py`
   - `check_final_gta.py`
2. **Atualizar os comandos em `templates-lab/docs/`**:
   - Substituir `scripts/verify_docs_suite.py` por `templates-lab/scripts/verify_docs_suite.py` em `README.md`, `TEST_READY.md` e `TEST_INFRA.md`.
   - Substituir `scripts/test_verify_docs_suite.py` por `templates-lab/scripts/test_verify_docs_suite.py`.
3. **Adicionar todas as modificações à staging area do git**:
   - Executar `git add games/gta-sa/scripts/ templates-lab/scripts/ templates-lab/docs/` para que o status do git fique perfeitamente alinhado e pronto para commit semântico.

---

## 5. Verification Method (Comandos para Validação da Correção)

Após a aplicação das correções pelo Worker, o auditor ou challenger deve executar:

```bash
# 1. Testar execução dos scripts do GTA sem erros de arquivo inexistente:
python3 /home/lan/dotfiles/games/gta-sa/scripts/check_final_gta.py
python3 /home/lan/dotfiles/games/gta-sa/scripts/generate_missing_checklist.py
python3 /home/lan/dotfiles/games/gta-sa/scripts/generate_missing_list.py
python3 /home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-download.py
python3 /home/lan/dotfiles/games/gta-sa/scripts/limpar-dev-tools.py
# Esperado: Exit code 0 em todos

# 2. Testar harness templates-lab e pytest:
pytest /home/lan/dotfiles/templates-lab/scripts/test_verify_docs_suite.py
pytest /home/lan/dotfiles/templates-lab/scripts/test_m1_empirical_adversarial.py
python3 /home/lan/dotfiles/templates-lab/scripts/verify_docs_suite.py
# Esperado: 100% passed

# 3. Validar ausência de caminhos quebrados na documentação:
grep -rn "scripts/verify_docs_suite.py" /home/lan/dotfiles/templates-lab/docs/
# Esperado: Retorno nulo

# 4. Validar estado do Git:
git status -s
# Esperado: 0 arquivos com status 'RM' ou modificações pendentes fora do stage
```

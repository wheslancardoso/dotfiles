# Relatório de Revisão e Auditoria Adversarial — Milestone 1: Organização e Limpeza Geral

**Agente**: `teamwork_reviewer` (`reviewer_m1_1`)  
**Data/Timestamp**: 2026-11-07T16:36:00Z  
**Parent Orchestrator ID**: `f343c4ee-7fc3-477c-9b0f-de332f78b04f`  
**Escopo**: Revisão Objetiva e Desafio Adversarial do Milestone 1 (R1 - Organização e Limpeza Geral) entregue por `worker_m1`  
**Veredito Oficial**: `REQUEST_CHANGES`

---

## 1. Review Summary & Veredito

**Veredito**: `REQUEST_CHANGES`

### Resumo Executivo
Embora o agente `worker_m1` tenha executado com perfeição a limpeza da raiz, o isolamento dos diretórios, a desduplicação do backup e a execução das suítes de testes existentes (testes do `organizador` e de `templates-lab` passaram 100%), a revisão adversarial e a execução direta dos scripts migrados identificaram **duas pendências importantes que impedem a aprovação imediata**:

1. **[MAJOR] Quebra de Execução por Caminhos Hardcoded em 10 Scripts de `games/gta-sa/scripts/`**: A alegação de que *"todo o módulo de GTA San Andreas está agora isolado e funcional em games/gta-sa/"* não se sustenta. O worker apenas adaptou e testou `gta-modman.py --help`, mas 10 scripts Python do ecossistema continuam apontando para caminhos legados como `/home/lan/dotfiles/scripts/gta_catalog_full.json`, resultando em `FileNotFoundError` imediato ao serem executados.
2. **[MAJOR] Modificações Críticas Não Adicionadas ao Índice Git (Unstaged)**: As adaptações dinâmicas feitas em `games/gta-sa/scripts/gta-modman.py`, `templates-lab/scripts/test_m1_empirical_adversarial.py` e `templates-lab/scripts/verify_docs_suite.py` não foram estagiadas (`git add`), figurando como `Changes not staged for commit` (`RM` no índice). Se o commit do Milestone for realizado sobre a staging area atual, tais correções vitais serão perdidas.

---

## 2. Findings (Achados de Revisão)

### [Major] Finding 1: 10 scripts em `games/gta-sa/scripts/` falham com `FileNotFoundError`
- **O que**: 10 scripts utilitários do ecossistema GTA contêm caminhos absolutos legados apontando para `/home/lan/dotfiles/scripts/gta_catalog_full.json`, `/home/lan/dotfiles/scripts/gta_curated_core.json`, `/home/lan/dotfiles/scripts/lotes_download`, `/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md` e `/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md`.
- **Onde**:
  1. `games/gta-sa/scripts/check_final_gta.py`: linha 3 (`/home/lan/dotfiles/scripts/gta_curated_core.json`)
  2. `games/gta-sa/scripts/filtrar-curadoria-elite.py`: linhas 13 e 66 (`/home/lan/dotfiles/scripts/gta_catalog_full.json`)
  3. `games/gta-sa/scripts/generate_missing_checklist.py`: linha 3 (`/home/lan/dotfiles/scripts/gta_curated_core.json`) e linha 23 (`/home/lan/dotfiles/CHECKLIST_MODS_FALTANTES.md`)
  4. `games/gta-sa/scripts/generate_missing_list.py`: linha 3 (`/home/lan/dotfiles/scripts/gta_curated_core.json`) e linha 28 (`/home/lan/dotfiles/MODS_FALTANTES_PARA_BAIXAR.md`)
  5. `games/gta-sa/scripts/gerar-lotes-270-fiel.py`: linha 5 (`/home/lan/dotfiles/scripts/gta_catalog_full.json`) e linha 49 (`/home/lan/dotfiles/scripts/lotes_download`)
  6. `games/gta-sa/scripts/gerar-lotes-curadoria-pura.py`: linha 5 (`/home/lan/dotfiles/scripts/gta_curated_core.json`) e linha 51 (`/home/lan/dotfiles/scripts/lotes_download`)
  7. `games/gta-sa/scripts/gerar-lotes-download.py`: linha 5 (`/home/lan/dotfiles/scripts/gta_catalog_full.json`) e linha 26 (`/home/lan/dotfiles/scripts/lotes_download`)
  8. `games/gta-sa/scripts/gerar-lotes-filtrados.py`: linha 6 (`/home/lan/dotfiles/scripts/gta_catalog_full.json`) e linha 52 (`/home/lan/dotfiles/scripts/lotes_download`)
  9. `games/gta-sa/scripts/limpar-bizarrices.py`: linhas 13 e 89 (`/home/lan/dotfiles/scripts/gta_catalog_full.json`)
  10. `games/gta-sa/scripts/limpar-dev-tools.py`: linhas 4 e 34 (`/home/lan/dotfiles/scripts/gta_catalog_full.json`)
- **Evidência Empírica**:
  Execução de `python3 /home/lan/dotfiles/games/gta-sa/scripts/check_final_gta.py`:
  ```text
  Traceback (most recent call last):
    File "/home/lan/dotfiles/games/gta-sa/scripts/check_final_gta.py", line 3, in <module>
      with open('/home/lan/dotfiles/scripts/gta_curated_core.json') as f:
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'
  ```
- **Por que é um problema**: Quebra a funcionalidade das ferramentas transferidas. O usuário ou automações que dependem desses utilitários não conseguem executá-los.
- **Sugestão de Correção**: Atualizar os scripts para referenciar os arquivos via `Path(__file__).resolve().parent / "gta_catalog_full.json"` ou `os.path.join(os.path.dirname(__file__), "gta_catalog_full.json")`, e os arquivos markdown via `Path(__file__).resolve().parent.parent / "CHECKLIST_MODS_FALTANTES.md"`.

### [Major] Finding 2: Edições de adaptação não estagiadas no Git (`Changes not staged for commit`)
- **O que**: As alterações realizadas nos arquivos movidos não foram adicionadas à staging area do git (`git add`), permanecendo como modificações locais não rastreadas para o commit planejado.
- **Onde**:
  - `games/gta-sa/scripts/gta-modman.py` (`RM` no git status)
  - `templates-lab/scripts/test_m1_empirical_adversarial.py` (`RM` no git status)
  - `templates-lab/scripts/verify_docs_suite.py` (`RM` no git status)
- **Por que é um problema**: Se um commit for executado com `git commit -m ...`, o Git só comitará a renomeação (versão antiga do arquivo na nova localização), descartando as correções de path no histórico do repositório.
- **Sugestão de Correção**: Executar `git add games/gta-sa/scripts/gta-modman.py templates-lab/scripts/test_m1_empirical_adversarial.py templates-lab/scripts/verify_docs_suite.py` (e os demais scripts que forem corrigidos).

### [Minor] Finding 3: Documentação interna de `templates-lab/docs/` com referências ao caminho antigo
- **O que**: Os arquivos `README.md`, `TEST_READY.md` e `TEST_INFRA.md` em `templates-lab/docs/` mencionam instruções com `scripts/verify_docs_suite.py` em vez de `templates-lab/scripts/verify_docs_suite.py`.
- **Onde**: `templates-lab/docs/README.md`, `templates-lab/docs/TEST_READY.md`, `templates-lab/docs/TEST_INFRA.md`.
- **Por que é um problema**: Inconsistência de documentação para desenvolvedores executando os comandos a partir da raiz do repositório.
- **Sugestão de Correção**: Atualizar os comandos sugeridos na documentação para `python3 templates-lab/scripts/verify_docs_suite.py`.

---

## 3. Verified Claims (Verificação Empírica das Alegações do Worker)

| Item Claimed | Método de Verificação | Resultado | Notas |
|---|---|---|---|
| Raiz limpa de `TEST_INFRA.md`, `TEST_READY.md`, GTA files, `MixSets_Otimizado.ini`, `nexusmodconta.env`, `playlist_maratona_java.md` | `ls <arquivos>` | **PASS** | Todos retornam `No such file or directory` na raiz. |
| Cópias de `TEST_INFRA.md` e `TEST_READY.md` conservadas em `templates-lab/docs/` | `ls -lh templates-lab/docs/TEST_*.md` | **PASS** | 6.4K e 4.3K presentes e íntegros. |
| `games/gta-sa/` e `games/gta-sa/scripts/` contêm todos os arquivos | `ls -la games/gta-sa/` e subpastas | **PASS** (Estrutural) | Todos os 5 arquivos de raiz e 21 scripts foram alocados. |
| `nexusmodconta.env` devidamente ignorado | `git check-ignore -v games/gta-sa/nexusmodconta.env` | **PASS** | Ignorado pela regra `.gitignore:23`. Não está no git index. |
| Testes de `templates-lab/scripts/` passam | `pytest templates-lab/scripts/test_verify_docs_suite.py` e `verify_docs_suite.py` | **PASS** | 5/5 pytest passaram; 74/74 checks em 4 tiers passaram; Playwright 8/8 passaram. |
| `docs/playlist_maratona_java.md` existe e íntegro | `ls -lh` e `head -n 20` | **PASS** | 29.737 bytes, 286 vídeos indexados. |
| `backups/` contém apenas o tarball e nenhuma pasta descompactada | `ls -la backups/` e `tar -ztvf` | **PASS** | Apenas `hypr_backup_20261030_100513.tar.gz` (155 itens validados). |
| `pytest scripts/organizador/tests/` passa | `pytest scripts/organizador/tests/` | **PASS** | 22/22 testes passaram em 0.08s. |
| 0 links simbólicos quebrados | `find /home/lan/dotfiles -xtype l` | **PASS** | 0 symlinks órfãos. |

---

## 4. Adversarial Challenge & Stress-Testing

### Challenge Summary
**Overall Risk Assessment**: MEDIUM

### Desafios e Cenários de Ataque

#### [High] Cenário 1: Execução das rotinas de catalogação e download do GTA San Andreas
- **Suposição desafiada**: "Todo o ecossistema GTA SA está funcional no novo diretório `games/gta-sa/`."
- **Cenário de Ataque**: Um desenvolvedor ou usuário tenta gerar a lista de mods faltantes ou filtrar os lotes executando `python3 games/gta-sa/scripts/generate_missing_checklist.py` ou `python3 games/gta-sa/scripts/gerar-lotes-270-fiel.py`.
- **Blast Radius**: Falha imediata em tempo de execução com `FileNotFoundError`, impossibilitando o uso de 10 scripts do repositório.
- **Resultado do Teste de Estresse**: **FAIL** (10 scripts quebrados).
- **Mitigação**: Reescrever os caminhos de importação/arquivos nos 10 scripts para paths relativos dinâmicos (`Path(__file__).resolve().parent`).

#### [Medium] Cenário 2: Commit isolado da área de staging
- **Suposição desafiada**: "O git status está pronto para commit sem perdas."
- **Cenário de Ataque**: Execução de `git commit -m "feat: organize repo"` seguida de `git checkout -- .` ou clonagem limpa.
- **Blast Radius**: As correções manuais em `gta-modman.py`, `test_m1_empirical_adversarial.py` e `verify_docs_suite.py` não estavam no stage. Seriam perdidas, quebrando a suíte de testes de documentação.
- **Resultado do Teste de Estresse**: **FAIL** (modificações cruciais estavam unstaged).
- **Mitigação**: Executar `git add -u` ou `git add` explícito antes do commit.

---

## 5. Handoff Protocol (5 Componentes Obrigatórios)

### 5.1 Observation
- Verificação de arquivos na raiz: `ls TEST_INFRA.md TEST_READY.md MODPACK_DEFINITIVO_GTA_SA.md CHECKLIST_MODS_FALTANTES.md MODS_FALTANTES_PARA_BAIXAR.md MixSets_Otimizado.ini nexusmodconta.env playlist_maratona_java.md` retornou código de saída 2 para todos.
- Verificação de symlinks: `find /home/lan/dotfiles -xtype l` retornou 0 resultados (código 0).
- Verificação de testes: `pytest scripts/organizador/tests/` -> 22 passed. `pytest templates-lab/scripts/test_verify_docs_suite.py` -> 5 passed. `python3 templates-lab/scripts/verify_docs_suite.py` -> 74/74 passed. `pytest templates-lab/scripts/test_m1_empirical_adversarial.py` -> 8 passed.
- Verificação de scripts GTA: `python3 games/gta-sa/scripts/check_final_gta.py` falhou com `FileNotFoundError: [Errno 2] No such file or directory: '/home/lan/dotfiles/scripts/gta_curated_core.json'`.
- Verificação de git: `git status --short` mostrou:
  `RM scripts/gta-modman.py -> games/gta-sa/scripts/gta-modman.py`
  `RM scripts/test_m1_empirical_adversarial.py -> templates-lab/scripts/test_m1_empirical_adversarial.py`
  `RM scripts/verify_docs_suite.py -> templates-lab/scripts/verify_docs_suite.py`

### 5.2 Logic Chain
1. A estrutura física dos arquivos movidos está de acordo com as especificações do `PROJECT.md`.
2. As suítes de testes do organizador e do templates-lab foram executadas e comprovaram que não houve quebra em seus módulos respectivos.
3. No entanto, o `worker_m1` validou apenas `gta-modman.py --help` e assumiu que os outros 20 scripts estavam funcionais.
4. Ao inspecionar os fontes de `games/gta-sa/scripts/`, constatou-se que 10 scripts ainda utilizavam literais `/home/lan/dotfiles/scripts/...`.
5. Como os arquivos JSON e diretórios referenciados foram igualmente movidos para `games/gta-sa/scripts/`, as chamadas falham obrigatoriamente.
6. Adicionalmente, as edições de path realizadas nos scripts adaptados não foram comitadas nem estagiadas.
7. Portanto, o Milestone 1 não pode ser aprovado em seu estado atual sem que estes 10 scripts sejam ajustados e todas as alterações estagiadas.

### 5.3 Caveats
- Os scripts de execução do Wine (`check_wine_run.sh`, `test_wine_gta.sh`, etc.) dependem do executável do jogo montado em `/mnt/dados/Games/GTA_San_Andreas`, que é um path externo ao repositório.

### 5.4 Conclusion
O Milestone 1 atingiu a maior parte dos seus objetivos estruturais de higienização, mas requer alterações pontuais antes da finalização e avanço para os Milestones subsequentes:
- Veredito: **REQUEST_CHANGES**
- O worker deve:
  1. Corrigir os caminhos hardcoded nos 10 scripts de `games/gta-sa/scripts/` para usar caminhos relativos baseados em `__file__`.
  2. Adicionar todas as modificações pendentes ao staging do git (`git add`).

### 5.5 Verification Method
Para o worker validar a correção antes de novo handoff:
```bash
# 1. Executar os scripts GTA corrigidos (devem executar sem FileNotFoundError):
python3 /home/lan/dotfiles/games/gta-sa/scripts/check_final_gta.py
python3 /home/lan/dotfiles/games/gta-sa/scripts/generate_missing_checklist.py
python3 /home/lan/dotfiles/games/gta-sa/scripts/gerar-lotes-270-fiel.py

# 2. Verificar que não restam modificações unstaged em código de produção:
git status --short
# Não deve exibir "RM" ou arquivos modified soltos fora de .agents/teamwork

# 3. Rodar suítes de testes:
pytest /home/lan/dotfiles/templates-lab/scripts/test_verify_docs_suite.py
pytest /home/lan/dotfiles/scripts/organizador/tests/
```

# BRIEFING — 2026-11-07T17:26:30Z

## Mission
Implementar o aprimoramento completo da ferramenta scripts/organizador (Milestone 3, Features F7 a F14), garantindo integridade de dados, eliminação de falsos positivos, suporte a pastas e metadados, proteção contra 0-byte, expansão da suíte de testes com 100% de aprovação e commit semântico.

## 🔒 My Identity
- Archetype: teamwork_worker
- Roles: implementer, qa, specialist
- Working directory: /home/lan/dotfiles/.agents/teamwork/worker_m3/
- Original parent: f343c4ee-7fc3-477c-9b0f-de332f78b04f
- Milestone: Milestone 3 (Aprimoramento da Ferramenta de Organização)

## 🔒 Key Constraints
- Modificar exclusivamente os arquivos sob scripts/organizador/ (core.py, renamer.py, utils.py, config/regras.json, tests/test_organizer.py, scripts shell).
- Proibido cheat, dummy implementations ou hardcoding de testes.
- Manter 100% dos testes existentes passando (22 testes originais) e adicionar novos testes cobrindo todas as novas funcionalidades (F7 a F14).
- Executar commit semântico cirúrgico no git: git add scripts/organizador/ && git commit -m "feat(organizador): aprimoramento de regras, higienizacao, pastas e testes (M3)".

## Current Parent
- Conversation ID: f343c4ee-7fc3-477c-9b0f-de332f78b04f
- Updated: 2026-11-07T17:14:19Z

## Task Summary
- **What to build**: F7 (word boundary para termos <= 4 chars), F8 (correção regex cópia preservando fotocopiadora.pdf), F9 (slugify_filename com NFKD, minúsculas e safe chars), F10 (sanitização de pastas e limpeza de desktop.ini/.DS_Store), F11 (proteção contra arquivos 0-byte), F12 (PROJECT_ROOT="$SCRIPT_DIR" nos scripts shell), F13 (regras canônicas DAO e AGR), F14 (testes pytest expandidos).
- **Success criteria**: pytest scripts/organizador/tests/ passa 100% (29/29), git commit realizado, handoff completo.
- **Interface contracts**: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
- **Code layout**: scripts/organizador/

## Key Decisions Made
- Word Boundary Matching implementado via união de regex `\b` e delimitadores de arquivos `(?<![a-z0-9])` / `(?![a-z0-9])` para permitir delimitadores de arquivo (`_`, `-`, `.`) sem capturar substrings ("dio" não casa com "audio", mas casa com "dio_bootcamp").
- AutoNamer atualizado com regex de cópia que preserva fotocopiadora.pdf e remove prefixo "Cópia de ". Adicionado sanitize_directory_name.
- `slugify_filename` integrado em `src/utils.py` com remoção de acentos NFKD, extensão minúscula e caracteres seguros.
- `clean_empty_directories` estendido para purgar metadados residuais (`desktop.ini`, `.DS_Store`, `Thumbs.db`, `:Zone.Identifier`, `.directory`) antes de apagar pastas.
- Proteção 0-byte implementada em `is_zero_byte`, `move_item` e `organize_directory` impedindo que arquivos vazios sobreponham ou forcem renomeação de arquivos íntegros.
- Todos os 4 scripts shell corrigidos para `PROJECT_ROOT="$SCRIPT_DIR"`.
- Adicionadas regras canônicas em `regras.json` para AGR dev (`mini-fiscalizacao`, `agr-vanilla-dojo`) e DAO (`dao-\d+`, `trilha-04-dao`).

## Artifact Index
- /home/lan/dotfiles/.agents/teamwork/worker_m3/DISPATCH.md — Diretrizes e despacho do orquestrador
- /home/lan/dotfiles/.agents/teamwork/worker_m3/progress.md — Heartbeat de execução
- /home/lan/dotfiles/.agents/teamwork/worker_m3/handoff.md — Relatório final 5-componentes

## Change Tracker
- **Files modified**:
  - `scripts/organizador/src/utils.py`: Adicionada `slugify_filename`.
  - `scripts/organizador/src/renamer.py`: Regex de cópia corrigida, prefixo "Cópia de " suportado, `sanitize_directory_name`.
  - `scripts/organizador/src/core.py`: Word boundary matching (F7), purga de metadados em `clean_empty_directories` (F10), proteção 0-byte (F11).
  - `scripts/organizador/auto_nomear.sh`: `PROJECT_ROOT="$SCRIPT_DIR"`.
  - `scripts/organizador/desfazer.sh`: `PROJECT_ROOT="$SCRIPT_DIR"`.
  - `scripts/organizador/simular.sh`: `PROJECT_ROOT="$SCRIPT_DIR"`.
  - `scripts/organizador/calculadora_particoes.sh`: `PROJECT_ROOT="$SCRIPT_DIR"`.
  - `scripts/organizador/config/regras.json`: Regras para DAO e projetos AGR.
  - `scripts/organizador/tests/test_organizer.py`: Suíte expandida de 22 para 29 testes.
- **Build status**: Pass (29/29 tests passed in 0.09s).
- **Pending issues**: None.

## Quality Status
- **Build/test result**: 29 passed, 0 failed, 0 warnings.
- **Lint status**: 0 violations.
- **Tests added/modified**: 7 novos métodos de teste cobrindo F7 a F14.

## Loaded Skills
- N/A

# Project: dotfiles-clean-and-organize

## Architecture
- **Repositório Dotfiles (`/home/lan/dotfiles`)**: Base operacional do sistema e ambiente de desenvolvimento. A raiz e a pasta `scripts/` devem conter estritamente arquivos de configuração de ambiente e utilitários de sistema.
- **Ecossistema GTA San Andreas**: Módulos de modding, checklists, documentação e 21 scripts dedicados isolados em `games/gta-sa/`.
- **Ferramenta de Organização (`scripts/organizador`)**: Motor Python modular para classificação, higienização de nomes, desduplicação e arquivamento em taxonomia padrão.
- **Aulas de DAO (`mini-fiscalizacao`)**: 11 videoaulas canônicas da Trilha 4 (DAO) do projeto `mini-fiscalizacao`, alocadas em `mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/`.
- **Google Drive Sync (`scripts/gdrive-sync.sh`)**: Script canônico de sincronização bidirecional/espelhamento de `/mnt/dados/01..04` com `gdrive:Taxonomia_Backup/` via Rclone.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| F1 | Limpeza de redundâncias na raiz | Excluir cópias duplicadas de TEST_INFRA.md e TEST_READY.md (mantidas em templates-lab/docs/) | M1 | survey |
| F2 | Isolamento do GTA San Andreas | Mover arquivos de documentação, ini, env e 21 scripts de scripts/ para games/gta-sa/ | M1 | survey |
| F3 | Reorganização de scripts e docs soltos | Mover testes do templates-lab para templates-lab/scripts/ e playlist_maratona_java.md para docs/ | M1 | survey |
| F4 | Desduplicação de backups e caches | Remover pasta descompactada de backup do Hyprland mantendo o tar.gz, e limpar caches temporários | M1 | survey |
| F5 | Purga do arquivo 0-byte de DAO | Excluir o arquivo corrupto de 0 bytes /mnt/dados/00_Inbox_Triagem/dao-09.mp4 | M2 | survey |
| F6 | Renomeação e alocação canônica das aulas de DAO | Renomear dao-01 a dao-11 (incluindo dao-09 (1)) para títulos monográficos oficiais e mover para docs/aulas/videos/trilha-04-dao/ | M2 | survey |
| F7 | Correção do falso positivo por "dio" | Implementar limites de palavra (\b) ou tokenização em regras de classificação para isolar termos curtos | M3 | survey |
| F8 | Correção de regex de cópia no AutoNamer | Corrigir DOWNLOAD_ARTIFACTS_REGEX (\b em copia/copy e prefixo "Cópia de ") evitando corruptelas de nomes | M3 | survey |
| F9 | Slugificação e higienização robusta | Adicionar sanitização NFKD (sem acentos), case minúsculo em extensões e filtragem de caracteres proibidos em nuvem | M3 | survey |
| F10 | Tratamento aprimorado de pastas e subdiretórios | Suporte a sanitização de pastas no AutoNamer, limpeza de pastas com metadados residuais (desktop.ini/.DS_Store) e herança de contexto | M3 | survey |
| F11 | Proteção contra arquivos 0-byte no organizador | Detecção e purga/quarentena de arquivos vazios no fluxo de desduplicação e organização | M3 | survey |
| F12 | Correção dos scripts shell de conveniência | Corrigir PROJECT_ROOT="$SCRIPT_DIR" em auto_nomear.sh, desfazer.sh, simular.sh, calculadora_particoes.sh | M3 | survey |
| F13 | Regras canônicas para DAO e AGR em regras.json | Adicionar regras de classificação para arquivos dao-*.mp4 e projetos AGR | M3 | survey |
| F14 | Expansão da suíte de testes com pytest | Criar novos testes unitários em test_organizer.py cobrindo todas as melhorias e garantir 100% de aprovação | M3 | survey |
| F15 | Simulação do espelhamento Google Drive | Executar scripts/gdrive-sync.sh --dry-run e validar ausência de erros | M4 | survey |
| F16 | Execução do espelhamento Google Drive | Executar scripts/gdrive-sync.sh --sync e espelhar pilares atualizados | M4 | survey |
| F17 | Auditoria de consistência pós-sync | Executar scripts/gdrive-sync.sh --status e auditar integridade no mount /home/lan/gdrive | M4 | survey |
| F18 | Verificação E2E e Auditoria Forense | Validação independente por Reviewers, Challengers e Auditor Forense (teamwork_auditor) | M5 | survey |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Organização e Limpeza Geral | Remoção de redundâncias, isolamento GTA em games/gta-sa/, reorganização de scripts e docs, desduplicação de backups | none | DONE |
| M2 | Organização das Aulas de DAO | Purga de dao-09.mp4 (0 bytes), renomeação canônica de dao-01 a dao-11 e alocação na Trilha 4 do mini-fiscalizacao | none | DONE |
| M3 | Aprimoramento da Ferramenta de Organização | Correções no motor de regras, AutoNamer, tratamento de pastas, proteção 0-byte, scripts shell e novos testes pytest | M1, M2 | DONE |
| M4 | Espelhamento no Google Drive | Simulação (--dry-run), sincronização real (--sync) e auditoria de status no Google Drive | M1, M2, M3 | DONE |
| M5 | Verificação E2E & Auditoria Forense | Revisão independente, testes adversariais e auditoria de integridade forense de todos os critérios de aceitação | M4 | DONE |

## Interface Contracts
### scripts/organizador ↔ Filesystem
- Entrada: `--dest`, `--all`, `--desktop`, `--downloads`, `--drive`, `--clean-empty`, `--dedup`, `--sanitize`
- Saída: Arquivos organizados na taxonomia `00..06`, histórico em `~/.organizador_master_history.json`, logs de execução.
- Requisitos: Código de saída 0, preservação de integridade, 0 corrupções de nomes.

### mini-fiscalizacao ↔ Trilha 4 DAO
- Entrada: 11 videoaulas `.mp4` oriundas de `00_Inbox_Triagem`
- Destino: `/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/`
- Nomenclatura: `DAO-XX_<Titulo-Canônico-da-Aula>.mp4` correspondendo biunivocamente a `DAO-XX_*.md`

### scripts/gdrive-sync.sh ↔ Google Drive
- Entrada: `/mnt/dados/` (Pilares 01_Pessoal_e_Vida, 02_Estudos_e_Concursos, 03_Profissional_WFIX, 04_Desenvolvimento_e_Codigo)
- Destino Remoto: `gdrive:Taxonomia_Backup/`
- Modo: `rclone sync` seletivo com exclusão de `.git`, caches e binários temporários.

## Code Layout
- `/home/lan/dotfiles/`: Repositório central de configurações e dotfiles.
- `/home/lan/dotfiles/games/gta-sa/`: Documentação e scripts de modding GTA San Andreas.
- `/home/lan/dotfiles/scripts/`: Scripts utilitários de sistema e dotfiles.
- `/home/lan/dotfiles/scripts/organizador/`: Código-fonte da ferramenta de organização de arquivos.
- `/home/lan/dotfiles/scripts/organizador/tests/`: Testes automatizados do organizador (`pytest`).
- `/home/lan/dotfiles/docs/`: Documentações de estudo e guias de sistema.

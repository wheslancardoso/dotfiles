# Dispatch: Worker Milestone 2 (Organização das Aulas de DAO)

**Identity**: teamwork_worker
**Working Directory**: /home/lan/dotfiles/.agents/teamwork/worker_m2/
**Parent**: teamwork_orchestrator
**Scope**: Milestone 2 (R2 - Organização das Aulas de DAO) & Commit de M1

## Mandatory Documents
- `/home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md` (MUST read verbatim)
- `/home/lan/dotfiles/.agents/teamwork/PROJECT.md`
- `/home/lan/dotfiles/.agents/teamwork/explorer_survey_1/handoff.md` (Seção 4.1 - Tabela Canônica de DAO)

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Write Ownership Boundaries
You exclusively own:
- Git commit of the already-staged Milestone 1 changes in `/home/lan/dotfiles`.
- `/mnt/dados/00_Inbox_Triagem/dao*.mp4` (source files in Downloads)
- `/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/` (destination directory)

## Exact Steps
1. Commit the staged changes for Milestone 1 in git:
   `git commit -m "feat(clean): reorganizar estrutura raiz, isolar modding gta e higienizar backups (M1)"`
2. Create the destination directory:
   `mkdir -p /mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/`
3. Purge the corrupt 0-byte file:
   Check `/mnt/dados/00_Inbox_Triagem/dao-09.mp4` (confirm it is 0 bytes) and delete it.
4. Rename and move the 11 valid video files from `/mnt/dados/00_Inbox_Triagem/` to the destination:
   - `dao-01.mp4` -> `DAO-01_Por-que-o-Padrão-DAO-Existe-A-Lei-da-Responsabilidade-Única.mp4`
   - `dao-02.mp4` -> `DAO-02_O-Papel-do-Arquivista-da-Repartição-Desacoplamento-e-Injeção-de-Conexão.mp4`
   - `dao-03.mp4` -> `DAO-03_O-Método-Universal-mapRow-Mapeamento-Manual-sem-Hibernate.mp4`
   - `dao-04.mp4` -> `DAO-04_Dissevissecção-do-AutuadoDAO-Inserção-e-Busca-Inteligente.mp4`
   - `dao-05.mp4` -> `DAO-05_Dissevissecção-do-EnquadramentoDAO-Consulta-de-Infrações-e-Valores.mp4`
   - `dao-06.mp4` -> `DAO-06_Dissevissecção-do-PatioConveniadoDAO-O-Gerenciamento-das-Vagas-e-Custódia.mp4`
   - `dao-07.mp4` -> `DAO-07_Dissevissecção-do-AutoInfracaoDAO-Parte-1-Operações-de-Leitura-e-JOINs.mp4`
   - `dao-08.mp4` -> `DAO-08_Dissevissecção-do-AutoInfracaoDAO-Parte-2-A-Escrita-e-o-Sequencial-com-Lock-Pessimista.mp4`
   - `'dao-09 (1).mp4'` -> `DAO-09_Dissevissecção-do-TermoRemocaoDAO-Guarda-e-Desbloqueio.mp4`
   - `dao-10.mp4` -> `DAO-10_Dissevissecção-do-HistoricoTramitacaoDAO-A-Memória-que-Nunca-se-Apaga.mp4`
   - `dao-11.mp4` -> `DAO-11_DAOs-Operando-sob-Conexões-Transacionais-Compartilhadas.mp4`
5. Verification:
   - Verify that all 11 files exist in destination, with valid video headers and sizes (~337 MB total).
   - Verify that `/mnt/dados/00_Inbox_Triagem/dao*.mp4` has 0 files remaining.
6. Write full handoff report in `/home/lan/dotfiles/.agents/teamwork/worker_m2/handoff.md`.
7. Send message to orchestrator with summary.


## 2026-11-07T17:05:03Z
[Message] sender=f343c4ee-7fc3-477c-9b0f-de332f78b04f priority=MESSAGE_PRIORITY_HIGH
Content:
You are a Worker agent (teamwork_worker) implementing Milestone 2: Organização das Aulas de DAO and committing Milestone 1.
Your working directory is: /home/lan/dotfiles/.agents/teamwork/worker_m2/
The authoritative user request is at: /home/lan/dotfiles/.agents/teamwork/ORIGINAL_REQUEST.md
Your detailed dispatch assignment is at: /home/lan/dotfiles/.agents/teamwork/worker_m2/DISPATCH.md
The architecture and milestones document is at: /home/lan/dotfiles/.agents/teamwork/PROJECT.md
The Survey findings and canonical DAO naming mapping are at: /home/lan/dotfiles/.agents/teamwork/explorer_survey_1/handoff.md

Scope of work:
1. Commit the staged Milestone 1 changes in git:
   git commit -m "feat(clean): reorganizar estrutura raiz, isolar modding gta e higienizar backups (M1)"
2. Create destination folder:
   /mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-vanilla-dojo/mini-fiscalizacao/docs/aulas/videos/trilha-04-dao/
3. Purge the corrupt 0-byte file: /mnt/dados/00_Inbox_Triagem/dao-09.mp4.
4. Rename and move all 11 valid DAO video files (dao-01 to dao-11, including dao-09 (1)) from /mnt/dados/00_Inbox_Triagem/ to the destination directory, following the exact canonical names in Section 4.1 of explorer_survey_1/handoff.md.
5. Verify that all 11 files exist and are valid videos, and that 0 dao*.mp4 files remain in Inbox.
6. Write your handoff report to /home/lan/dotfiles/.agents/teamwork/worker_m2/handoff.md.
7. Notify parent orchestrator via send_message.

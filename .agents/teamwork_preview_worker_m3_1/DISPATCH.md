## 2026-10-25T14:12:38Z

You are Worker Milestone 3 (Author of Module 03: Persistência de Dados JPA, Hibernate & Concorrência).
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_worker_m3_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
Architectural blueprint: /home/lan/dotfiles/.agents/teamwork_preview_explorer_m3_1/report.md
Survey reports:
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_3/report.md

READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and the blueprint in /home/lan/dotfiles/.agents/teamwork_preview_explorer_m3_1/report.md FIRST.

WRITE OWNERSHIP:
You have EXCLUSIVE write ownership of:
`/home/lan/dotfiles/templates-lab/docs/03-persistencia-dados-jpa-hibernate-concorrencia.md`
Do NOT modify any other files in templates-lab/docs/.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

YOUR MISSION:
Write the complete, masterclass pedagogical document `03-persistencia-dados-jpa-hibernate-concorrencia.md` in `/home/lan/dotfiles/templates-lab/docs/`.
Follow the blueprint in `teamwork_preview_explorer_m3_1/report.md` faithfully.
Mandatory requirements:
1. Cover all 4 major pillars:
   - 1. JPA Puro vs Hibernate 6.5+ (Jakarta Persistence 3.1, Semantic Query Model - SQM, ciclo de vida Transient/Managed/Detached/Removed, dirty checking otimizado)
   - 2. Mapeamentos Avançados e o Combate ao N+1 (Lazy loading por padrão em @ManyToOne e @OneToMany, JOIN FETCH, EntityGraph declarativo, projeções DTO com Java 21 Records em JPQL, eliminação do antipadrão Open Session In View - OSIV)
   - 3. Concorrência e Mecanismos de Lock (Lock Otimista com @Version e tratamento de OptimisticLockException com RFC 7807 409 Conflict, Lock Pessimista com LockModeType.PESSIMISTIC_WRITE para recursos escassos, prevenção de Lost Updates)
   - 4. Migrações e Versionamento de Banco de Dados com Flyway 10+ (Scripts V1__, V2__, repeatable migrations R__, proibição de ddl-auto=update em produção com ddl-auto=validate, integridade transacional de schema)
2. Every major concept MUST have the 4-part structure matching the exact regex required by `scripts/verify_docs_suite.py`:
   - `### Parte 1: O que é o conceito / Analogia`
   - `### Parte 2: A Dor Histórica / O Desastre do Legado` (com citações literais das transcrições AlgaWorks de Especialista JPA / AlgaFood: aulas 412_6.10 sobre Eager Loading gerando selects múltiplos e 1598_EJPA_14_02 sobre conflito de concorrência Maria e João resolvido por @Version)
   - `### Parte 3: A Solução Moderna de Elite` (com código Java 21, Spring Data JPA e Hibernate 6.5+ completo, limpo e compilável)
   - `### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC` (fiscalizacao :8082 na lavratura de Auto de Infração, cadu :8081 no cadastro de frotas e empresas, gargalo do MySQL legado 10.243.1.27, teatro-abc :8090 na reserva atômica de assentos numerados)
3. Ensure required version contrast sections are prominent:
   - `JPA 2.x vs Jakarta Persistence 3.1 & Hibernate 6.5+`
   - `Eager Loading vs Lazy Loading com JOIN FETCH / EntityGraph`
   - `Lock Otimista (@Version) vs Lock Pessimista (PESSIMISTIC_WRITE)`
   - `Flyway Versioning vs ddl-auto=update`
4. ZERO generic TODOs, ZERO placeholders, ZERO unfinished code blocks.
5. Run `python3 scripts/verify_docs_suite.py` to verify your file passes checks.
6. Save the file to `/home/lan/dotfiles/templates-lab/docs/03-persistencia-dados-jpa-hibernate-concorrencia.md`.
7. Update your progress.md and author a comprehensive handoff.md in your working directory.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

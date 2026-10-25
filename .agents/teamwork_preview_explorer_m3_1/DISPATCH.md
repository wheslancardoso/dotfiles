## 2026-10-25T14:01:10Z
You are Explorer Milestone 3 (Persistência JPA, Hibernate & Concorrência).
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_explorer_m3_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
Survey reports:
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_3/report.md

READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and the survey reports FIRST.

YOUR MISSION:
Produce the detailed, exhaustive specification and content outline for `03-persistencia-dados-jpa-hibernate-concorrencia.md` in `/home/lan/dotfiles/templates-lab/docs/`.
The document must cover:
1. JPA Puro vs Hibernate 6.5+ (Jakarta Persistence 3.1, Semantic Query Model - SQM, ciclo de vida de entidades Transient/Managed/Detached/Removed, dirty checking otimizado).
2. Mapeamentos Avançados e o Combate ao N+1 (Lazy loading por padrão em @ManyToOne e @OneToMany, armadilhas do Eager Loading default, JOIN FETCH, EntityGraph declarativo, projeções DTO imutáveis com Records em JPQL, eliminação do antipadrão Open Session In View - OSIV).
3. Concorrência e Mecanismos de Lock (Lock Otimista com @Version e tratamento de OptimisticLockException, Lock Pessimista com LockModeType.PESSIMISTIC_WRITE para recursos escassos como numeração sequencial de autos de infração e emissão de DARE, prevenção de Lost Updates).
4. Migrações e Versionamento de Banco de Dados com Flyway (Estrutura de versionamento V1__, V2__, repeatable migrations R__, proibição absoluta de ddl-auto=update ou create-drop em produção, integridade transacional de scripts de schema).

EVERY SINGLE CONCEPT MUST HAVE:
1. O que é o conceito (analogia intuitiva)
2. A Dor Histórica / O Desastre do Legado (com citações literais das transcrições AlgaWorks de Especialista JPA / AlgaFood: aulas 412_6.10 sobre Eager Loading gerando selects múltiplos, 1598_EJPA_14_02 sobre conflito de concorrência Maria e João resolvido por @Version, e OSIV)
3. A Solução Moderna de Elite (com código Java 21, Spring Data JPA e Hibernate 6.5+ completo, limpo e executável)
4. Vínculo Direto com o AGR-Docs / Teatro-ABC (fiscalizacao :8082 na concorrência de lavratura de Auto de Infração, cadu :8081 no cadastro de frotas e empresas, gargalo do MySQL legado 10.243.1.27 com travamentos de tabela inteira, teatro-abc :8090 na reserva atômica de assentos numerados).

Check `scripts/verify_docs_suite.py` for exact header and regex requirements.
Write your blueprint and implementation guidance to:
`/home/lan/dotfiles/.agents/teamwork_preview_explorer_m3_1/report.md`
Update your progress.md and handoff.md.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

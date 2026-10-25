# Handoff Report — Explorer Survey 2: AGR-Docs 25 Microservices & Production Architecture

## 1. Observation
1. **Repository Discovery:**
   - Discovered core architectural documentation repository at `/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/` containing 28 project directories under `projetos/` and top-level architecture guides under `docs/`.
   - Discovered `templates-lab/` at `/home/lan/dotfiles/templates-lab/` with `PLANO-DE-VOO.md`, `ESTADO-ATUAL.md`, and 10 rule files in `.agents/rules/` including `08-padrao-arquitetura-agr-docs.md`, `09-protocolo-engenharia-reversa-e-megadocs.md`, and `10-modo-estudo-e-replica-arquitetura.md`.
2. **Portal 1 vs Portal 2 Comparison:**
   - In `/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/docs/GUIA-PORTAIS-E-AMBIENTES.md`, lines 9-18:
     * Portal 1: Java 8 (`8.0.201`), Node 14.21.x, Angular CLI 7.2.x, 9 repositories (5 systems).
     * Portal 2: Java 17 (`17.0.12`), Node 14.21.x, Angular CLI 13.2.x, 64 repositories (25 systems).
3. **Ports and Responsibilities:**
   - In `/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/docs/01-visao-geral-arquitetura.md`, lines 84-98:
     * `portalservice`: Backend Spring Boot `:8080`, Frontend Angular `:4200`
     * `cadastrounicoservice`: Backend Spring Boot `:8081`, Frontend Angular `:4201`
     * `tripregularservice`: Backend Spring Boot `:8082`, Frontend Angular `:4202`
     * `agrfiscalservice`: Backend Spring Boot `:8083`, Frontend Angular `:4203`
     * `fretamentoservice`: Backend Spring Boot `:8084`, Frontend Angular `:4204`
     * `vistoriadora`: Frontend Angular `:4205`
     * `bilhetepassagem`: Frontend Angular `:4206`
     * `gratuidade`: Frontend Angular `:4207`
     * `govbrservice`: Backend Auth Helper `:8103`
   - In `projetos/dare/docs/12-integracoes-inter-servico.md`, lines 36-46:
     * `daredtoservice`: `:8088` (or `:8082`)
     * `protocoloservice`: `:8105`
     * `saneamentobasicoservice`: `:8098`
     * `vinculadoservice`: `:8099`
     * `seiservice`: `:8111`
   - In `projetos/receitas/docs/01-visao-geral-e-arquitetura.md`, line 18:
     * `receitaservice`: `:8098` / `:8092`, Frontend Angular `:4212`
   - In `templates-lab/PLANO-DE-VOO.md`, lines 97-108:
     * Greenfield `teatro-abc`: Oscar Niemeyer Cultural Center ticketing, concurrency control, cryptographic QR Code tickets, turnstile reader.
4. **Legacy Antipatterns & Codebase Evidence:**
   - In `projetos/cadu/docs/08-cadu-legado-e-ambientes.md`, lines 29-44:
     * Monolith in Spring Boot 2.1.3 and Java 8, 242 Java files reduced to 143 in Portal 2.
     * `ManterVeiculoBean.java` pattern (JSF/EJB-style bean naming) abandoning REST conventions.
     * `IVeiculoService` + `VeiculoServiceIMPL` duplication.
     * `jcifs: 1.3.17` (vulnerable SMBv1) on Windows file share `10.6.63.2`.
   - In `projetos/fiscalizacao/docs/06-queries-e-consultas-dao.md`, lines 13-34:
     * 113 raw SQL/JPQL queries mapped.
     * Manual string concatenation in `AutoInfracaoDAO` and `AbordagemDAO`: `"SELECT ... " + SQL_RELATORIO + " WHERE (CASE WHEN :cnpjCpf LIKE '_%' THEN e.cnpj_cpf LIKE :cnpjCpf ELSE TRUE END)"`.
     * Heavy correlated subqueries on `auto_infracao` causing full table scans.
   - In `docs/01-visao-geral-arquitetura.md` and `docs/02 - Documentacao Completa - Portal Backend (portalservice).md`:
     * Single MySQL database bottleneck at `10.243.1.27:3306` shared by all 25 microservices.
     * Hardcoded symmetric secret `jwt.secret=sw!tch14` HMAC-SHA512 across services.
     * Non-standard `Response<T> { data, erros, statusReq }` returned with HTTP 200 even for errors.
     * Complete absence of optimistic locking (`@Version`) on entities `AutoInfracao`, `TermoRemocaoVeiculo`, and `Veiculo`.

## 2. Logic Chain
1. Based on the file survey in `agr-docs/projetos/` and `templates-lab/`, the AGR production architecture is a distributed microservice landscape comprising 25 documented systems running on Java 17 / Spring Boot 2.6.x (Portal 2), migrated from an initial set of 5 Java 8 monolithic services (Portal 1).
2. Because all 25 microservices share the single MySQL database at `10.243.1.27:3306`, analytical reports (such as 44 JasperReports in `fiscalizacao` running unindexed correlated subqueries) directly contend for table locks and I/O bandwidth with transactional operations (roadside blitz auto creation), creating significant database bottlenecks.
3. Because inter-service calls (`portalservice -> cadu -> tripregular -> dare`) rely on synchronous, blocking HTTP requests via `ConsumidorServicosUtil` without circuit breakers or asynchronous queuing, downstream latency (e.g. from DETRAN-GO or SEI-GO) cascades backward, exhausting Tomcat worker thread pools.
4. Because entities lack `@Version` and rely on custom `Response<T>` envelopes with HTTP 200, the legacy system suffers from silent lost updates during concurrent edits and violates standard RFC 7807 error handling.
5. Therefore, the 5 canonical modules in `templates-lab/docs/` directly map to resolving these concrete production pains:
   - Module 01 resolves UI context switching, canvas signatures, and DOM manipulations.
   - Module 02 resolves the REST controller architecture, RFC 7807 Problem Details, Java 21 Records, and Virtual Threads.
   - Module 03 resolves concurrency, lost updates (`@Version`), sequential number locks (`@Lock(LockModeType.PESSIMISTIC_WRITE)`), Specifications, and Flyway migrations.
   - Module 04 resolves stateless JWT authentication, replacing hardcoded symmetric keys with RSA JWKS and `@PreAuthorize` RBAC.
   - Module 05 resolves Angular frontend modularity, replacing monolithic `NgModules` and leaky RxJS subscriptions with Standalone Components and Signals.

## 3. Caveats
- No live network connection to `10.243.1.27` or `10.6.63.2` was made (the investigation operated in strict read-only offline mode across local repository files, dumps, and reverse-engineered documentation).
- Minor port variations exist between local development configs (e.g., `dare` sometimes mapped to `:8088` and sometimes to `:8082` when overriding `tripregular`; `fiscalizacao` mapped to `:8083` in standalone back and `:8082` in older docs; `receitas` mapped to `:8092` and `:8098`). All variations are documented in the matrix.

## 4. Conclusion
The comprehensive survey report has been generated and saved to:
`/home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md`
It provides an exhaustive, factual mapping of all 25 microservices, their ports, legacy antipatterns, and 1:1 correspondences with the 5 canonical modules for the upcoming documentation authoring milestones.

## 5. Verification Method
1. Inspect the survey report:
   `view_file(AbsolutePath="/home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md")`
2. Verify referenced files in the workspace:
   - `view_file(AbsolutePath="/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/docs/GUIA-PORTAIS-E-AMBIENTES.md")`
   - `view_file(AbsolutePath="/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/docs/01-visao-geral-arquitetura.md")`
   - `view_file(AbsolutePath="/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/projetos/fiscalizacao/docs/06-queries-e-consultas-dao.md")`
   - `view_file(AbsolutePath="/home/lan/dotfiles/templates-lab/PLANO-DE-VOO.md")`
3. Invalidation condition: If any microservice port or legacy pattern is contradicted by the production source tree or `.sql` schemas, the mapping in Section 2 of `report.md` can be updated accordingly.

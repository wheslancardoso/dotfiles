# Project: Suíte Modular de Documentação Pedagógica (AlgaWorks x AGR-Docs x Modern Vanilla)

## Architecture
- Target Directory: `/home/lan/dotfiles/templates-lab/docs/`
- Documentation Corpus:
  1. `01-fundamentos-web-e-javascript-vanilla.md` [DONE - 1,927 lines, Gate Passed]
  2. `02-arquitetura-backend-spring-boot-3.md` [DONE - 1,217 lines, 12/12 checks passed]
  3. `03-persistencia-dados-jpa-hibernate-concorrencia.md` [DONE - 1,071 lines, 12/12 checks passed]
  4. `04-seguranca-stateless-oauth2-jwt-rbac.md` [DONE - 1,284 lines, 12/12 checks passed]
  5. `05-frontend-enterprise-angular-vanilla.md` [DONE - 1,436 lines, 12/12 checks passed]
  6. `README.md` (Central Index & Complete Traceability Matrix) [DONE - 158 lines, 24.9KB, 12/12 checks passed]
- Test Harness / Automated E2E Verifier:
  - `scripts/verify_docs_suite.py` (74/74 checks passed, 100% pass across all 4 tiers)

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| F01 | HTML5 Semântico & Acessibilidade | Substituição de div soup por tags semânticas, ARIA, contraste | M1 | Survey (MJS/WDR/Explorer 1,3) |
| F02 | CSS3 Moderno & Metodologia BEM | Eliminação de !important e acoplamento por IDs; BEM, Flexbox, CSS Grid | M1 | Survey (WDR/Explorer 1,3) |
| F03 | JavaScript ES6+ & Assincronismo | Escopo de bloco (let/const vs var), Promises, async/await, Event Loop | M1 | Survey (MJS/Explorer 1,3) |
| F04 | Manipulação de DOM Vanilla | querySelector, delegação de eventos, manipulação segura sem jQuery | M1 | Survey (MJS/AGR/Explorer 1,2) |
| F05 | Java 21 LTS Core Features | Records, Virtual Threads (Project Loom), Pattern Matching, Sealed Types | M2 | Survey (ESR/Explorer 1,3) |
| F06 | Spring Boot 3.3+ REST Architecture | Controllers RESTful, DTO Records imutáveis, Bean Validation, RestClient | M2 | Survey (ESR/Explorer 1,3) |
| F07 | Tratamento Global de Erros RFC 7807 | ProblemDetail nativo, ErrorResponseException, fim de POJOs manuais | M2 | Survey (ESR/Explorer 1,3) |
| F08 | Arquitetura Limpa & Observabilidade | Camadas de domínio desacopladas, Actuator, Micrometer, Health checks | M2 | Survey (ESR/AGR/Explorer 2,3) |
| F09 | JPA Puro vs Hibernate 6.5+ | Jakarta Persistence 3.1, ciclo de vida de entidades, SQM | M3 | Survey (EJPA/Explorer 1,3) |
| F10 | Otimização de Mapeamentos & N+1 | Lazy loading por padrão, JOIN FETCH, EntityGraph, projeções DTO | M3 | Survey (EJPA/Explorer 1,3) |
| F11 | Concorrência & Locking | Lock Otimista (@Version, OptimisticLockException), Lock Pessimista | M3 | Survey (EJPA/AGR/Explorer 1,2,3) |
| F12 | Migração de Banco com Flyway | Versionamento de schema (V1__, V2__), fim de ddl-auto=update em produção | M3 | Survey (EJPA/AGR/Explorer 2,3) |
| F13 | Spring Security 6 Architecture | SecurityFilterChain, fim de WebSecurityConfigurerAdapter, requestMatchers | M4 | Survey (ESR/Explorer 1,3) |
| F14 | OAuth2 Stateless & JWT Token Flow | Resource Server, validação de tokens JWT, chaves públicas RSA/JWKS | M4 | Survey (ESR/AGR/Explorer 1,2,3) |
| F15 | RBAC & Granular Method Security | Claims de authorities/scopes, @PreAuthorize("hasAuthority(...)") | M4 | Survey (ESR/AGR/Explorer 1,2,3) |
| F16 | Transição OAuth 2.1 & Fim do Password Grant | Descontinuação de Resource Owner Password Credentials e Authorization Code PKCE | M4 | Survey (ESR/Explorer 1,3) |
| F17 | TypeScript Estrito Enterprise | Tipagem rigorosa, interfaces, generic types, noImplicitAny, immutability | M5 | Survey (FAS/Explorer 1,3) |
| F18 | Angular Moderno: Standalone Components | Eliminação de NgModules (AppModule/SharedModule), bootstrapApplication | M5 | Survey (FAS/Explorer 1,3) |
| F19 | Reatividade Moderna com Signals | signal, computed, effect, substituição de RxJS puro para estado síncrono | M5 | Survey (FAS/Explorer 1,3) |
| F20 | Formulários Reativos & PrimeNG Moderno | Typed Reactive Forms, validações assíncronas, p-table (fim de p-dataTable) | M5 | Survey (FAS/AGR/Explorer 1,2,3) |
| F21 | Matriz Central de Rastreabilidade | Tabela cruzada: AlgaWorks (1.625 transcrições) x AGR (25 microserviços) x Moderno | M6 | Survey (Explorers 1, 2, 3) |
| F22 | Índice Central & Guia de Estudo | README.md com sumário executivo, trilha de aprendizagem e guia do desenvolvedor | M6 | Survey (Explorers 1, 2, 3) |
| F23 | Suíte de Testes Automatizada & Auditoria E2E | Verificação estrita de ausência de TODOs, 4 camadas didáticas, contraste de versões | M7 | Survey (Explorers 1, 2, 3) |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Fundamentos Web & JS Vanilla | Author `01-fundamentos-web-e-javascript-vanilla.md` (F01-F04) | Survey | DONE |
| M2 | Arquitetura Backend Spring Boot 3.3+ | Author `02-arquitetura-backend-spring-boot-3.md` (F05-F08) | Survey | DONE |
| M3 | Persistência JPA, Hibernate & Concorrência | Author `03-persistencia-dados-jpa-hibernate-concorrencia.md` (F09-F12) | Survey | DONE |
| M4 | Segurança Stateless OAuth2, JWT & RBAC | Author `04-seguranca-stateless-oauth2-jwt-rbac.md` (F13-F16) | M4 Blueprint | DONE |
| M5 | Frontend Enterprise Angular Vanilla | Author `05-frontend-enterprise-angular-vanilla.md` (F17-F20) | M5 Blueprint | DONE |
| M6 | README.md Central & Rastreabilidade | Author `README.md` (F21-F22) com matriz completa de rastreabilidade | M1, M2, M3, M4, M5 | DONE |
| M7 | E2E Verification & Forensic Integrity Audit | Testes automatizados (F23), revisão profunda e auditoria de integridade | M6 | DONE |

## Interface Contracts
### Pedagogical 4-Part Structure Contract (Mandatory for EVERY Concept)
Every major concept within every module file must strictly provide all 4 parts:
1. **O que é o conceito explicado de forma simples**: Analogia com o mundo real para qualquer iniciante.
2. **A Dor Histórica / O Desastre do Legado**: O que quebrava em produção quando se fazia errado (referenciando os erros clássicos das aulas legadas AlgaWorks e sistemas legados).
3. **A Solução Moderna de Elite**: Como a engenharia moderna resolve (código em Java 21, Spring Boot 3.3+, Angular moderno, HTML5/CSS3/BEM).
4. **Vínculo Direto com o AGR-Docs / Teatro-ABC**: Onde e como isso se aplica exatamente nos 25 microsserviços reais da AGR (`portalservice :8080`, `cadu :8081`, `fiscalizacao/agrfiscalservice :8083`, `receita :8092`, `dare :8088`, `seiservice :8111`, etc.) ou no greenfield `teatro-abc :8090`.

### Technical Veracity & Integrity Contract
- NO placeholders: No `TODO`, `FIXME`, `[TBD]`, `implementar depois`, or abbreviated code snippets.
- Real, syntactically valid code blocks for all examples.
- Accurate version contrasts: Java 8 vs 17 vs 21; Spring Boot 2.x vs 3.3+; Spring Security 5 vs 6; Angular 2-15 vs 17/18+.

## Code Layout
- Target folder: `/home/lan/dotfiles/templates-lab/docs/`
  - `01-fundamentos-web-e-javascript-vanilla.md` (DONE - 1,927 lines, Gate Passed)
  - `02-arquitetura-backend-spring-boot-3.md` (DONE - 1,217 lines, 12/12 tests pass)
  - `03-persistencia-dados-jpa-hibernate-concorrencia.md` (DONE - 1,071 lines, 12/12 tests pass)
  - `04-seguranca-stateless-oauth2-jwt-rbac.md` (DONE - 1,284 lines, 12/12 tests pass)
  - `05-frontend-enterprise-angular-vanilla.md` (DONE - 1,436 lines, 12/12 tests pass)
  - `README.md` (DONE - 158 lines, 24.9KB, 74/74 suite checks pass)
- Test & Verification scripts:
  - `scripts/verify_docs_suite.py` (74/74 checks passed)

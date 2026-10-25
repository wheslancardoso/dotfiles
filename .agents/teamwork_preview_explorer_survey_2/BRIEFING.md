# BRIEFING — 2026-10-25T13:43:00Z

## Mission
Investigate and map the real AGR microservices architecture (ports, responsibilities, legacy architectures, bottlenecks) and correlate with canonical modules 01-05.

## 🔒 My Identity
- Archetype: explorer
- Roles: explorer, investigator, synthesizer
- Working directory: /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2
- Original parent: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff
- Milestone: survey-agr-architecture

## 🔒 Key Constraints
- Read-only investigation — do NOT implement
- Write reports, handoff, and progress in assigned directory
- Reference real AGR services, ports, legacy vs modern patterns, and module mappings

## Current Parent
- Conversation ID: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff
- Updated: 2026-10-25T13:43:00Z

## Investigation State
- **Explored paths**:
  - `/home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md`
  - `/home/lan/dotfiles/templates-lab/` (PLANO-DE-VOO.md, ESTADO-ATUAL.md, rules 01-10)
  - `/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/` (docs, projetos, scripts, e2e)
  - `/home/lan/dotfiles/skills/dojo-fiscalizacao/`
  - `/home/lan/teatro-abc/`
- **Key findings**:
  - 25 production microservices mapped in Portal 2 (64 Git repos) + 5 legacy systems in Portal 1 (Java 8).
  - Port mapping cataloged: portalservice :8080, cadu :8081, tripregular :8082, fiscalizacao/agrfiscalservice :8083, fretamento :8084, dare :8088/:8082, receitas :8092/:8098, bens-desestatizados :8097, base-cidadao :8102, govbrservice :8103, protocoloservice :8105, seiservice :8111, teatro-abc :8090.
  - Legacy antipatterns audited: EJB/JSF beans (`*Bean.java`), 1:1 service/IMPL interfaces, raw SQL string concatenation in DAOs (`AutoInfracaoDAO`), single MySQL 5.7/8.0 bottleneck (`10.243.1.27:3306`), SMBv1 Windows file share (`10.6.63.2`), custom non-standard `Response<T>`.
  - Direct touchpoints mapped for all 5 canonical modules: Module 01 (DOM switcher, token bypass, canvas signature, Mercosul plate regex), Module 02 (RFC 7807 Problem Details, Java 21 Records, Virtual Threads), Module 03 (Optimistic `@Version`, Pessimistic `@Lock`, Specifications, Flyway), Module 04 (Spring Security 6 SecurityFilterChain, RSA JWKS, fine-grained `@PreAuthorize`), Module 05 (Angular Standalone, Signals, Typed Reactive Forms, PrimeNG 17+).
- **Unexplored areas**: None. Complete factual mapping achieved.

## Key Decisions Made
- Executed deep dive into `/home/lan/projects/04.1_Projetos_Web_e_Apps/agr-docs/` where all reverse-engineered specs, SQL schemas, and architecture guides are maintained.
- Authored exhaustive structured report in `report.md`.

## Artifact Index
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/DISPATCH.md — Incoming task dispatch
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/BRIEFING.md — Situational awareness
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/progress.md — Progress log
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md — Comprehensive survey report
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/handoff.md — Handoff report

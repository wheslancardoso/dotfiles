# BRIEFING — 2026-10-25T13:46:00Z

## Mission
Investigate and map legacy paradigms from AlgaWorks (1,625 transcripts/course materials) across the 5 canonical modules.

## 🔒 My Identity
- Archetype: explorer
- Roles: investigation, synthesis
- Working directory: /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1
- Original parent: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff
- Milestone: AlgaWorks Legacy Paradigms Mapping

## 🔒 Key Constraints
- Read-only investigation — do NOT implement
- Map legacy paradigms across 5 canonical modules (Fundamentos Web, Spring Boot 2.x/Java 8, JPA/Hibernate, Spring Security, Angular)
- Investigate transcripts and materials in workspace
- Output report.md, progress.md, and handoff.md

## Current Parent
- Conversation ID: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff
- Updated: 2026-10-25T13:32:41Z

## Investigation State
- **Explored paths**:
  - `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/` (1,625 transcript files)
  - `/home/lan/dotfiles/templates-lab/` (`PLANO-DE-VOO.md`, `ESTADO-ATUAL.md`)
  - `/mnt/dados/04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps/agr-docs/` (25 microservices architecture)
- **Key findings**:
  - Exact distribution of 1,625 transcripts: ESR (599), FAS (292), EJPA (267), Java Core (126), JSF/PrimeFaces (116), JPA Clássico (77), WDR (73), MJS (69), Outros (6).
  - Module 1: `var` function scoping, global leaks (`90_MJS`), CSS specificity wars and `!important` chaos (`50_WDR`), BEM evolution (`51_WDR`).
  - Module 2: ModelMapper reflection overhead (`502_11.14`), manual RFC 7807 implementation in Spring Boot 2.x (`441_8_15`, `452_8_28`), SpringFox deprecation to SpringDoc (`814_26.2`), Jakarta EE migration (`864_28.1`).
  - Module 3: Default `FetchType.EAGER` N+1 disaster (`412_6.10`), lost update solved by `@Version` (`1598_EJPA_14_02`), OSIV connection pool exhaustion.
  - Module 4: `WebSecurityConfigurerAdapter` deprecation to `SecurityFilterChain` (`869_28.6`), `antMatchers` to `requestMatchers`, legacy OAuth2 stack deprecation (`708_22_6`), removal of Resource Owner Password Credentials Grant in OAuth 2.1.
  - Module 5: NgModule hierarchy (`1008_FAS_14.1`, `1017_FAS_14.10`), `.toPromise()` antipattern (`1029_FAS_16.3`), manual subscription leaks, PrimeNG `p-dataTable` deprecation to `p-table` (`967_FAS_10.5`, `1039_FAS_17.6`).
- **Unexplored areas**: None for Survey 1. Ready for handoff to drafting agents.

## Key Decisions Made
- Extracted and quoted verbatim transcripts from AlgaWorks lessons for each of the 5 canonical modules.
- Correlated every legacy debt with corresponding systems in AGR (`portalservice`, `cadu`, `fiscalizacao`, `seiservice`, `receitaservice`) and `teatro-abc`.
- Completed comprehensive `report.md`.

## Artifact Index
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md — Comprehensive mapping of legacy paradigms
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/handoff.md — 5-component handoff report
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/progress.md — Progress and liveness tracker
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/DISPATCH.md — Incoming instruction log

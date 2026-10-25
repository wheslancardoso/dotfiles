## 2026-10-25T11:01:10-03:00

You are Worker Milestone 2 (Author of Module 02: Arquitetura Backend Spring Boot 3.3+).
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_worker_m2_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
Architectural blueprint: /home/lan/dotfiles/.agents/teamwork_preview_explorer_m2_1/report.md
Survey reports:
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_3/report.md

READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and the blueprint in /home/lan/dotfiles/.agents/teamwork_preview_explorer_m2_1/report.md FIRST.

WRITE OWNERSHIP:
You have EXCLUSIVE write ownership of:
`/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md`
Do NOT modify any other files in templates-lab/docs/.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

YOUR MISSION:
Write the complete, masterclass pedagogical document `02-arquitetura-backend-spring-boot-3.md` in `/home/lan/dotfiles/templates-lab/docs/`.
Follow the blueprint in `teamwork_preview_explorer_m2_1/report.md` faithfully.
Mandatory requirements:
1. Cover all 4 major pillars:
   - 1. Java 21 LTS Core Features (Java Records imutáveis com compact constructors vs DTOs mutáveis/Lombok, Virtual Threads Project Loom vs platform threads pool exhaustion, Pattern Matching para switch e Record Patterns, Sealed Interfaces)
   - 2. Spring Boot 3.3+ Architecture & RESTful Controllers (Jakarta EE 10 namespace, controllers RESTful modernos, RestClient fluente vs RestTemplate/WebClient, Bean Validation 3.0 com validadores customizados)
   - 3. Tratamento Global de Erros com RFC 7807 (ProblemDetail nativo do Spring 6+, ResponseEntityExceptionHandler, eliminação de classes Problem manuais e erradicação do envelope Response<T> com status 200)
   - 4. Arquitetura Limpa, Camadas & Observabilidade (Clean Architecture desacoplada vs modelo anêmico, SpringDoc OpenAPI 3, Spring Boot Actuator, Micrometer, Custom Health Indicators)
2. Every major concept MUST have the 4-part structure matching the exact regex required by `scripts/verify_docs_suite.py`:
   - `### Parte 1: O que é o conceito / Analogia`
   - `### Parte 2: A Dor Histórica / O Desastre do Legado` (com citações literais das transcrições AlgaWorks de ESR/AlgaFood: aulas 502, 503, 441, 452, 864, 865, 867)
   - `### Parte 3: A Solução Moderna de Elite` (com código Java 21 e Spring Boot 3.3+ completo, executável e compilável)
   - `### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC` (portalservice :8080, cadu :8081, fiscalizacao :8082, receita :8092, greenfield teatro-abc :8090)
3. Ensure required version contrast sections are prominent:
   - `Java 8 vs 17 vs 21 LTS`
   - `Java Records imutáveis para DTOs`
   - `Virtual Threads / Project Loom`
   - `Spring Boot 3.3+ REST & Tratamento RFC 7807 ProblemDetail`
4. ZERO generic TODOs, ZERO placeholders, ZERO unfinished code blocks.
5. Run `python3 scripts/verify_docs_suite.py` to verify your file passes checks.
6. Save the file to `/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md`.
7. Update your progress.md and author a comprehensive handoff.md in your working directory.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

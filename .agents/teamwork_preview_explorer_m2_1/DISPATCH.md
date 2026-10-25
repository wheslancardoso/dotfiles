## 2026-10-25T13:54:00Z

You are Explorer Milestone 2 (Arquitetura Backend Spring Boot 3.3+).
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_explorer_m2_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
Survey reports:
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_3/report.md

READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and the survey reports FIRST.

YOUR MISSION:
Produce the detailed, exhaustive specification and content outline for `02-arquitetura-backend-spring-boot-3.md` in `/home/lan/dotfiles/templates-lab/docs/`.
The document must cover:
1. Java 21 LTS Core Features (Java Records imutáveis vs POJOs/Lombok mutáveis, Virtual Threads Project Loom vs platform threads pool exhaustion, Pattern Matching for switch/instanceof, Sealed Interfaces/Classes).
2. Spring Boot 3.3+ Architecture & RESTful Controllers (Jakarta EE 10 namespace, modern Controllers, RestClient vs WebClient vs RestTemplate, Bean Validation @Valid).
3. Tratamento Global de Erros com RFC 7807 (ProblemDetail nativo do Spring 6+, ErrorResponseException, substituição de classes Problem POJO legadas).
4. Arquitetura Limpa, Camadas & Observabilidade (Separação Controller -> Service -> Domain -> Repository, Spring Boot Actuator, Micrometer, Health checks, Clean Arch vs antipadrão anêmico com lógica de negócio em Controllers).

EVERY SINGLE CONCEPT MUST HAVE:
1. O que é o conceito (analogia intuitiva)
2. A Dor Histórica / O Desastre do Legado (com citações literais das transcrições AlgaWorks de Especialista Spring REST / AlgaFood: DTOs mutáveis com ModelMapper, classes Problem manuais, quebra de bibliotecas SpringFox/Squiggly no Spring Boot 3)
3. A Solução Moderna de Elite (com código Java 21 e Spring Boot 3.3+ completo, limpo e executável)
4. Vínculo Direto com o AGR-Docs / Teatro-ABC (portalservice :8080, cadu :8081, fiscalizacao :8082, receita :8092, eliminação do Response<T> envelope legado, greenfield teatro-abc :8090).

Write your blueprint and implementation guidance to:
`/home/lan/dotfiles/.agents/teamwork_preview_explorer_m2_1/report.md`
Update your progress.md and handoff.md.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

## 2026-10-25T13:46:44Z
You are Test Writer for the E2E Testing Track.
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_test_writer_e2e_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and /home/lan/dotfiles/.agents/PROJECT.md FIRST.

YOUR MISSION:
Design and implement the automated E2E verification test harness in `scripts/verify_docs_suite.py` that verifies the entire pedagogical documentation suite in `/home/lan/dotfiles/templates-lab/docs/` against all acceptance criteria from ORIGINAL_REQUEST.md:
1. Tier 1 (File Existence): Checks that all 5 canonical files (01-fundamentos-web-e-javascript-vanilla.md, 02-arquitetura-backend-spring-boot-3.md, 03-persistencia-dados-jpa-hibernate-concorrencia.md, 04-seguranca-stateless-oauth2-jwt-rbac.md, 05-frontend-enterprise-angular-vanilla.md) and README.md exist in /home/lan/dotfiles/templates-lab/docs/.
2. Tier 2 (Completeness & Zero Placeholders): Scans all files for forbidden placeholders: "TODO", "FIXME", "[TBD]", "implementar depois", ellipsis in code without explanation. Ensures minimum substantive size (>300 lines each).
3. Tier 3 (Pedagogical 4-Part Structure & Version Contrasts): Validates that each module contains the mandatory 4 sections for its core concepts:
   - "O que é o conceito" / "Analogia"
   - "A Dor Histórica" / "O Desastre do Legado"
   - "A Solução Moderna de Elite"
   - "Vínculo Direto com o AGR-Docs" / "Teatro-ABC"
   Validates version contrasts (Java 8 vs 17 vs 21; Spring Security 5 vs 6; Angular legacy vs modern Signals).
4. Tier 4 (Traceability Matrix): Validates that README.md contains a complete traceability matrix with references to AlgaWorks transcripts, real AGR microservices (e.g. portalservice :8080, cadu :8081, fiscalizacao :8082, receita :8092), and greenfield teatro-abc.

Run the test suite using `python3 scripts/verify_docs_suite.py` to ensure it executes cleanly (it will report failures for not-yet-created files, which is expected at this stage).
Write `TEST_INFRA.md` and `TEST_READY.md` at `/home/lan/dotfiles/templates-lab/docs/` or project root.
Save your report to `/home/lan/dotfiles/.agents/teamwork_preview_test_writer_e2e_1/report.md`, update your progress.md and handoff.md.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

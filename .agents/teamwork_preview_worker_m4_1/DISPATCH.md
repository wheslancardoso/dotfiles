## 2026-10-25T14:23:45Z
You are Worker Milestone 4 (Author of Module 04: Segurança Stateless OAuth2, JWT e RBAC).
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_worker_m4_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
Architectural blueprint: /home/lan/dotfiles/.agents/teamwork_preview_explorer_m4_1/report.md
Survey reports:
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_3/report.md

READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and the blueprint in /home/lan/dotfiles/.agents/teamwork_preview_explorer_m4_1/report.md FIRST.

WRITE OWNERSHIP:
You have EXCLUSIVE write ownership of:
`/home/lan/dotfiles/templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md`
Do NOT modify any other files in templates-lab/docs/.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

YOUR MISSION:
Write the complete, masterclass pedagogical document `04-seguranca-stateless-oauth2-jwt-rbac.md` in `/home/lan/dotfiles/templates-lab/docs/`.
Follow the blueprint in `teamwork_preview_explorer_m4_1/report.md` faithfully.
Mandatory requirements:
1. Cover all 4 major pillars:
   - 1. Spring Security 6 Architecture & SecurityFilterChain (Remoção definitiva de WebSecurityConfigurerAdapter, configuração component-based com @Bean SecurityFilterChain, substituição de antMatchers por requestMatchers, CSRF desabilitado em APIs stateless, SessionCreationPolicy.STATELESS)
   - 2. OAuth2 Stateless & JWT Token Architecture (Separação estrita de papéis: Resource Server vs Authorization Server, chaves públicas assimétricas RSA/JWKS via jwk-set-uri, decodificador JwtDecoder customizado, validação de assinatura criptográfica, expiração, issuer)
   - 3. RBAC & Granular Method Security (Mapeamento de claims JWT em GrantedAuthority, distinção entre SCOPE_ e ROLE_, controle fino com @EnableMethodSecurity e @PreAuthorize("hasAuthority(...)"), SpEL com expressões complexas)
   - 4. Transição OAuth 2.1 & Fim do Password Grant (Descontinuação oficial de Resource Owner Password Credentials grant_type=password, adoção de Authorization Code com PKCE para Single Page Applications e Client Credentials para comunicação machine-to-machine M2M entre microsserviços)
2. Every major concept MUST have the 4-part structure matching the exact regex required by `scripts/verify_docs_suite.py`:
   - `### Parte 1: O que é o conceito / Analogia`
   - `### Parte 2: A Dor Histórica / O Desastre do Legado` (com citações literais das transcrições AlgaWorks de Especialista Spring REST: aulas 708_22_6, 709_22.7, 869_28.6, 713_22_11, 732_23_3, 736_23.9)
   - `### Parte 3: A Solução Moderna de Elite` (com código Java 21 e Spring Security 6 completo, limpo e compilável)
   - `### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC` (portalservice :8080 como central de identidade Keycloak/OAuth2, agrfiscalservice :8083 validando tokens JWT e permissões de fiscal, cadu :8081, receita :8092, comunicação M2M entre microsserviços, teatro-abc :8090)
3. Ensure required version contrast sections are prominent:
   - `Spring Security 5 vs 6`
   - `WebSecurityConfigurerAdapter vs SecurityFilterChain`
   - `Session-based Auth vs Stateless OAuth2 / JWT`
   - `OAuth 2.0 (Password Grant) vs OAuth 2.1 (PKCE / Client Credentials)`
4. ZERO generic TODOs, ZERO placeholders, ZERO unfinished code blocks.
5. Run `python3 scripts/verify_docs_suite.py` to verify your file passes checks.
6. Save the file to `/home/lan/dotfiles/templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md`.
7. Update your progress.md and author a comprehensive handoff.md in your working directory.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

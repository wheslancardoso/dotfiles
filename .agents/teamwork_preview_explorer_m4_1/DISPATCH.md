## 2026-10-25T14:12:38Z

You are Explorer Milestone 4 (Segurança Stateless OAuth2, JWT e RBAC).
Your working directory is: /home/lan/dotfiles/.agents/teamwork_preview_explorer_m4_1
Authoritative request: /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md
Project plan: /home/lan/dotfiles/.agents/PROJECT.md
Survey reports:
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_1/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_2/report.md
- /home/lan/dotfiles/.agents/teamwork_preview_explorer_survey_3/report.md

READ /home/lan/dotfiles/.agents/ORIGINAL_REQUEST.md and the survey reports FIRST.

YOUR MISSION:
Produce the detailed, exhaustive specification and content outline for `04-seguranca-stateless-oauth2-jwt-rbac.md` in `/home/lan/dotfiles/templates-lab/docs/`.
The document must cover:
1. Spring Security 6 Architecture & SecurityFilterChain (Remoção definitiva de WebSecurityConfigurerAdapter, configuração component-based com @Bean SecurityFilterChain, substituição de antMatchers por requestMatchers, CSRF desabilitado em APIs stateless, SessionCreationPolicy.STATELESS).
2. OAuth2 Stateless & JWT Token Architecture (Separação estrita de papéis: Resource Server vs Authorization Server, chaves públicas assimétricas RSA/JWKS via jwk-set-uri, decodificador JwtDecoder customizado, validação de assinatura criptográfica, expiração, issuer).
3. RBAC & Granular Method Security (Mapeamento de claims JWT em GrantedAuthority, distinção entre SCOPE_ e ROLE_, controle fino com @EnableMethodSecurity e @PreAuthorize("hasAuthority(...)"), SpEL com expressões complexas).
4. Transição OAuth 2.1 & Fim do Password Grant (Descontinuação oficial de Resource Owner Password Credentials grant_type=password, adoção de Authorization Code com PKCE para Single Page Applications e Client Credentials para comunicação machine-to-machine M2M entre microsserviços).

EVERY SINGLE CONCEPT MUST HAVE:
1. O que é o conceito (analogia intuitiva)
2. A Dor Histórica / O Desastre do Legado (com citações literais das transcrições AlgaWorks de Especialista Spring REST: aulas 708_22_6 sobre depreciação da antiga stack OAuth do Spring Security, 709_22.7 sobre password flow, e 869_28.6 sobre migração para Spring Authorization Server e EnableMethodSecurity)
3. A Solução Moderna de Elite (com código Java 21 e Spring Security 6 completo, limpo e compilável)
4. Vínculo Direto com o AGR-Docs / Teatro-ABC (portalservice :8080 como central de identidade Keycloak/OAuth2, agrfiscalservice :8083 validando tokens JWT e permissões de fiscal, cadu :8081, receita :8092, comunicação M2M entre microsserviços, teatro-abc :8090).

Check `scripts/verify_docs_suite.py` for exact header and regex requirements.
Write your blueprint and implementation guidance to:
`/home/lan/dotfiles/.agents/teamwork_preview_explorer_m4_1/report.md`
Update your progress.md and handoff.md.
When finished, send a message to caller (id: 4f62e0b6-eda0-44a0-acaf-53c8f9f8e7ff).

# Original User Request

## 2026-10-25T13:29:17Z

# Teamwork Project Prompt — Final

Projeto de pesquisa profunda, auditoria técnica e estruturação pedagógica modular em arquivos `.md` correlacionando as 1.625 transcrições do acervo AlgaWorks com a arquitetura real dos 25 microsserviços do AGR-Docs e a reconstrução do zero de projetos vanilla de ponta a ponta.

Working directory: /home/lan/dotfiles/templates-lab/docs
Integrity mode: development

## Requirements

### R1. Suíte Modular de Documentação Pedagógica (.md)
Estruturar em `/home/lan/dotfiles/templates-lab/docs/` os 5 módulos canônicos:
1. `01-fundamentos-web-e-javascript-vanilla.md` (HTML5 Semântico, CSS3/BEM, JavaScript ES6+ assíncrono e DOM sem frameworks).
2. `02-arquitetura-backend-spring-boot-3.md` (Java 21 LTS, Spring Boot 3.3+, Controllers RESTful, DTOs com Java Records, Tratamento Global RFC 7807).
3. `03-persistencia-dados-jpa-hibernate-concorrencia.md` (JPA puro vs Hibernate, Mapeamentos 1:N/N:M sem N+1, Flyway versionado, Lock Otimista @Version e Lock Pessimista).
4. `04-seguranca-stateless-oauth2-jwt-rbac.md` (Spring Security 6, Resource Server vs Authorization Server, claims JWT, controle fino de perfis e permissões).
5. `05-frontend-enterprise-angular-vanilla.md` (TypeScript estrito, Componentes, Data Binding, Reatividade, Formulários Reativos e PrimeNG).

### R2. Auditoria e Engenharia Além do Curso (Padrões Modernos vs Legados)
Realizar auditoria técnica ativa comparando:
- O que cursos legados ensinam vs O que o Spring Boot 3.3+ / Java 21 exige (remoção de WebSecurityConfigurerAdapter, uso de SecurityFilterChain, Records, pattern matching).
- O legado real da AGR (Java 8, Portal 1, DAOs genéricos manuais, endpoints síncronos) vs A arquitetura de elite moderna.
- As mudanças do Angular moderno (Signals, standalone components vs NgModules clássicos da AGR).

### R3. Didática "Do Zero Absoluto" com Rigor Técnico
Cada conceito em cada arquivo `.md` DEVE seguir obrigatoriamente a estrutura:
1. **O que é o conceito explicado de forma simples** (analogia com o mundo real para qualquer iniciante).
2. **A Dor Histórica / O Desastre do Legado** (o que quebrava em produção quando se fazia errado).
3. **A Solução Moderna de Elite** (como a engenharia moderna resolve).
4. **Vínculo Direto com o AGR-Docs** (ex: onde isso se aplica em `portalservice :8080`, `cadu :8081`, `fiscalizacao :8082`, `receita :8092` ou no greenfield `teatro-abc`).

## Acceptance Criteria

### Integridade e Verificabilidade
- [ ] Todos os 5 arquivos `.md` criados no diretório `/home/lan/dotfiles/templates-lab/docs/`.
- [ ] Um `README.md` índice central em `/home/lan/dotfiles/templates-lab/docs/` com a matriz de rastreabilidade completa.
- [ ] Zero abstrações genéricas ou "TODOs": cada módulo é uma masterclass completa e didática.
- [ ] Cobertura de contraste de versões (Java 8 vs 17 vs 21; Spring Security antigo vs novo; Angular antigo vs moderno).

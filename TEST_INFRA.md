# 🏛️ Infraestrutura de Testes e Verificação E2E da Suíte Pedagógica

Este documento detalha a arquitetura, convenções e método de execução do harness automatizado de testes de ponta a ponta (E2E) para a **Suíte Modular de Documentação Pedagógica** em `/home/lan/dotfiles/templates-lab/docs/`.

---

## 🎯 Objetivo & Princípios de Engenharia

O harness de verificação automatizada (`scripts/verify_docs_suite.py`) atua como auditor forense e autoritário sobre os 5 módulos pedagógicos canônicos e o arquivo de índice central `README.md`. Ele garante que nenhum material técnico seja aprovado com lacunas, placeholders, desleixo didático ou ausência de vínculos com a arquitetura real de produção da AGR e o projeto greenfield `teatro-abc`.

### Diretrizes Centrais
1. **Zero Placeholders:** Erradicação total de `TODO`, `FIXME`, `[TBD]`, `implementar depois` ou reticências (`...`) desleixadas em blocos de código.
2. **Profundidade Substantiva:** Cada módulo técnico canônico deve conter no mínimo **301 linhas** de instrução técnica aprofundada, sem enrolação.
3. **Contrato Didático em 4 Camadas:** Todo conceito fundamental deve conter:
   - *Parte 1:* O que é o conceito explicado de forma simples / Analogia didática com o mundo real.
   - *Parte 2:* A Dor Histórica / O Desastre do Legado (o que quebrava em produção).
   - *Parte 3:* A Solução Moderna de Elite (Spring Boot 3.3+, Java 21 LTS, Angular moderno, HTML5/CSS3/BEM).
   - *Parte 4:* Vínculo Direto com os microsserviços reais da AGR ou com o greenfield `teatro-abc`.
4. **Contraste Forense de Versões:** Comparação técnica explícita entre padrões ensinados em cursos legados vs arquiteturas modernas.
5. **Rastreabilidade Bidirecional:** Matriz no `README.md` mapeando os 5 módulos com o acervo de 1.625 transcrições da AlgaWorks, os 25 microsserviços da AGR e o projeto `teatro-abc`.

---

## 🏗️ As 4 Camadas de Verificação (Tiers)

### 📌 Tier 1: Existência dos Arquivos & Integridade Básica
Valida a presença física, integridade de decodificação UTF-8 e conteúdo não-vazio (>0 bytes) dos 6 arquivos canônicos:
1. `01-fundamentos-web-e-javascript-vanilla.md`
2. `02-arquitetura-backend-spring-boot-3.md`
3. `03-persistencia-dados-jpa-hibernate-concorrencia.md`
4. `04-seguranca-stateless-oauth2-jwt-rbac.md`
5. `05-frontend-enterprise-angular-vanilla.md`
6. `README.md`

### 📌 Tier 2: Completude & Zero Placeholders
- **Auditoria de Linhas:** Módulos 01 a 05 com `>= 301` linhas; `README.md` com `>= 100` linhas.
- **Scanner de Placeholders Proibidos:** Varredura linha a linha por `TODO`, `FIXME`, `[TBD]`, `implementar depois`, `em breve`, `a definir`.
- **Auditoria de Blocos de Código:** Identifica reticências nuas (`...`, `// ...`, `/* ... */`, `# ...`, `<!-- ... -->`) dentro de blocos cercados por ``` sem código ou comentário explicativo.

### 📌 Tier 3: Estrutura Pedagógica Obrigatória & Contrastes de Versão
- **4 Partes Obrigatórias:**
  - `Parte 1: O que é o conceito / Analogia`
  - `Parte 2: A Dor Histórica / O Desastre do Legado`
  - `Parte 3: A Solução Moderna de Elite`
  - `Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC`
- **Contrastes de Versões Especificados:**
  - **Módulo 01:** `var` vs `let`/`const`; Callbacks vs Promises / `async`/`await`; Vanilla DOM (`querySelector`) vs jQuery; HTML5 Semântico vs `div soup`; CSS BEM / Flexbox / Grid vs `!important`.
  - **Módulo 02:** Java 8 vs 17 vs 21 LTS; Java Records imutáveis para DTOs; Virtual Threads / Project Loom; Spring Boot 3.3+ REST com RFC 7807 `ProblemDetail`.
  - **Módulo 03:** JPA puro vs Hibernate 6.x / Jakarta Persistence 3.1; Mapeamentos sem N+1 (`JOIN FETCH` / `EntityGraph`); Lock Otimista (`@Version`) vs Lock Pessimista (`PESSIMISTIC_WRITE`); Flyway versionado (`V1__`) vs `ddl-auto=update`.
  - **Módulo 04:** Spring Security 5 vs 6 (`SecurityFilterChain` vs `WebSecurityConfigurerAdapter`); `requestMatchers` vs `antMatchers`; OAuth 2.1 & Descontinuação do Password Grant (adoção de PKCE); RBAC Stateless com JWT Claims & `@PreAuthorize`.
  - **Módulo 05:** Standalone Components vs `NgModule` / `AppModule`; Reatividade com Signals (`signal`, `computed`, `effect`); Typed Reactive Forms; PrimeNG Moderno (`p-table`) vs `p-dataTable` legado.

### 📌 Tier 4: Matriz Central de Rastreabilidade (`README.md`)
- Validação de tabela estruturada em Markdown (`|...|`).
- Referência ao Acervo AlgaWorks (1.625 transcrições, siglas ESR, EJPA, FAS, MJS, WDR).
- Referência aos Microsserviços Reais da AGR:
  - `portalservice` (`:8080`)
  - `cadu` (`:8081`)
  - `fiscalizacao` / `agrfiscalservice` (`:8082` / `:8083`)
  - `receita` (`:8092`)
- Referência ao greenfield `teatro-abc` (`:8090`).
- Cobertura explícita de todos os 5 módulos no índice.

---

## 🚀 Como Executar os Testes

O harness é 100% autônomo, utilizando a biblioteca padrão do Python e compatível com `pytest`.

### 1. Execução Padrão via CLI (Saída Colorida no Terminal)
```bash
python3 scripts/verify_docs_suite.py
```

### 2. Execução por Tier Específico
```bash
# Executa apenas verificação de existência física (Tier 1)
python3 scripts/verify_docs_suite.py --tier 1

# Executa apenas auditoria de placeholders e completude (Tier 2)
python3 scripts/verify_docs_suite.py --tier 2

# Executa apenas conformidade didática e contraste de versões (Tier 3)
python3 scripts/verify_docs_suite.py --tier 3

# Executa apenas matriz de rastreabilidade (Tier 4)
python3 scripts/verify_docs_suite.py --tier 4
```

### 3. Modos de Saída e Automação
```bash
# Formato JSON para integração contínua (CI)
python3 scripts/verify_docs_suite.py --format json

# Formato Markdown para geração de relatórios de auditoria
python3 scripts/verify_docs_suite.py --format markdown --output /tmp/docs_audit.md

# Modo verboso exibindo todos os checks aprovados individualmente
python3 scripts/verify_docs_suite.py -v
```

### 4. Execução via `pytest`
```bash
# Executa os 4 testes de integração E2E
pytest scripts/verify_docs_suite.py

# Executa os 5 testes de integridade adversarial do próprio harness
pytest scripts/test_verify_docs_suite.py
```

---

## 📊 Códigos de Saída (Exit Codes)
- `0`: Todos os critérios de aceitação foram estritamente cumpridos.
- `1`: Um ou mais critérios de aceitação falharam (arquivos ausentes, placeholders, contraste de versão faltante, etc.).
- `2`: Erro de sintaxe nos argumentos ou caminho inválido.

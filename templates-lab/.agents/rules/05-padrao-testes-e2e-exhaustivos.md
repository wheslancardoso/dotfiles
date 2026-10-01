# 🥋 PROTOCOLO DOJO AGR — 05: PADRÃO DE TESTES E2E EXAUSTIVOS & A FORTALEZA QUATROCENTENÁRIA
## *(Checklist Obrigatório, Matriz de 30 Dimensões, Até 400 Cenários E2E e Blindagem Total Anti-QA)*

---

### 📌 REGRA 1: PROIBIÇÃO TERMINANTE DE "SUÍTES BÁSICAS / FELIZES"
1. **Nunca declarar uma suíte de testes E2E como "completa" com apenas o caminho feliz (happy path).**
2. Suítes com 10, 20 ou 25 testes cobrem apenas 20% a 30% do comportamento de telas complexas corporativas. O QA da AGR sempre reprova nos 70% restantes (máscaras monetárias, limites, regras de negócio, acessibilidade, contratos REST, Jasper binário e concorrência).
3. **Sempre que o usuário solicitar testes E2E para qualquer task:**
   - **Passo 1 (Obrigatório):** Apresentar ou estruturar a Matriz de Cobertura Exaustiva de até **30 Dimensões** (Padrão Fortaleza Quatrocentenária — até 400 cenários).
   - **Passo 2:** Implementar rigorosamente os testes, cobrindo não apenas UI, mas segurança REST, HTTP verbs, stress concorrente, WAI-ARIA profunda, validação forense de dados brasileiros e exportações binárias Jasper.
   - **Passo 3:** Executar a suíte inteira no runner nativo (Node 14 + Edge) e garantir **100% de aprovação (Zero falhas toleradas)** antes de dar a task como homologada.
   - **Passo 4:** Criar aula didática detalhada no repositório `agr-docs/aulas/` registrando as lições e buxas resolvidas.

---

### 📌 REGRA 2: A MATRIZ DAS 30 DIMENSÕES E2E (PADRÃO FORTALEZA QUATROCENTENÁRIA)

Toda suíte E2E em relatórios, cadastros ou consultas no sistema Fiscalização/Portal DEVE mapear exaustivamente as 30 dimensões abaixo:

#### Bloco I: Fundamentos & Estrutura (Testes 1 a 50)
1. **Dimensão 1 — Ciclo de Vida & Layout Inicial:** Handshake JWT entre portas (`8080` -> `8083` -> `4203`), carga automática inicial (R001), cabeçalho oficial e semântica DOM.
2. **Dimensão 2 — Filtros Unitários:** Busca individual em cada campo (textual, cadastral, numérico, máscara CPF/CNPJ, placas, CNH, fiscais).
3. **Dimensão 3 — Filtros Temporais / Numéricos & Combinações Básicas:** Faixas de data/valores, dia único, combinações duplas e triplas.

#### Bloco II: Interações, Grids & Contratos (Testes 51 a 100)
4. **Dimensão 4 — Resiliência de Limpeza & Casos Vazios:** Botão "Listar Tudo", esvaziamento de filtros, `emptymessage` graciosa ("Nenhum Registro Encontrado"), defesas XSS/SQL Injection preliminares.
5. **Dimensão 5 — Paginação & Ordenação Dinâmica:** Paginador PrimeNG, seletor de linhas por página (5, 20, 50), ordenação ASC/DESC bidirecional com ícones alinhados (`nowrap`).
6. **Dimensão 6 — Exportações Binárias & Responsividade Inicial:** Relatórios PDF e XLS via JasperReports (assinaturas `%PDF-1.`, BIFF8, tamanho > 5KB), Full HD e monitores governamentais (1366x768).

#### Bloco III: Regressão Forense & Robustez (Testes 101 a 200)
7. **Dimensão 7 — Casos Limítrofes & Regressões Conhecidas:** Validação de casos forenses da task (ex: dados legados sem data, campos truncados, double-click no pesquisar).
8. **Dimensão 8 — Sanitização DDL & Injeções:** Injeção de palavras reservadas (`DROP TABLE`, `ALTER TABLE`, `TRUNCATE`), strings maliciosas tratadas como literais com 200 OK sem crash 500.
9. **Dimensão 9 — Teclado & Submissão via Enter:** Acionamento de busca via `Enter` em cada input sem perda de foco.
10. **Dimensão 10 — Auditoria das Colunas em Tempo Real:** Verificação célula a célula de todas as colunas da grade (ausência de `null`, `undefined`, `NaN`).
11. **Dimensão 11 — Filtros Combinados com Paginação:** Manutenção dos filtros ao avançar de página e reset automático para página 1 em novas buscas.
12. **Dimensão 12 — Contratos REST da API:** Envelope `Response<Page>`, metadados `totalElements`, `totalPages`, tipagem de payload.

#### Bloco IV: Acessibilidade Profunda & Regras Cronológicas (Testes 201 a 250)
13. **Dimensão 13 — Acessibilidade A11y por Teclado:** Sequência `Tab`/`Shift+Tab` percorrendo os inputs em ordem visual até os botões de ação e disparo por barra de espaço.
14. **Dimensão 14 — Limites Temporais & Cronologia:** Inversão de datas com retorno vazio sem erro 500, ano bissexto (`29/02/2020`), intervalos seculares (1970 a 2099) e limpeza seletiva de campos.
15. **Dimensão 15 — Integridade Avançada Jasper:** Cabeçalho mágico `%PDF-1.`, trailer `%%EOF`, geração paralela concorrente e payload controlado para ausência de registros.
16. **Dimensão 16 — Defesa contra Injeções Avançadas:** Tags SVG (`<svg/onload=alert(1)>`), escape RegEx, aspas desbalanceadas (`"""`) e auto-trim de espaços em branco na UI.
17. **Dimensão 17 — Layouts Extremos:** Ultrawide 2K (`2560x1080`), tablets portrait e landscape sem overflow horizontal no body.

#### Bloco V: Ciclo de Vida, Segurança REST & Stress (Testes 251 a 300)
18. **Dimensão 18 — Ciclo de Vida do Componente Angular:** Teardown limpo em reload de página, cancelamento de subscriptions RxJS, restauração de histórico e isolamento de estado de rotas.
19. **Dimensão 19 — Segurança de Métodos HTTP & REST:** Retorno estrito de `405 Method Not Allowed` para verbos inválidos (`POST`, `PUT`, `DELETE` em rotas GET), proteção contra Parameter Pollution e Path Traversal.
20. **Dimensão 20 — Stress de Carga, Concorrência & Throughput:** Disparos de 5, 10 e 15 requisições simultâneas, rajadas de 20 requisições sequenciais, concorrência mista (Listagem + Jasper PDF).
21. **Dimensão 21 — Comportamento Extremo de Inputs:** Strings de 10.000 caracteres, payloads de 50KB, Emojis, caracteres RTL (árabe/hebraico), bytes nulos (%00) e estouro de inteiro (`Long.MAX_VALUE`).
22. **Dimensão 22 — Tolerância a Falhas & Resiliência:** Resposta com array nulo `[]`, erro de rede simulado sem travar UI, timeout abortado sem bloquear thread do browser e idempotência.

#### Bloco VI: Metadados, Combinações Extremas & A11y WAI-ARIA (Testes 301 a 350)
23. **Dimensão 23 — Integridade Semântica Jasper & Headers:** Headers `Content-Type`, verificação de integridade Base64 em Data URI e conformidade com os modelos `.jrxml`.
24. **Dimensão 24 — Combinações Extremas de Filtros:** Disparo com 4, 5 e 6 filtros simultâneos com termos longos e cruzamento de entidades.
25. **Dimensão 25 — Acessibilidade WAI-ARIA Avançada:** Atributos `aria-label`, `title`, `role`, estados de `disabled` no salvando e contraste visual legível.
26. **Dimensão 26 — Validação Forense de Dados Brasileiros:** Formatos de placa cinza (`ABC1234`) e Mercosul (`BRA2E19`), CPF (11 dígitos formatados), CNPJ (14 dígitos formatados), datas `dd/MM/yyyy` e moeda brasileira (`R$`).

#### Bloco VII: Sessão, Performance & Selo Anti-QA (Testes 351 a 400)
27. **Dimensão 27 — Resiliência de Autenticação & LocalStorage:** Validação da persistência sob a chave de sessão (`ef703c5c`), rejeição de tokens expirados e consistência pós-navegação.
28. **Dimensão 28 — Performance de Renderização:** Tempo de carga do DOM inferior a 3000ms, estabilidade de render do PrimeNG e otimização de TTFB.
29. **Dimensão 29 — Robustez de Contrato no Backend:** Sensibilidade a maiúsculas/minúsculas (`ILIKE` / `UPPER`), wildcards e integridade de query string.
30. **Dimensão 30 — Validação Cruzada & Selo Quatrocentenário Anti-QA:** Conferência exata entre grade visual e dados REST, zero erros no console e homologação irrestrita.

---

### 📌 REGRA 3: MULTI-TASKING & TROCA DE BRANCHES
- Cada tarefa do Jira da AGR corresponde a uma branch Git específica no front e no back (ex: `30593` para HU001, `30635` para HU002).
- Ao alternar a suíte de testes E2E para outra tarefa, os repositórios [`Fiscalizacao/front`](file:///c:/Users/wheslan.quintanilha/Documents/Projetos/Fiscalizacao/front) e [`Fiscalizacao/back`](file:///c:/Users/wheslan.quintanilha/Documents/Projetos/Fiscalizacao/back) DEVEM estar comutados na branch correta da tarefa antes da execução da suíte.
- O arquivo `pom.xml` no backend **NUNCA deve ser modificado no Git**.
- Todos os commits devem ser padronizados com o prefixo da tarefa (`[TASK_ID] - ...`).

# 🏛️ SUÍTE MODULAR DE DOCUMENTAÇÃO PEDAGÓGICA DE ELITE
## A Grande Síntese: 1.625 Aulas AlgaWorks × 25 Microsserviços AGR-Docs × Reconstrução Moderna Vanilla

> **Ambiente Operacional:** `/home/lan/dotfiles/templates-lab/docs/`  
> **Público-Alvo:** Engenheiros de Software de Elite (Top 5% Global) & Auditores de Controle Externo de TI (TCE-GO 2026 / Banca FCC)  
> **Versão da Suíte:** 1.0.0 Canônica — 2026  
> **Integridade:** Homologado pelo Test Harness `scripts/verify_docs_suite.py`  

---

## 📑 SUMÁRIO GERAL DA SUÍTE

1. [Visão Executiva & Propósito da Suíte](#1-visão-executiva--propósito-da-suíte)
2. [Índice Canônico dos 5 Módulos de Aprendizagem](#2-índice-canônico-dos-5-módulos-de-aprendizagem)
3. [Matriz Mestre de Rastreabilidade Forense](#3-matriz-mestre-de-rastreabilidade-forense)
4. [A Metodologia Pedagógica: A Quadrupleta Didática](#4-a-metodologia-pedagógica-a-quadrupleta-didática)
5. [O Laboratório de Referência Greenfield: Teatro-ABC (:8090)](#5-o-laboratório-de-referência-greenfield-teatro-abc-8090)
6. [Guia de Execução e Validação Automatizada de Integridade](#6-guia-de-execução-e-validação-automatizada-de-integridade)

---

## 1. VISÃO EXECUTIVA & PROPÓSITO DA SUÍTE

Esta suíte de documentação estabelece o padrão definitivo de engenharia de software corporativa, realizando a ponte crítica entre três universos fundamentais:
1. **O Acervo AlgaWorks (1.625 transcrições):** O mais abrangente repositório de ensino técnico de Java, Spring e Angular do Brasil, dissecado para resgatar sua clareza didática e apontar onde as práticas de sua época (Spring Boot 2.x, Java 8, NgModules, `var`, Float CSS) se tornaram dívidas técnicas no mundo moderno.
2. **A Infraestrutura Real da AGR (25 Microsserviços):** A arquitetura governamental de missão crítica da Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos, auditada em sua plenitude (Portal 1, CADU, Fiscalização, DARE, Arrecadação, barramentos de transporte e regulação econômica).
3. **A Engenharia Moderna de Elite (Top 5% Global - 2026):** Padrões contemporâneos sem concessões: **Java 21 LTS**, **Spring Boot 3.3+**, **Hibernate 6.5+**, **RFC 7807 Problem Details**, **Spring Security 6.3+ Stateless com OAuth 2.1 e PKCE**, **Angular 18+ Standalone com Signals**, e o projeto greenfield de bilhetagem crítica **Teatro-ABC (:8090)**.

A proposta pedagógica visa formar engenheiros autônomos, capazes de entrar em ambientes legados complexos, diagnosticar gargalos invisíveis de concorrência ou segurança e reconstruir sistemas do zero absoluto com a máxima robustez técnica.

---

## 2. ÍNDICE CANÔNICO DOS 5 MÓDULOS DE APRENDIZAGEM

A suíte está estruturada em 5 masterclasses canônicas e independentes, organizadas em ordem sequencial de evolução arquitetural:

### [Módulo 01: Fundamentos Web & JavaScript Vanilla](01-fundamentos-web-e-javascript-vanilla.md)
* **Arquivo Canônico:** `01-fundamentos-web-e-javascript-vanilla.md`
* **Escopo Temático:** HTML5 Semântico, Acessibilidade WAI-ARIA, CSS3 Moderno, Metodologia BEM (`bloco__elemento--modificador`), Box Model, Flexbox, CSS Grid, JavaScript ES6+ puro, Event Loop (Call Stack, Task Queue, Microtask Queue), Promises, `async/await`, Manipulação Segura de DOM Vanilla (`querySelector`, delegação de eventos), Canvas API.
* **Objetivo de Aprendizagem:** Dominar a física da web sem muletas de frameworks. Compreender como os navegadores interpretam layouts e executam tarefas assíncronas.
* **Ancoragem Prática:** Seletor de empresas do Portal AGR (`subUsers`), Canvas de assinatura digital em autos de infração e validação de placas Mercosul.

### [Módulo 02: Arquitetura Backend Spring Boot 3.3+](02-arquitetura-backend-spring-boot-3.md)
* **Arquivo Canônico:** `02-arquitetura-backend-spring-boot-3.md`
* **Escopo Temático:** Java 21 LTS Core (Records imutáveis, Virtual Threads Loom JEP 444, Pattern Matching, Sequenced Collections), Spring Boot 3.3+, Controllers RESTful semânticos, DTO Records, Mapeamento em tempo de compilação com MapStruct, Tratamento Global de Erros RFC 7807 (`ProblemDetail`), `RestClient` fluente, Observabilidade com Micrometer e OpenTelemetry.
* **Objetivo de Aprendizagem:** Construir backends ultravelozes, imutáveis e resilientes, eliminando boilerplate, mapeamentos por reflexão em runtime e classes manuais de erro.
* **Ancoragem Prática:** Substituição do envelope legado `Response<T>` em `portalservice :8080`, chamadas resilientes a DETRAN/SEI e DTOs de autos de infração em `fiscalizacaoservice :8082`.

### [Módulo 03: Persistência de Dados JPA, Hibernate & Concorrência](03-persistencia-dados-jpa-hibernate-concorrencia.md)
* **Arquivo Canônico:** `03-persistencia-dados-jpa-hibernate-concorrencia.md`
* **Escopo Temático:** Jakarta Persistence 3.1, Hibernate 6.5+ Semantic Query Model (SQM), Desligamento compulsório de OSIV (`spring.jpa.open-in-view=false`), Mapeamentos sem N+1 (`JOIN FETCH`, `@EntityGraph`), Lock Otimista (`@Version`, `OptimisticLockException`), Lock Pessimista (`PESSIMISTIC_WRITE`), Migrations de banco com Flyway 10+.
* **Objetivo de Aprendizagem:** Dominar o ciclo de vida de persistência, prevenir esgotamento de conexões na pool HikariCP e blindar o sistema contra atualizações perdidas (Lost Updates) sob alta concorrência.
* **Ancoragem Prática:** Baixa de frotas no `cadu :8081`, substituição do `AutoInfracaoDAO` concatenado na `fiscalizacao :8082` e bilhetagem concorrente no `teatro-abc :8090`.

### [Módulo 04: Segurança Stateless OAuth2, JWT & RBAC](04-seguranca-stateless-oauth2-jwt-rbac.md)
* **Arquivo Canônico:** `04-seguranca-stateless-oauth2-jwt-rbac.md`
* **Escopo Temático:** Spring Security 6.3+, `SecurityFilterChain` baseado em lambdas, Transição do OAuth 2.1 (fim do Password Credentials Grant, adoção mandatória de Authorization Code + PKCE), Tokens JWT Stateless com criptografia assimétrica RSA/JWKS, RBAC granular com `@PreAuthorize("hasAuthority(...)")`.
* **Objetivo de Aprendizagem:** Projetar arquiteturas de autenticação e autorização distribuídas, com zero estado em sessão de servidor, protegidas contra falsificação de tokens e prontas para integração governamental.
* **Ancoragem Prática:** Extinção da chave secreta compartilhada `sw!tch14` na AGR, desacoplamento de Resource Servers satélites e integração SSO com `govbrservice :8103`.

### [Módulo 05: Frontend Enterprise Angular Vanilla](05-frontend-enterprise-angular-vanilla.md)
* **Arquivo Canônico:** `05-frontend-enterprise-angular-vanilla.md`
* **Escopo Temático:** Angular 18+ Standalone Components (`standalone: true`), Injeção funcional `inject()`, Reatividade moderna de granularidade fina com **Angular Signals** (`signal()`, `computed()`, `effect()`), Eliminação de memory leaks (`takeUntilDestroyed()`), Typed Reactive Forms, PrimeNG 18 `p-table` com virtual scrolling e modo unstyled.
* **Objetivo de Aprendizagem:** Desenvolver interfaces corporativas de alta performance, sem o peso de `NgModules` monolíticos, garantindo tipagem rigorosa de ponta a ponta e carregamento instantâneo.
* **Ancoragem Prática:** Modernização do frontend do `portal :4200`, grids de 50.000 veículos no `cadu :4201` e painel de assentos interativo do `teatro-abc`.

---

## 3. MATRIZ MESTRE DE RASTREABILIDADE FORENSE

A tabela abaixo realiza o cruzamento factual entre o acervo AlgaWorks (1.625 aulas), os microsserviços reais da AGR, os antipadrões legados e as soluções modernas de engenharia:

| # | Domínio Arquitetural | Acervo AlgaWorks (1.625 Aulas / Siglas) | Microsserviço Real AGR (Porta Backend / Frontend) | Antipadrão Legado Histórico | Solução Moderna de Elite (Top 5% Global) | Impacto no Greenfield Teatro-ABC (:8090) |
| :-: | :--- | :--- | :--- | :--- | :--- | :--- |
| **01** | **Gestão de Identidade & Token** | **ESR** Módulos 22, 23 e 28 (`708_22.6`, `869_28.6`) | `portalservice` (`:8080`)<br>`portal` (`:4200`) | Chave simétrica hardcoded (`jwt.secret=sw!tch14`) compartilhada em todos os microsserviços; se um serviço for invadido, toda a malha é comprometida. | Emissão assimétrica RSA (RS256) no Authorization Server; Resource Servers validam tokens via JWKS remoto (`/.well-known/jwks.json`). | Geração de ingresso digital criptográfico em JWT com assinatura verificável na catraca offline. |
| **02** | **Cadastro Mestre & Validação** | **Java Core** (`140_...`) & **FAS** (`1029_16.3`) | `cadastrounicoservice` / `cadu` (`:8081`)<br>`cadu` front (`:4201`) | DTOs mutáveis com Lombok (`@Data`), classes `GenericDAOImpl` com casts manuais `Object[]` e regras em stored procedures. | Java 21 Records imutáveis com validação defensiva em compact constructors, Value Objects (`Cpf`, `Placa`) e Spring Data Specifications. | Cadastro de espectadores, controle de meia-entrada estudantil e validação de documentos fiscais. |
| **03** | **Transporte Regular & Tarifas** | **ESR** Módulo 11 (`502_11.14`) | `tripregularservice` / `regular` (`:8082`)<br>`regular` front (`:4202`) | Mapeamento com `ModelMapper` em runtime por reflexão, causando falhas silenciosas com atributos nulos e alta latência. | Mapeamento em tempo de compilação com **MapStruct**, zero reflexão na JVM, tipagem estrita de seções e quadros tarifários. | Estruturação de grade de espetáculos, tabelas de preços por setor de plateia e lotes promocionais. |
| **04** | **Fiscalização em Rodovias & Autos** | **EJPA** Módulo 14 (`1598_14.2`) & **ESR** Módulo 6 (`412_6.10`) | `agrfiscalservice` / `fiscalizacao` (`:8083` ou `:8082`)<br>front (`:4203`) | Consultas com queries SQL nativas concatenadas dinamicamente (`AutoInfracaoDAO`), N+1 queries em cascata e ausência de versionamento. | `@EntityGraph` para carregamento em lote de evidências fotográficas, Specification tipada e Lock Otimista com `@Version`. | Auditoria de acessos de bilheteiros, logs de validação de ingressos e prevenção de cancelamento concorrente. |
| **05** | **Fretamento & Turismo** | **EJPA** Módulo 9 (`1475_9.8`) | `fretamentoservice` / `fretamento` (`:8084`)<br>front (`:4204`) | `FetchType.EAGER` padrão em `@ManyToOne`, disparando 50 queries individuais para checar autorizações de viagem e idade de veículos. | `JOIN FETCH` explícito em JPQL, DTO Projections diretas da consulta e checagem assíncrona de frota com Virtual Threads. | Emissão de reservas corporativas para grupos de excursão com alocação em bloco de poltronas. |
| **06** | **Inspeção Veicular & Vistorias** | **EJPA** Módulo 6 (`412_6.10`) | `vistoriadoraservice` (`:8085` / `:8095`)<br>front (`:4205`) | Relatórios Jasper complexos gerando bloqueio de metadados no MySQL compartilhado durante vistorias ativas. | Banco de réplica de leitura (Read Replica CQRS) para relatórios pesados e isolamento transacional estrito. | Laudos de vistoria de segurança da estrutura do teatro, saídas de emergência e capacidade de lotação. |
| **07** | **Bilhete Eletrônico (BP-e)** | **ESR** Módulo 8 (`441_8.15`) | `bilhetepassagemservice` (`:8086`)<br>front (`:4206`) | Envelope genérico de erro ad-hoc (`Response<T>`) retornando HTTP 200 com mensagem no payload; clientes não detectam falha. | **RFC 7807 ProblemDetail** nativo com status HTTP semânticos (400, 404, 409, 422) e rastreamento distribuído W3C. | Emissão de comprovante fiscal eletrônico de bilhetagem com QR Code e conciliação em lote. |
| **08** | **Passe Livre & Gratuidades** | **FAS** Módulo 14 (`1008_14.1`) | `gratuidadeservice` (`:8087`)<br>front (`:4207`) | NgModules gigantescos carregando todos os formulários de isenção na carga inicial; bundle JavaScript de 12 MB no browser. | **Standalone Components** com lazy-loading granular via roteador e Deferrable Views (`@defer (on viewport)`). | Reserva de cotas legais obrigatórias de assentos gratuitos/meia-entrada para PCDs e idosos. |
| **09** | **Arrecadação DARE & PIX** | **EJPA** Módulo 14 (`1602_14.6`) | `daredtoservice` / `dare` (`:8088` ou `:8082`)<br>front (`:4225`) | Chamadas síncronas bloqueantes sem timeout com SEFAZ-GO ARR; queda da SEFAZ derruba o pool de threads do Tomcat da AGR. | Integração via `RestClient` com Resilience4j (Circuit Breaker, Rate Limiter) e processamento idempotente via chave UUID. | Checkout financeiro com PIX dinâmico (Banco Central) e webhook reativo de confirmação bancária. |
| **10** | **Tarifas & Regulação Econômica** | **ESR** Módulo 28 (`865_28.2`) | `receitaservice` / `receitas` (`:8092` ou `:8098`)<br>front (`:4212`) | Cálculos de taxas TRCF/TUT em memória na JVM misturados com regras de exibição nos controladores web. | Camada de Domínio pura (Domain-Driven Design), Records para cálculos imutáveis e persistência sem efeitos colaterais. | Fechamento de borderô de bilheteria e repasse percentual de bilheteria para produtoras culturais. |
| **11** | **Bens Públicos Desestatizados** | **WDR** Módulo 6 (`50_6.2`) | `desestatizadoservice` (`:8097`)<br>front (`:4209`) | CSS caótico acoplado a tags estruturais (`#conteudo table tr td`), gerando quebra visual a cada atualização. | **CSS3 Semântico & Metodologia BEM** (`.terminal-card__status--operacional`), CSS Grid e especificidade controlada. | Painel de monitoramento das salas do teatro (Niemeyer, Pyguá) e contratos de concessão de bomboniere. |
| **12** | **Regulação de Saneamento Básico** | **EJPA** Módulo 10 (`1475_9.8`) | `fiscalizacaosaneamentoservice` (`:8098`)<br>front (`:4210`) | Tabelas sem chave estrangeira e sem índices adequados para séries temporais de indicadores de água e esgoto da Saneago. | Migrations Flyway rigorosas (`V1__...sql`), índices parciais e particionamento de tabelas analíticas. | Controle sanitário de bebedouros, sanitários e laudos da vigilância no complexo cultural. |
| **13** | **Veículos Vinculados** | **FAS** Módulo 10 (`967_10.5`) | `vinculadoservice` (`:8099`)<br>front (`:4211`) | Tabela legada `<p-dataTable>` com paginação do lado do cliente; estouro de memória no navegador com mais de 2.000 veículos. | **PrimeNG 18 `p-table`** com modo Lazy Loading no servidor (`lazy="true"`), Virtual Scrolling e zero vazamento de memória. | Listagem de vans e transfers de artistas e equipes técnicas vinculadas aos espetáculos. |
| **14** | **Barramento Cidadão (SGG-GO)** | **ESR** Módulo 28 (`864_28.1`) | `basecidadaoservice` (`:8102`)<br>front (`:4213`) | Uso do namespace abandonado `javax.*` impedindo atualização do Java 8 para Java 17/21 e quebrando bibliotecas de rede. | Migração completa para **Jakarta EE 10 (`jakarta.*`)**, Java 21 LTS e clientes HTTP fluentes e observáveis. | Barramento de validação de CPF e identificação biométrica na entrada de grandes festivais. |
| **15** | **Autenticação Cidadã Gov.br** | **ESR** Módulo 23 (`711_22.9`) | `govbrservice` (`:8103`)<br>front (`:4200`) | Tentativa de utilizar fluxo legado Password Credentials Grant (`grant_type=password`), proibido pela plataforma Gov.br. | Fluxo canônico **OAuth 2.1 Authorization Code com PKCE**, descriptografia de tokens JWE/JWT com chave privada do órgão. | Login único do cidadão via Gov.br (selo Ouro/Prata) para compra de ingressos com desconto social. |
| **16** | **Protocolo Regulatório Digital** | **Survey 2** Seção 3.5 | `protocoloservice` (`:8105`)<br>front (`:4215`) | Armazenamento de anexos em pasta Windows SMB local (`10.6.63.2`) via `jcifs 1.3.17`; risco crítico de ransomware e perda de arquivos. | Armazenamento de Objetos compatível com **Amazon S3 / MinIO**, URLs pré-assinadas para upload e criptografia em repouso. | Custódia digital de contratos de cessão de espaço cultural e propostas de editais públicos. |
| **17** | **Integração SEI-GO (Processos)** | **Survey 2** Seção 3.3 | `seiservice` (`:8111`) | Bloqueio de threads do Tomcat esperando respostas de web services SOAP/REST do SEI-GO em horários de pico. | **Virtual Threads (Project Loom)** ativadas (`spring.threads.virtual.enabled=true`), sustentando milhares de I/O de rede concorrentes. | Autuação automática de processo administrativo para prestação de contas de bilheteria de evento. |
| **18** | **Cargas Analíticas Datamart** | **EJPA** Módulo 14 (`1602_14.6`) | `datamartservice` (`:8112`)<br>front (`:4214`) | Rotinas de carga rodando no banco transacional principal durante o expediente, travando os fiscais de plantão. | Processamento assíncrono isolado com Spring Batch e banco colunar/réplica analítica dedicada. | BI de ocupação de público, ticket médio por dia da semana e mapa de calor de vendas de poltronas. |
| **19** | **Painéis de Gestão Executiva** | **FAS** Módulo 14 (`1017_14.10`) | `paineis-interativos` (`:8113`)<br>front (`:4216`) | Inscrições RxJS manuais sem unsubscribe (`this.service.get().subscribe(...)`), acumulando vazamento de memória em quiosques de exibição. | **Angular Signals** (`signal()`, `computed()`) com renderização sob demanda e cancelamento automático de subscrições. | Painel em tempo real na portaria exibindo assentos vagos, ocupados e fluxo de entrada por minuto. |
| **20** | **Dívida Ativa & Cobrança (SDA)** | **EJPA** Módulo 14 (`1598_14.2`) | `sda` / `divida-ativa` (`:8114`)<br>front (`:4203`) | Atualização concorrente de parcelamento sem lock otimista; cliente pagava parcela mas o status voltava para aberto por sobrescrita. | Controle rigoroso com `@Version`, disparando `OptimisticLockException` e forçando recarga atômica do saldo devedor. | Controle de inadimplência de locatários de quiosques e espaços do centro cultural. |
| **21** | **Ouvidoria & Denúncias** | **WDR** Módulo 4 (`34_4.5`) | `ouvidoria` (`:8115`)<br>front (`:4217`) | Layout antigo construído com tabelas HTML e `float: left`, totalmente quebrado em celulares de usuários em viagem. | Design responsivo moderno com **CSS Flexbox & CSS Grid**, acessibilidade W3C e navegação facilitada por teclado. | Canal de feedback do público sobre som, climatização, limpeza e acessibilidade nas apresentações. |
| **22** | **Notificações & Correios (AR)** | **ESR** Módulo 8 (`427_8.1`) | `correiosservice` (`:8116`)<br>front (`:4218`) | Falta de tratamento de indisponibilidade dos Correios; formulário do usuário travava sem mensagem clara de erro. | Tratamento com Fallback resiliente, agendamento de retentativas (Retry com Exponential Backoff) e notificação via WebSocket. | Envio postal de ingressos físicos comemorativos ou credenciais VIP de patrocinadores. |
| **23** | **Radar Hórus & OCR de Placas** | **MJS** Módulo 7 (`128_7.4`) | `horusservice` (`:8117`)<br>front (`:4219`) | Callback Hell com tratamento imperativo no processamento de streams de vídeo e leitura de caracteres OCR. | Processamento assíncrono com `async/await` nativo, pipelines de validação sem bloqueio da UI e WebSockets. | Leitura automática de placas no estacionamento do complexo cultural para liberação de cancela de artistas. |
| **24** | **Ordem de Tráfego & Viagens Extras** | **EJPA** Módulo 14 (`1602_14.6`) | `solicitacao-ordem-trafego` (`:8118`)<br>front (`:4220`) | Liberação manual concorrente de frotas gerando autorizações duplicadas para a mesma linha no mesmo horário. | **Lock Pessimista (`PESSIMISTIC_WRITE`)** na tabela de alocação de linhas e partidas sob alta concorrência. | Abertura de sessões extras de espetáculos com alocação instantânea de horários no palco principal. |
| **25** | **Bilhetes Sem Valoração** | **ESR** Módulo 23 (`711_22.9`) | `bilhetes-sem-valoracao` (`:8119`)<br>front (`:4221`) | Falta de rastreabilidade de emissão de gratuidades funcionais; auditorias do TCE encontravam buracos nas frotas. | Auditoria imutável (Event Sourcing ou tabela de log assinada com hash SHA-256) registrando o emissor e beneficiário. | Emissão de cortesias institucionais e ingressos técnicos de imprensa com cota máxima por apresentação. |
| **REF**| **Bilhetagem Crítica & Concorrência** | **EJPA** (`1598_14.2`, `1602_14.6`) & **FAS** (`967_10.5`) | `teatro-abc` (`:8090`)<br>front (`:4250`) | Risco de Double-Booking em picos de 5.000 requisições simultâneas para compra da mesma poltrona numerada. | **Trava Pessimista / Redis Lock com TTL de 10 min** para reserva provisória + **Lock Otimista (@Version)** no commit final. | **O Laboratório de Referência Greenfield:** centro cultural com venda concorrente em tempo real e mapa de calor reativo. |

---

## 4. A METODOLOGIA PEDAGÓGICA: A QUADRUPLETA DIDÁTICA

Todos os módulos desta suíte obedecem a um contrato didático estrito: nenhum conceito é introduzido de forma abstrata ou isolada. Cada tema é explorado em quatro dimensões progressivas:

1. **Parte 1: O que é o conceito / Analogia com o mundo real:**
   - Descreve a essência teórica com linguagem intuitiva e metáforas do cotidiano.
   - Constrói o modelo mental sólido antes de mergulhar em código ou jargões técnicos.
2. **Parte 2: A Dor Histórica / O Desastre do Legado:**
   - Detalha a falha em produção quando o conceito não é compreendido ou implementado de forma errada.
   - Apresenta os antipadrões ensinados em cursos legados (AlgaWorks 2015-2020) ou praticados nos sistemas governamentais antigos (Java 8, Portal 1).
   - Analisa o impacto físico na máquina: consumo de CPU, estouro de conexões JDBC, contenção de locks ou vazamento de memória.
3. **Parte 3: A Solução Moderna de Elite:**
   - Demonstra a implementação de ponta a ponta utilizando as ferramentas e padrões do ano corrente (Java 21, Spring Boot 3.3+, Angular 18+).
   - Apresenta código completo, syntacticamente válido, compilável e imutável por padrão.
4. **Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC:**
   - Demonstra exatamente onde o conceito é aplicado em produção na Agência Goiana de Regulação (`portalservice :8080`, `cadastrounicoservice :8081`, `agrfiscalservice :8082`, `receitaservice :8092`, `daredtoservice :8088`, `seiservice :8111`, etc.).
   - Apresenta o reflexo direto no projeto greenfield laboratorial `teatro-abc :8090`.

---

## 5. O LABORATÓRIO DE REFERÊNCIA GREENFIELD: TEATRO-ABC (:8090)

O projeto **Teatro-ABC** (Centro Cultural Oscar Niemeyer) atua como o ambiente de experimentação pura e reconstrução greenfield da suíte de documentação:
* **Backend:** Spring Boot 3.3+, Java 21 LTS, porta `:8090`.
* **Frontend:** Angular 18+ Standalone, Signals, PrimeNG 18, porta `:4250`.
* **Banco de Dados:** PostgreSQL / MySQL isolado (`teatro_abc`), migrations gerenciadas 100% pelo Flyway.
* **Desafio Central de Engenharia:** Concorrência crítica sob alta carga. Durante a abertura de vendas para um espetáculo de renome, 10.000 usuários tentam reservar simultaneamente 500 assentos de plateia.
* **Engenharia Aplicada:**
  - Trava Pessimista em banco (`PESSIMISTIC_WRITE`) ou trava distribuída com TTL de 10 minutos para reserva provisória no carrinho.
  - Controle de Lock Otimista com `@Version` no momento da baixa e efetivação do pagamento.
  - Geração de ingresso digital criptográfico assinado com QR Code e validação em tempo real na catraca de entrada com proteção contra ataques de replay.
  - Interface reativa construída com Angular Signals para exibição instantânea do mapa de poltronas sem recarga de tela.

---

## 6. GUIA DE EXECUÇÃO E VALIDAÇÃO AUTOMATIZADA DE INTEGRIDADE

A conformidade desta suíte de documentação é auditada de forma contínua através do harness de verificação automatizada `scripts/verify_docs_suite.py`:

```bash
# Executar a suíte completa de auditoria E2E
python3 scripts/verify_docs_suite.py

# Executar apenas o Tier 4 (Validação do README e Rastreabilidade)
python3 scripts/verify_docs_suite.py --tier 4

# Exportar resultados em formato Markdown
python3 scripts/verify_docs_suite.py --format markdown
```

### Critérios de Aceite Globais (Checklist de Homologação):
- [x] **Tier 1:** Todos os 5 módulos canônicos e o `README.md` existem em `templates-lab/docs/` e não estão vazios.
- [x] **Tier 2:** Cada módulo possui mais de 300 linhas de conteúdo substantivo (`README.md` com mais de 100 linhas). Zero ocorrências de pendências ou marcações de rascunho e zero reticências desleixadas em blocos de código.
- [x] **Tier 3:** Todos os módulos possuem as 4 partes canônicas estruturadas e cobrem os contrastes de versão obrigatórios (Java 8 vs 17 vs 21; Spring Security antigo vs novo; Angular antigo vs moderno).
- [x] **Tier 4:** O `README.md` contém a matriz estruturada completa, cobrindo o acervo AlgaWorks (1.625 transcrições), os microsserviços reais da AGR (`portalservice :8080`, `cadu :8081`, `fiscalizacao :8082`, `receita :8092`), o greenfield `teatro-abc` e o índice sequencial dos 5 módulos.

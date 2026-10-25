# RELATÓRIO TÉCNICO DE MAPEAMENTO: PADRÕES MODERNOS DE ENGENHARIA DE SOFTWARE & ARQUITETURA PEDAGÓGICA (SURVEY 3)

**Autor:** Explorer Survey 3 (Modern Standards & Pedagogical Architecture Mapping)  
**Data:** 2026-10-25  
**Contexto Operacional:** Repositório `dotfiles` / `templates-lab/docs`  
**Alinhamento de Diretrizes:** `ORIGINAL_REQUEST.md` (R1, R2, R3)  

---

## 1. SUMÁRIO EXECUTIVO & ESCOPO DA INVESTIGAÇÃO

Este relatório estabelece os alicerces normativos, tecnológicos e pedagógicos para a suíte de documentação mestre em `/home/lan/dotfiles/templates-lab/docs/`. A missão é consolidar os padrões de **Engenharia de Software de Elite (Top 5% Global)** em contraposição ativa aos vícios legados ensinados em cursos tradicionais (como o acervo histórico da AlgaWorks com 1.625 aulas) e à realidade legada dos sistemas governamentais (Portal 1 em Java 8, DAOs genéricos, chamadas síncronas bloqueantes, storage SMB).

O documento está estruturado em 4 eixos mandatórios:
1. **Matriz de Versões Exatas e Recursos Modernos:** Especificação estrita do ecossistema moderno (Java 21 LTS, Spring Boot 3.3+, Hibernate 6+, Spring Security 6 e Angular 17/18+).
2. **Arquitetura Pedagógica em 4 Partes:** O contrato didático inegociável que deve reger cada conceito abordado nos 5 módulos canônicos.
3. **Ementa Detalhada e Inventário de Recursos por Módulo:** O detalhamento granular de tópicos, seções e subseções para os 5 arquivos canônicos e o `README.md` central.
4. **Matriz Mestre de Rastreabilidade:** O cruzamento analítico entre padrões legados da AlgaWorks, soluções modernas e os domínios reais dos 25 microsserviços do AGR-Docs e do greenfield Teatro-ABC.

---

## 2. MATRIZ DE VERSÕES EXATAS E PADRÕES MODERNOS DE ELITE

A tabela abaixo define as versões oficiais e o contraste arquitetural com as tecnologias legadas:

| Componente | Versão Canônica | Recursos Modernos Obrigatórios | Práticas Legadas Terminantemente Banidas |
| :--- | :--- | :--- | :--- |
| **Linguagem Backend** | **Java 21 LTS** (Eclipse Temurin / OpenJDK 21) | • Java Records para DTOs imutáveis.<br>• Virtual Threads (Project Loom - JEP 444).<br>• Pattern Matching (`switch`, record patterns).<br>• Sequenced Collections (`getFirst()`, `reversed()`).<br>• Sealed Classes & Interfaces para domínio estrito. | • Classes DTO cheias de boilerplate/Lombok mutável (`@Data`).<br>• Concorrência baseada unicamente em thread pools OS limitados.<br>• `instanceof` clássico com casts manuais.<br>• Mapeamento de coleções com `list.get(list.size()-1)`. |
| **Framework Backend** | **Spring Boot 3.3+** (Spring Framework 6.1+) | • `SecurityFilterChain` com lambdas fluentes.<br>• RFC 7807 (`ProblemDetail` / `ErrorResponseException`).<br>• `RestClient` fluente para I/O síncrono.<br>• Observability nativa (Micrometer + OpenTelemetry).<br>• `spring-boot-docker-compose` para dev local. | • `WebSecurityConfigurerAdapter` (removido no Spring Sec 6).<br>• DTOs ad-hoc de erro com formato arbitrário.<br>• `RestTemplate` (manutenção) ou `WebClient` reativo forçado.<br>• Logs dispersos sem trace context distribuído.<br>• Configuração manual de containers sem automação. |
| **Persistência & ORM** | **Hibernate 6.5+** / **Jakarta Persistence 3.1** | • Hibernate Semantic Query Model (SQM).<br>• Lock Otimista (`@Version`) e Pessimista explícito.<br>• Eliminação de N+1 via `JOIN FETCH` e `@EntityGraph`.<br>• `spring.jpa.open-in-view=false` (OSIV desligado).<br>• Migrations versionadas com **Flyway 10+**. | • Namespace `javax.persistence.*` (morto na transição EE 10).<br>• Hibernate Criteria API legado (`session.createCriteria`).<br>• FetchType.EAGER indiscriminado.<br>• OSIV habilitado mascarando consultas em views/controllers.<br>• `hibernate.ddl-auto=update` em produção. |
| **Segurança & Auth** | **Spring Security 6.3+** | • Stateless OAuth2 Resource Server (`jwt()`).<br>• `JwtAuthenticationConverter` com claims customizadas.<br>• `@EnableMethodSecurity(prePostEnabled = true)`.<br>• Autorização declarativa com `@PreAuthorize`.<br>• CSRF desabilitado estritamente para APIs stateless. | • Autenticação baseada em sessão HTTP / cookies JSESSIONID.<br>• `antMatchers()` depreciado em favor de `requestMatchers()`.<br>• Mistura de Authorization Server dentro do Resource Server.<br>• Hardcoding de papéis no código sem checagem de escopo/permissão. |
| **Frontend Framework** | **Angular 17 / 18+** | • **Signals** (`signal()`, `computed()`, `effect()`).<br>• **Standalone Components** (`standalone: true`).<br>• Injeção moderna via função `inject()`.<br>• **Typed Reactive Forms** (`FormGroup<{...}>`).<br>• Nova sintaxe de controle (`@if`, `@for`, `@switch`).<br>• Deferrable Views (`@defer (on viewport)`). | • Monolitos baseados em `NgModule` e `SharedModule`.<br>• Voo cego com subscrições manuais RxJS vazando memória.<br>• Injeção poluída em construtores gigantes.<br>• Diretivas estruturais legadas (`*ngIf`, `*ngFor`).<br>• `UntypedFormGroup` sem validação de tipos em compilação. |

---

### 2.1 Detalhamento Técnico das Tecnologias Modernas

#### 2.1.1 Java 21 LTS: Física da Máquina e Otimização
1. **Java Records (JEP 395):**
   - *Impacto Físico:* Componentes de dados transparentes e imutáveis por padrão. Alocação direta na Stack quando sujeitos a escape analysis pelo compilador JIT (C2).
   - *Garantia Arquitetural:* Elimina efeitos colaterais onde um DTO tem seu valor alterado por outro thread durante a serialização ou processamento assíncrono.
2. **Virtual Threads (JEP 444 - Project Loom):**
   - *Impacto Físico:* Threads leves gerenciadas pela JVM (montadas sob demanda em nós de *Carrier Threads* do pool `ForkJoinPool`). Enquanto uma thread de sistema operacional (OS Thread) consome cerca de 1 MB de memória de pilha e tem limite de escala em milhares, Virtual Threads consomem poucos bytes no Heap e escalam para milhões.
   - *Configuração no Spring Boot 3.3:*
     ```yaml
     spring:
       threads:
         virtual:
           enabled: true
     ```
   - *Eliminação do Dilema Reativo:* Permite manter o código imperativo, limpo e legível (bloqueante sob o ponto de vista do código), enquanto sob o capô a JVM desacopla a thread carrier no momento de chamadas de I/O (JDBC, HTTP de rede), garantindo throughput máximo sem a complexidade cognitiva do Project Reactor / WebFlux.
3. **Pattern Matching para `switch` e Record Patterns (JEP 440 & JEP 441):**
   - *Garantia Arquitetural:* Verificação de exaustividade em tempo de compilação quando associado a `sealed interfaces`. Se uma nova regra regulatória ou status for adicionado ao domínio, o compilador força o tratamento em todos os pontos de decisão, eliminando bugs silenciosos de `default: break;`.
4. **Sequenced Collections (JEP 431):**
   - Unificação de coleções ordenadas (`SequencedCollection`, `SequencedSet`, `SequencedMap`) com métodos uniformes: `getFirst()`, `getLast()`, `addFirst()`, `addLast()`, `reversed()`.

---

#### 2.1.2 Spring Boot 3.3+: Otimização e Novos Contratos
1. **RFC 7807 (Problem Details for HTTP APIs):**
   - A especificação moderna define um objeto JSON padronizado para reportar falhas em APIs HTTP:
     ```json
     {
       "type": "https://api.agr.go.gov.br/erros/recurso-nao-encontrado",
       "title": "Recurso Não Encontrado",
       "status": 404,
       "detail": "Auto de Infração número 2026/00142 não foi localizado na base da fiscalização.",
       "instance": "/api/v1/autos-infracao/2026-00142",
       "timestamp": "2026-10-25T13:45:00Z"
     }
     ```
   - *Implementação Nativa:* O Spring Framework 6 introduziu a classe `org.springframework.http.ProblemDetail`, eliminando classes DTO caseiras de erro (`ErroDTO`, `ApiError`).
2. **RestClient Fluente (Spring 6.1+):**
   - O `RestClient` é o cliente HTTP síncrono moderno que substitui o antigo `RestTemplate` (atualmente em modo de manutenção).
   - Oferece uma API fluente e declarativa inspirada no `WebClient`, porém sem a dependência reativa do Netty/Project Reactor:
     ```java
     ProblemDetail erro = restClient.get()
         .uri("/api/cidadaos/{cpf}", cpf)
         .accept(MediaType.APPLICATION_JSON)
         .retrieve()
         .onStatus(HttpStatusCode::is4xxClientError, (req, resp) -> {
             throw new CidadaoNaoEncontradoException(cpf);
         })
         .body(CidadaoDTO.class);
     ```
3. **Observability Unificada (Micrometer Observation API):**
   - No Spring Boot 3, métricas, tracing distribuído e logs são unificados pelo `ObservationRegistry`. Cada requisição ganha um `traceId` e `spanId` propagados automaticamente via cabeçalhos W3C `traceparent` em chamadas HTTP do `RestClient`.

---

#### 2.1.3 JPA & Hibernate 6+: Transição SQM e Concorrência Real
1. **Hibernate Semantic Query Model (SQM):**
   - O Hibernate 6 redesenhou completamente o compilador de consultas. Consultas JPQL/HQL não são mais convertidas diretamente em árvore de sintaxe abstrata (AST) frágil para SQL; elas passam pelo modelo semântico SQM, permitindo otimizações profundas de subconsultas, funções analíticas SQL window e joins precisos.
2. **Lock Otimista (`@Version`):**
   - Controle de concorrência não-bloqueante via coluna de controle (ex: `versao INT`).
   - SQL executado na persistência: `UPDATE tabela SET campo = ?, versao = versao + 1 WHERE id = ? AND versao = ?`.
   - Se nenhuma linha for alterada, o Hibernate lança `OptimisticLockException` (traduzido pelo Spring para `ObjectOptimisticLockingFailureException`).
3. **Lock Pessimista (`LockModeType.PESSIMISTIC_WRITE`):**
   - Travamento físico de linha no banco através de `SELECT ... FOR UPDATE`.
   - Impede que qualquer outra transação leia com intenção de escrita ou altere o registro até que a transação corrente finalize (`COMMIT` ou `ROLLBACK`).
   - Mandatório para estoques críticos, alocação de poltronas de espetáculos (Teatro-ABC) e numeração sequencial estrita de documentos fiscais.
4. **Desligamento Mandatório do OSIV (`spring.jpa.open-in-view=false`):**
   - *Por que banir o OSIV?* O padrão Open Session in View mantém a conexão JDBC aberta durante toda a renderização da resposta (inclusive na serialização JSON do Jackson). Se o client for lento, a conexão do pool HikariCP fica presa, esgotando o banco em segundos. Com `open-in-view=false`, a transação e a sessão encerram rigorosamente na borda da camada `@Service`. Se o DTO precisar de dados relacionados, eles devem ser carregados explicitamente na query via `JOIN FETCH`.

---

#### 2.1.4 Spring Security 6: Arquitetura Stateless e RBAC
1. **SecurityFilterChain DSL Baseada em Lambdas:**
   - Remoção de qualquer herança de classes abstratas (`WebSecurityConfigurerAdapter`).
   - Configuração limpa e fluente:
     ```java
     @Bean
     public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
         return http
             .csrf(AbstractHttpConfigurer::disable)
             .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
             .authorizeHttpRequests(auth -> auth
                 .requestMatchers(HttpMethod.GET, "/api/v1/espetaculos/**").permitAll()
                 .requestMatchers("/api/v1/fiscalizacao/**").hasAuthority("ROLE_FISCAL")
                 .anyRequest().authenticated()
             )
             .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter())))
             .build();
     }
     ```
2. **Mapeamento de Claims e Permissões Customizadas:**
   - O token JWT emitido pelo Keycloak/Auth Server contém claims customizadas como `authorities`, `permissoes`, `orgao_id`, `cpf`.
   - Um `JwtAuthenticationConverter` dedicado extrai essas claims e as converte em objetos `GrantedAuthority`, permitindo o uso de `@PreAuthorize("hasAuthority('FISCALIZACAO_LAVRAR_AUTO')")`.

---

#### 2.1.5 Angular Moderno: O Fim do Zone.js e da Sobrecarga de Módulos
1. **Reatividade Fina com Signals (`signal()`, `computed()`, `effect()`):**
   - O Angular clássico dependia do Zone.js para "macacotear" (monkey-patch) todas as APIs assíncronas do navegador e disparar a detecção de mudanças (Change Detection) do topo da árvore de componentes até as folhas a cada clique ou timer.
   - Os **Signals** introduzem reatividade de granularidade fina: o componente avisa o framework exatamente qual nó do DOM precisa mudar quando um valor específico é alterado, com zero overhead de processamento inútil.
2. **Standalone Components & Injeção Funcional `inject()`:**
   - Fim dos `NgModule`s que agrupavam dezenas de componentes desnecessários.
   - Cada componente declara rigorosamente no metadado `@Component` o que utiliza via `imports: [CommonModule, ButtonModule, TableModule]`.
   - A função `inject(Servico)` substitui construtores pesados e viabiliza a criação de funções de composição (composables) reutilizáveis.
3. **Nova Sintaxe de Controle de Fluxo Embutido:**
   - `@if (condicao) { ... } @else { ... }`
   - `@for (item of lista(); track item.id) { ... } @empty { ... }`
   - Vantagens: Verificação estrita de tipos na compilação do template e performance brutal com o parâmetro mandatório `track`.

---

## 3. ARQUITETURA PEDAGÓGICA MANDATÓRIA EM 4 PARTES

Para atender com excelência ao requisito **R3** de `ORIGINAL_REQUEST.md`, **todo e qualquer conceito** apresentado nos 5 módulos deve ser estruturado sob o rigor pedagógico das 4 camadas abaixo:

```
┌────────────────────────────────────────────────────────────────────────┐
│               A QUADRUPLETA CANÔNICA DE ENSINO DO CONCEITO              │
│                                                                        │
│ 1. CONCEITO SIMPLES & ANALOGIA DO MUNDO REAL (Leigo / Iniciante)       │
│    -> Tradução intuitiva sem jargões para fixação de modelo mental.    │
│                                                                        │
│ 2. A DOR HISTÓRICA & O DESASTRE DO LEGADO (O que explodia em Prod)     │
│    -> Autópsia do bug, stack trace, contenção de I/O, falha de escala. │
│                                                                        │
│ 3. A SOLUÇÃO MODERNA DE ELITE (Como o Top 5% Global resolve)           │
│    -> Código limpo, imutabilidade, concorrência, tipos estritos.       │
│                                                                        │
│ 4. VÍNCULO DIRETO COM O AGR-DOCS & TEATRO-ABC (Caso Real em Produção)  │
│    -> Porta do microsserviço, entidade real, endpoint, fluxo prático.  │
└────────────────────────────────────────────────────────────────────────┘
```

---

### 3.1 Exemplos de Aplicação da Estrutura Pedagógica em 4 Partes

Abaixo demonstramos a aplicação prática desse padrão para 4 pilares cruciais que servirão de gabarito para a escrita dos módulos:

#### Exemplo A: DTOs Imutáveis com Java Records (Módulo 02)
1. **O que é o conceito explicado de forma simples:**
   * *Analogia da Encomenda Lacrada com Selo de Cartório:* Imagine que você compra um relógio caro e a transportadora o envia dentro de uma caixa de aço soldada com visor transparente. Você pode ler o que está dentro, mas ninguém no caminho pode abrir a caixa, adulterar as engrenagens ou trocar o relógio por uma pedra. Um Java Record é exatamente essa caixa lacrada de dados: depois de criado, ninguém altera seus atributos.
2. **A Dor Histórica / O Desastre do Legado:**
   * *O Desastre dos Javabeans com Lombok Mutável (`@Data`):* No legado do Portal 1 e cursos antigos, DTOs eram classes repletas de getters e setters públicos. Em um endpoint de processamento de infração, um desenvolvedor júnior ou interceptor acidentalmente chamava `dto.setValorMulta(BigDecimal.ZERO)` ou alterava a lista de itens compartilhada entre threads. O DTO sofria mutação em pleno voo na memória Heap, gerando autos de infração com valores zerados no banco de dados e auditorias corrompidas, sem deixar rastro de quem alterou o estado.
3. **A Solução Moderna de Elite:**
   * *Java 21 Record com Compact Constructor:*
     ```java
     public record EmitirAutoInfracaoDTO(
         @NotBlank String numeroAuto,
         @NotNull Long infracaoId,
         @NotNull @Positive BigDecimal valorMulta,
         @NotNull List<String> fotosEvidenciaUrls
     ) {
         public EmitirAutoInfracaoDTO {
             // Invariante de integridade garantida no nascimento do objeto
             fotosEvidenciaUrls = List.copyOf(fotosEvidenciaUrls); // Lista 100% defensiva/imutável
         }
     }
     ```
     O objeto nasce válido, é imutável, possui `equals()`, `hashCode()` e `toString()` gerados de forma canônica sem dependência de plugins de terceiros.
4. **Vínculo Direto com o AGR-Docs:**
   * *Microsserviço:* `fiscalizacaoservice` (:8082).
   * *Cenário Real:* Endpoint `POST /api/v1/autos-infracao`. O fiscal de campo envia o payload com a infração lavrada e fotos no MinIO. A garantia de imutabilidade assegura que a cadeia de custódia do auto de infração permaneça idêntica desde a requisição HTTP até a persistência no MySQL e geração do laudo PDF no JasperReports.

---

#### Exemplo B: Lock Pessimista na Concorrência Crítica (Módulo 03)
1. **O que é o conceito explicado de forma simples:**
   * *Analogia da Cabine Telefônica Única com Chave:* Imagine uma cabine telefônica com uma trava física. Se duas pessoas chegam correndo para usá-la ao mesmo tempo, a primeira que entrar gira a tranca por dentro. A segunda pessoa é obrigada a esperar na calçada até que a primeira termine a ligação, saia e destranque a porta. O Lock Pessimista é essa tranca no nível da linha do banco de dados: "Enquanto eu estiver mexendo nesta linha, ninguém encosta".
2. **A Dor Histórica / O Desastre do Legado:**
   * *O Desastre do "Lost Update" e da Venda Duplicada:* Em sistemas legados de venda de ingressos ou protocolo de processos sem lock, duas transações simultâneas liam o assento 14B com status `DISPONIVEL`. Ambas processavam a validação em memória na aplicação e ambas executavam `UPDATE assento SET status = 'RESERVADO'`. Resultado: dois clientes compravam o mesmo assento no mesmo show. No dia do evento, a segurança tinha que resolver a briga física de dois pagantes para o mesmo lugar.
3. **A Solução Moderna de Elite:**
   * *Consulta Tipada com `LockModeType.PESSIMISTIC_WRITE`:*
     ```java
     public interface AssentoRepository extends JpaRepository<Assento, Long> {
         @Lock(LockModeType.PESSIMISTIC_WRITE)
         @Query("SELECT a FROM Assento a WHERE a.id = :id AND a.sessao.id = :sessaoId")
         Optional<Assento> findByIdForUpdate(@Param("id") Long id, @Param("sessaoId") Long sessaoId);
     }
     ```
     No momento em que o primeiro cliente inicia a reserva, o banco emite `SELECT ... FOR UPDATE`, enfileirando qualquer transação concorrente no motor SQL do banco até a liberação ou timeout.
4. **Vínculo Direto com o AGR-Docs / Teatro-ABC:**
   * *Projeto Greenfield:* `teatro-abc` (Fase 6 do Laboratório).
   * *Cenário Real:* Endpoint `POST /api/v1/sessoes/{sessaoId}/reservas`. Pico de concorrência com 5.000 usuários tentando reservar 300 assentos de plateia no Centro Cultural Oscar Niemeyer. O lock pessimista previne 100% das vendas duplicadas de ingressos.

---

#### Exemplo C: RFC 7807 ProblemDetail (Módulo 02)
1. **O que é o conceito explicado de forma simples:**
   * *Analogia do Formulário Padrão do SAMU:* Se você ligar para a emergência médica em qualquer cidade do país, a ficha preenchida pelo atendente tem os mesmos campos padrão: quem liga, local exato, sintomas e gravidade. Ninguém inventa um papel de pão diferente a cada ligação. O RFC 7807 é essa ficha padrão universal para quando uma API web dá problema: qualquer cliente HTTP do planeta sabe ler os mesmos campos (`status`, `title`, `detail`, `instance`).
2. **A Dor Histórica / O Desastre do Legado:**
   * *O Desastre dos Erros Feitos em Casa:* No legado da AGR e em cursos antigos, cada desenvolvedor criava sua própria classe: `MensagemErroDTO`, `RetornoOperacao`, `ErrorVO`. O frontend Angular precisava ter 15 parsers diferentes para saber se a mensagem de erro estava no campo `msg`, `error`, `descricao` ou `errorMessage`. Pior: em caso de exceções não tratadas, o Spring cuspia um stack trace em HTML puro de 500 linhas na cara do usuário, expondo tabelas do banco e senhas.
3. **A Solução Moderna de Elite:**
   * *Tratamento Centralizado com `ResponseEntityExceptionHandler`:*
     ```java
     @RestControllerAdvice
     public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {
         @ExceptionHandler(RegraNegocioRegulatoriaException.class)
         public ProblemDetail handleRegraNegocio(RegraNegocioRegulatoriaException ex) {
             ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.getMessage());
             problem.setTitle("Violação de Regra Regulatória");
             problem.setType(URI.create("https://agr.go.gov.br/erros/regra-regulatoria"));
             problem.setProperty("codigoInfracao", ex.getCodigo());
             return problem;
         }
     }
     ```
4. **Vínculo Direto com o AGR-Docs:**
   * *Microsserviços:* `portalservice` (:8080) e `receitaservice` (:8092).
   * *Cenário Real:* Tentativa de emissão de guia DARE para auto de infração já quitado ou suspenso por liminar judicial. O client frontend exibe imediatamente o modal amigável consumindo o campo `detail` do ProblemDetail com rastreabilidade formal.

---

#### Exemplo D: Angular Signals vs RxJS Memory Leak (Módulo 05)
1. **O que é o conceito explicado de forma simples:**
   * *Analogia do Painel de Placar Eletrônico do Estádio:* Um Signal funciona como o placar digital do estádio de futebol. Quando o time faz um gol, o operador digita `placar.set(1)`. O display luminoso atualiza imediatamente os dígitos na tela. Ninguém precisa puxar fiação nova ou ficar perguntando a cada segundo se o placar mudou. O valor é autoexplicativo e sincronizado.
2. **A Dor Histórica / O Desastre do Legado:**
   * *O Desastre do `subscribe` Esquecido em Componentes Destruídos:* No Angular 2 até o 15 (e no código legado do Portal 2), o desenvolvedor se inscrevia em fluxos RxJS via `.subscribe(res => this.dados = res)` dentro de `ngOnInit()`. Ao trocar de tela, o componente era destruído, mas a subscrição continuava viva na memória RAM do navegador, segurando o componente no Heap. Após navegar por 10 telas de fiscalização, a aba do navegador consumia 2 GB de RAM e travava o computador do servidor público.
3. **A Solução Moderna de Elite:**
   * *Angular Signal Nativo com Imunidade a Memory Leaks:*
     ```typescript
     @Component({
       standalone: true,
       selector: 'app-lista-veiculos',
       template: `
         @if (carregando()) {
           <p-skeleton width="100%" height="4rem" />
         } @else {
           <p-table [value]="veiculos()">
             <ng-template pTemplate="body" let-v>
               <tr><td>{{ v.placa }}</td><td>{{ v.renavam }}</td></tr>
             </ng-template>
           </p-table>
         }
       `
     })
     export class ListaVeiculosComponent {
       private caduService = inject(CaduService);
       veiculos = signal<VeiculoDTO[]>([]);
       carregando = signal<boolean>(true);
       totalVeiculos = computed(() => this.veiculos().length);
     }
     ```
4. **Vínculo Direto com o AGR-Docs:**
   * *Frontend:* Portal Web Fiscalização / CADU (:4200).
   * *Cenário Real:* Tela de consulta de frota de concessionárias de ônibus intermunicipais. A lista reativa de veículos é atualizada com zero risco de vazamento de memória e renderização cirúrgica.

---

## 4. EMENTA DETALHADA E INVENTÁRIO DE RECURSOS POR MÓDULO

Esta seção detalha o conteúdo exato de cada um dos 5 arquivos markdown canônicos e do arquivo mestre `README.md`.

---

### 4.1 Módulo 01: `01-fundamentos-web-e-javascript-vanilla.md`
**Título:** *Fundamentos da Web Moderna: HTML5 Semântico, CSS3 Arquitetural & JavaScript ES6+ Vanilla de Alta Performance*  
**Objetivo Pedagógico:** Capacitar o desenvolvedor a dominar a camada física da web sem frameworks, entendendo o comportamento do navegador, acessibilidade, performance de renderização e fluxo assíncrono.

#### Seções e Inventário de Recursos:
1. **A Anatomia Física da Web & Ciclo de Vida HTTP:**
   - Resolução DNS, handshake TCP (SYN-ACK), negociação TLS 1.3 e cabeçalhos HTTP/1.1 vs HTTP/2 multiplexado.
   - O pipeline do navegador: DOM Tree + CSSOM Tree ➔ Render Tree ➔ Layout/Reflow ➔ Paint ➔ Composite.
   - O custo computacional de Reflow vs Repaint e como evitar layout thrashing.
2. **HTML5 Semântico Estrutural & Acessibilidade Corporativa (WCAG 2.1 AA):**
   - Estrutura semântica obrigatória: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`.
   - Formulários com validação nativa: `required`, `pattern`, `inputmode`, `type="email|tel|number"`.
   - Acessibilidade governamental (e-MAG / WCAG): Landmarks ARIA, `aria-expanded`, `aria-controls`, `aria-live="polite"` para notificações de sistema.
3. **CSS3 Arquitetural, BEM & Design Tokens Sem Dependências:**
   - Metodologia BEM (`bloco__elemento--modificador`): Previsibilidade e especificidade plana (zero `!important`).
   - CSS Moderno: CSS Custom Properties (Variáveis Nativas) para temas (Dark/Light Mode) e tokens de design do governo.
   - Layouts bidimensionais com CSS Grid e unidimensionais com Flexbox (eliminando Bootstrap legado e floats arcaicos).
4. **JavaScript ES6+ Vanilla sem Frameworks:**
   - Manipulação do DOM de alta performance: `querySelector`, `addEventListener` com delegação de eventos (`Event Delegation`).
   - Uso de `DocumentFragment` para mutações em lote no DOM.
   - O Modelo de Execução: Call Stack, Web APIs, Macrotasks (setTimeout) vs Microtasks (Promises) e o Event Loop na prática.
   - Programação assíncrona moderna: De Callback Hell a Promises e `async/await`.
   - API `fetch()` nativa com `AbortController` para cancelamento de requisições obsoletas em digitação em tempo real.
   - Módulos JavaScript nativos (ESM: `import` / `export`) no navegador.
5. **Conexão Real AGR & Laboratório:**
   - Microfrontend vanilla em portais de consulta pública de certidões (`portalservice :8080`).
   - Widget de validação de ingressos por câmera em vanilla JS no `teatro-abc`.

---

### 4.2 Módulo 02: `02-arquitetura-backend-spring-boot-3.md`
**Título:** *Arquitetura Backend de Alta Performance: Java 21 LTS, Spring Boot 3.3+ e Clean Architecture Hexagonal*  
**Objetivo Pedagógico:** Estruturar microsserviços modernos, desacoplados e resilientes, aplicando DDD tático, tipos de dados imutáveis, controle de concorrência por Virtual Threads e tratamento global padronizado de exceções.

#### Seções e Inventário de Recursos:
1. **Clean Architecture Hexagonal & DDD Tático:**
   - Divisão rigorosa de camadas: `domain` (entidades puras e regras de negócio sem anotações de Spring), `application` (casos de uso / use cases), `infrastructure` (adaptadores de persistência, mensageria e gateways), `interfaces` (REST controllers, contratos DTO).
   - Inversão de dependência na veia: o domínio define as portas (`RepositoryInterface`), a infraestrutura implementa os adaptadores.
2. **Java 21 LTS no Núcleo do Backend:**
   - Java Records como DTOs canônicos imutáveis de entrada e saída.
   - Virtual Threads (`Project Loom`): Análise de throughput em comparação com Platform Threads convencionais; ativação via configuração no Spring Boot 3.3.
   - Pattern Matching para `switch` e Record Patterns na desestruturação de eventos de negócio e transições de estado.
   - Sealed Interfaces para modelagem de tipos de autuação e regras de penalidade regulatória.
3. **Construção de APIs RESTful de Elite com Spring Boot 3.3:**
   - Semântica pura dos verbos HTTP: GET, POST, PUT, PATCH, DELETE e semântica de cabeçalhos (`Location`, `ETag`).
   - Bean Validation (`jakarta.validation`): Validação estrita de fronteira com `@Valid`, `@NotNull`, `@Pattern`, e criação de validadores customizados (ex: `@CpfValid`, `@CnpjValid`, `@PlacaVeiculoValid`).
   - Serialização e Desserialização precisa com Jackson 2.16+ (módulo de datas `JavaTimeModule` e registros imutáveis).
4. **Tratamento Global de Erros com RFC 7807 (ProblemDetail):**
   - Herança de `ResponseEntityExceptionHandler` e implementação de `@RestControllerAdvice`.
   - Padronização de erros corporativos com URLs canônicas (`type`), resumo (`title`), detalhes dinâmicos (`detail`) e identificador da requisição (`instance`).
5. **Comunicação Inter-Serviços com RestClient Fluente:**
   - O novo `RestClient` síncrono do Spring 6.1+: Configuração de pool de conexões, timeouts estritos (`connectTimeout`, `readTimeout`), interceptores de propagação de tokens Bearer JWT e tratamento de erros via `.onStatus()`.
6. **Observabilidade Corporativa & Micrometer:**
   - `ObservationRegistry`, exportação de métricas para Prometheus e instrumentação de traces distribuídos com OpenTelemetry.
7. **Conexão Real AGR & Laboratório:**
   - `portalservice` (:8080): Autenticação, usuários e autorizações.
   - `fiscalizacaoservice` (:8082): Cadastro e processamento de autos de infração.

---

### 4.3 Módulo 03: `03-persistencia-dados-jpa-hibernate-concorrencia.md`
**Título:** *Persistência Relacional Avançada: Hibernate 6+, Concorrência Crítica e Migrations com Flyway*  
**Objetivo Pedagógico:** Capacitar o engenheiro a desenhar modelos relacionais robustos, otimizar consultas eliminando gargalos de I/O, aplicar controle estrito de concorrência (Locks) e gerenciar a evolução do banco de forma 100% versionada.

#### Seções e Inventário de Recursos:
1. **O Motor Hibernate 6 & Jakarta Persistence 3.1:**
   - A arquitetura interna do Hibernate 6: O parser Semantic Query Model (SQM) e como o JPQL é compilado diretamente para dialetos SQL modernos.
   - O Ciclo de Vida da Entidade: Estados `Transient`, `Managed`, `Detached` e `Removed`.
   - O funcionamento do Contexto de Persistência (L1 Cache), a sincronização do método `flush()` e o mecanismo de `Dirty Checking`.
2. **Mapeamento de Relacionamentos sem Armadilhas de Performance:**
   - Estratégias de carregamento: A regra de ouro `FetchType.LAZY` obrigatório em `@ManyToOne` e `@OneToMany`.
   - Mapeamentos avançados: `@MapsId` para chaves compostas/estrangeiras compartilhadas, `@Embeddable` e `@ElementCollection`.
   - Mapeamento de Herança: `InheritanceType.JOINED` vs `SINGLE_TABLE` em domínios de transporte e fiscalização.
3. **Extermínio do Problema N+1 e Ajuste Fino de Consultas:**
   - Diagnóstico do N+1 através de logs SQL e ferramentas de profiling.
   - Resolução cirúrgica via `JOIN FETCH` em JPQL.
   - Uso de `@EntityGraph` dinâmico e declarativo (`FetchGraph` vs `LoadGraph`).
   - Otimização em lote de coleções com `@BatchSize(size = 25)`.
   - A proibição do Open Session in View (`spring.jpa.open-in-view=false`) e o confinamento de transações com `@Transactional(readOnly = true)`.
4. **Controle de Concorrência em Sistemas de Alta Demanda:**
   - O fenômeno da "Atualização Perdida" (*Lost Update*).
   - **Lock Otimista (`@Version`):** Mecânica interna, tipo do atributo (`Long` ou `Integer`) e captura de `OptimisticLockException`.
   - **Lock Pessimista (`LockModeType.PESSIMISTIC_WRITE`):** Execução de `SELECT ... FOR UPDATE`, timeouts de bloqueio (`jakarta.persistence.lock.timeout`) e prevenção de Deadlocks.
   - **Lock Pessimista de Leitura (`LockModeType.PESSIMISTIC_READ`):** Garantia de consistência em relatórios contábeis e consolidação financeira.
5. **Evolução de Esquema de Banco de Dados com Flyway:**
   - Fim do perigoso `ddl-auto=update` em ambientes de produção.
   - Estrutura canônica de scripts SQL: Migrations versionadas (`V1__criar_tabelas.sql`, `V2__adicionar_indices.sql`) e repetíveis (`R__criar_views.sql`).
   - Tabela de controle `flyway_schema_history`, integridade de checksums e baseline de bancos legados existentes.
6. **Conexão Real AGR & Laboratório:**
   - `cadu` (:8081): Cadastro unificado de concessionárias, frotas e motoristas.
   - `fiscalizacao` (:8082): Autos de apreensão de veículos e concorrência na retenção de frotas.
   - `teatro-abc`: Concorrência extrema na reserva de assentos de espetáculos com Lock Pessimista.

---

### 4.4 Módulo 04: `04-seguranca-stateless-oauth2-jwt-rbac.md`
**Título:** *Segurança Corporativa Moderna: Stateless OAuth2 Resource Server, JWT e RBAC Fino com Spring Security 6*  
**Objetivo Pedagógico:** Projetar e implementar uma arquitetura de segurança 100% desacoplada e stateless, utilizando tokens JWT criptograficamente assinados, isolando autenticação de autorização e garantindo controle fino de permissões em microsserviços.

#### Seções e Inventário de Recursos:
1. **Fundamentos da Segurança Stateless & OAuth2 2.1:**
   - Contraste: Autenticação baseada em Sessão (Stateful / Cookies de Memória) vs Autenticação Stateless por Tokens Bearer.
   - A topologia OAuth2: Authorization Server (Keycloak / Spring Authorization Server) emitindo tokens vs Resource Servers validando tokens via chaves públicas assimétricas (JWKS).
   - O fluxo seguro moderno: Authorization Code Flow com PKCE para navegadores/SPAs e Client Credentials para integrações de backend sem usuário interativo.
2. **Anatomia Criptográfica do JWT (JSON Web Token):**
   - Estrutura de três partes: Header (algoritmo RS256/ES256), Payload (Claims padronizadas e claims corporativas) e Assinatura Digital.
   - Claims essenciais de integridade: `iss` (issuer), `sub` (subject), `aud` (audience), `exp` (expiration), `nbf` (not before), `jti` (JWT ID para prevenção de replay attack).
3. **Spring Security 6 como Resource Server:**
   - Criação da cadeia de filtros `SecurityFilterChain` sem classes depreciadas.
   - Desativação intencional de CSRF para APIs que não utilizam cookies de sessão para autenticação.
   - Configuração estrita de CORS (`CorsConfigurationSource`) definindo origens autorizadas, métodos e cabeçalhos expostos.
   - Decodificação de JWT via endpoint JWKS do Authorization Server com cache de chaves públicas.
4. **Customização de Claims e Mapeamento de Autoridades:**
   - Criação do `JwtAuthenticationConverter`: Extração de arrays de permissões e perfis do JSON e conversão em `SimpleGrantedAuthority`.
   - Injeção do contexto de segurança: Como acessar o usuário autenticado, seu CPF e órgão regulador em qualquer ponto da aplicação via `SecurityContextHolder`.
5. **Controle Fino de Acesso (RBAC & PBAC):**
   - Ativação do `@EnableMethodSecurity(prePostEnabled = true)`.
   - Expressões SpEL de segurança em métodos: `@PreAuthorize("hasAuthority('FISCALIZACAO_NOTIFICAR')")`.
   - Segurança baseada em atributos (ABAC): Checagem de propriedade de dados: `@PreAuthorize("hasAuthority('ADMIN') or #dto.fiscalCpf == authentication.name")`.
6. **Segurança Entre Microsserviços (Service-to-Service):**
   - Propagação de tokens do usuário original (Token Relay) em chamadas via `RestClient`.
   - Uso de Client Credentials Flow para rotinas em segundo plano e cronjobs batch de atualização cadastral.
7. **Conexão Real AGR & Laboratório:**
   - `portalservice` (:8080): Emissão e validação de tokens centrais de servidores públicos e regulados.
   - `fiscalizacaoservice` (:8082) e `receitaservice` (:8092): Resource Servers blindados por perfis (`FISCAL`, `ADMIN`, `CONCESSIONARIA`).

---

### 4.5 Módulo 05: `05-frontend-enterprise-angular-vanilla.md`
**Título:** *Frontend Corporativo Enterprise: Angular Moderno, Standalone Components, Signals & PrimeNG*  
**Objetivo Pedagógico:** Construir interfaces ricas, altamente responsivas e imunes a vazamentos de memória, aproveitando os novos recursos reativos nativos do Angular moderno e componentes industriais da suíte PrimeNG.

#### Seções e Inventário de Recursos:
1. **Arquitetura Baseada em Standalone Components:**
   - O fim da sobrecarga de `NgModule`: Componentes, diretivas e pipes autônomos.
   - Roteamento moderno com lazy-loading de componentes (`loadComponent: () => import(...)`) e guardas de rota funcionais (`canActivate: [authGuard]`).
2. **Reatividade com Angular Signals (v17/v18+):**
   - Modelo mental de Signals: Valores reativos primitivos com `signal()`.
   - Sinais derivados e computados com `computed()` (cálculos memoizados automáticos).
   - Efeitos colaterais declarativos com `effect()` para logging e persistência em LocalStorage.
   - Interoperabilidade entre Signals e RxJS: Quando converter via `toSignal()` e `toObservable()`.
3. **Injeção de Dependências Moderna com `inject()`:**
   - Injeção de dependências sem construtores volumosos.
   - Criação de composables customizados para controle de autenticação, paginação de tabelas e temas visuais.
4. **Formulários Reativos Tipados (Typed Reactive Forms):**
   - Estruturação estrita de `FormGroup`, `FormControl` e `FormArray` com checagem de tipos em tempo de compilação.
   - Validações síncronas e assíncronas de documentos: Validador de CPF, CNPJ e placas de veículos do padrão Mercosul.
   - Apresentação elegante de mensagens de validação orientadas ao usuário.
5. **A Nova Sintaxe de Controle de Fluxo Embutido & Deferrable Views:**
   - Controle condicional e repetição nativos: `@if`, `@else`, `@switch`, `@for (item of itens; track item.id)`.
   - Otimização brutal de renderização com a obrigatoriedade da função de tracking.
   - Deferrable Views (`@defer`): Carregamento preguiçoso de componentes pesados (gráficos Chart.js, visualizadores de PDF Jasper) condicionados a visibilidade na tela (`on viewport`) ou interação do usuário (`on interaction`).
6. **Design System Corporativo com PrimeNG:**
   - Tabelas de dados dinâmicas (`p-table`) com ordenação, filtros em múltiplas colunas e paginação server-side acoplada a APIs Spring Data.
   - Diálogos de confirmação (`p-confirmDialog`), toasts de notificação (`p-toast`) e menus de navegação integrados aos perfis de acesso do usuário.
7. **Conexão Real AGR & Laboratório:**
   - Interface Web de Fiscalização de Frotas e Vistorias (Portal 2 Web).
   - Painel interativo de seleção de poltronas de espetáculo no greenfield `teatro-abc`.

---

### 4.6 Índice Central Mestre: `README.md`
**Título:** *Suíte de Documentação Pedagógica de Elite: Da Teoria do Zero à Arquitetura Real de Microsserviços*  
**Objetivo Pedagógico:** Servir como o portal de entrada, guia de navegação sequencial e mapa de rastreabilidade cruzada de toda a suíte.

#### Conteúdo Estrutural Obrigatório:
1. **Manifesto do Engenheiro Top 5%:** O compromisso com o código limpo, anti-vibe coding, tipagem estrita e entendimento da física da máquina.
2. **Mapa de Navegação Sequencial:** Trilha recomendada de estudos módulo a módulo com os pré-requisitos e objetivos de aprendizado de cada etapa.
3. **Matriz de Rastreabilidade Cruzada Completa:** A tabela mestre que correlaciona cada conceito, as aulas da AlgaWorks que o abordavam de forma legada, a solução moderna de elite e onde ele vive fisicamente na arquitetura do AGR-Docs e do Teatro-ABC.
4. **Guia de Instalação e Execução do Laboratório:** Como subir a infraestrutura base (Docker Compose com Postgres, MySQL e MinIO) para reproduzir os exemplos de código de cada módulo.

---

## 5. MATRIZ MESTRE DE RASTREABILIDADE CRUZADA

A tabela a seguir estabelece a rastreabilidade ponta a ponta exigida pelos critérios de aceitação do projeto, demonstrando a correlação entre as 1.625 aulas do acervo AlgaWorks, a arquitetura moderna e a aplicação prática nos serviços do AGR-Docs e Teatro-ABC:

| Módulo Canônico | Conceito Chave | Referência AlgaWorks (Legado) | O Desastre do Legado | A Solução Moderna de Elite | Microsserviço & Porta AGR-Docs / Teatro-ABC | Cenário Real de Negócio |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **01. Fundamentos Web** | Manipulação Assíncrona | Aulas antigas JSF/jQuery (ex: `3.6 - mascara dinheiro jquery`, `15.7 - ajax`) | Poluição do escopo global `window`, colisões de seletores jQuery e callback hell. | Fetch API nativa com `async/await` e `AbortController` modular ESM. | `portalservice` (:8080) | Consulta rápida de validade de certidão regulatória sem recarregar página. |
| **01. Fundamentos Web** | Semântica e Acessibilidade | `1.10 - primefaces layout`, `5.1 - prototipando pesquisa` | `<div>` para tudo, ausência de landmarks ARIA, leitor de tela inacessível. | HTML5 Semântico (`<main>`, `<article>`, `<nav>`) e tags acessíveis WCAG 2.1 AA. | `portalservice` (:8080) | Painel acessível ao cidadão e frotista para emissão de certidões. |
| **02. Backend Spring 3** | Contratos de Dados (DTOs) | `EJPA 11.10 - mapeando retorno para um dto`, `FAS 22.08 - dto relatorio` | Javabeans mutáveis com getters/setters e anotações `@Data` do Lombok permitindo mutação de estado. | **Java 21 Records** imutáveis com compact constructors de validação defensiva. | `fiscalizacaoservice` (:8082) | Payload imutável de lavratura de auto de infração com fotos anexadas. |
| **02. Backend Spring 3** | Concorrência de I/O | `EJPA 17.08 - wildfly`, `EJPA 14.01 - concorrencia` | Esgotamento do thread-pool do Tomcat ao aguardar respostas lentas de outros sistemas. | **Virtual Threads** (Loom) ativadas nativamente no Spring Boot 3.3. | `seiservice` (:8111) & `base-cidadao` (:8102) | Chamadas síncronas a barramentos de governo sem travar o servidor. |
| **02. Backend Spring 3** | Tratamento de Erros | `9.1 - view expired exception`, `9.2 - tratando outras excecoes` | Classes caseiras `ApiError`, status 200 com mensagem de erro no corpo ou stacktrace exposto. | **RFC 7807 ProblemDetail** centralizado em `@RestControllerAdvice`. | `receitaservice` (:8092) | Rejeição padronizada de pagamento duplicado ou DARE vencido. |
| **02. Backend Spring 3** | Cliente HTTP Inter-Serviços | `FAS 22.17 - enviando email simples`, chamadas RestTemplate | `RestTemplate` com API prolixa ou `WebClient` forçando reatividade reativa desnecessária. | **RestClient** fluente do Spring 6.1 com timeouts e interceptores. | `fiscalizacaoservice` (:8082) ➔ `cadu` (:8081) | Busca de dados da concessionária para compor o auto de infração. |
| **03. Persistência & JPA** | Mapeamento Relacional & N+1 | `v11.3 - problema n mais um`, `EJPA 04.12 - eager e lazy`, `EJPA 10.10 - join e fetch` | `FetchType.EAGER` padrão em anotações gerando centenas de queries em loops na tela. | `FetchType.LAZY` obrigatório com `JOIN FETCH` explícito e `@EntityGraph`. | `cadu` (:8081) | Listagem paginada de concessionárias com seus veículos e linhas regulares. |
| **03. Persistência & JPA** | Concorrência Crítica (Lock) | `EJPA 14.04 - diferenca lock otimista e pessimista`, `EJPA 14.06 - lock pessimista` | Concorrência desprotegida causando "Lost Update" e venda duplicada de ingressos. | **Lock Otimista (`@Version`)** para processos e **Lock Pessimista (`PESSIMISTIC_WRITE`)** para assentos. | `teatro-abc` & `fiscalizacao` (:8082) | Reserva simultânea de poltrona no Teatro-ABC e lavratura de auto de infração. |
| **03. Persistência & JPA** | Escopo de Transação & OSIV | `v7.1 - sessao e transacao`, `EJPA 13.08 - fechando entitymanager` | Open Session in View mantendo conexão JDBC aberta durante a serialização JSON. | `spring.jpa.open-in-view=false` com fronteiras estritas em `@Transactional`. | `receitaservice` (:8092) | Apuração contábil em lote da Taxa de Regulação (TRCF) sem estourar o HikariCP. |
| **03. Persistência & JPA** | Evolução de Esquema | `EJPA 07.12 - estrategias geracao tabelas`, scripts manuais soltos | `ddl-auto=update` em produção alterando colunas inadvertidamente ou scripts manuais descontrolados. | Migrations versionadas estritas com **Flyway 10+** (`V1__`, `V2__`, `R__`). | Todos os 25 microsserviços | Controle auditável de criação e migração de tabelas em homologação e produção. |
| **04. Segurança & OAuth2** | Configuração de Segurança | `15.2 - configurando spring security`, `WebSecurityConfigurerAdapter` | Herança de classes depreciadas e autorização acoplada a sessões HTTP locais. | `SecurityFilterChain` baseado em lambdas com `SessionCreationPolicy.STATELESS`. | `portalservice` (:8080) | Gateway de segurança central e emissão de tokens para fiscais e servidores. |
| **04. Segurança & OAuth2** | Token e Claims | `Fsas 25.01 - authorization code pkce`, `Fsas 25.02 - authorization server` | Token opaco de sessão ou JWT sem claims granulares, obrigando queries extras ao banco a cada request. | JWT com claims estruturadas (`roles`, `permissoes`, `orgao_id`) e `JwtAuthenticationConverter`. | `fiscalizacaoservice` (:8082) | Autorização com `@PreAuthorize("hasAuthority('FISCALIZACAO_EDITAR')")`. |
| **05. Frontend Angular** | Reatividade e Estado | `FAS 23.01 - modulo dashboard`, `FAS 23.05 - buscando dados grafico` | Subscrições manuais em Observables sem `takeUntilDestroyed`, causando vazamento de memória RAM. | **Angular Signals** (`signal()`, `computed()`, `effect()`) com reatividade granular. | Portal Web Fiscalização (:4200) | Dashboard de autos lavrados em tempo real sem estourar a memória do navegador. |
| **05. Frontend Angular** | Modularidade | `FAS 23.07 - criando modulo relatorios`, NgModules legados | Módulos monolíticos gigantescos que quebravam o code-splitting e atrasavam o carregamento inicial. | **Standalone Components** (`standalone: true`) com carregamento sob demanda (`loadComponent`). | Portal Web CADU (:4200) | Telas isoladas de cadastro de pessoas e frotas carregadas instantaneamente. |
| **05. Frontend Angular** | Formulários Reativos | `FAS 24.06 - validando cidade estado`, `FAS 23.13 - formulario contato` | Formulários sem tipagem estrita permitindo envio de objetos malformados ao backend. | **Typed Reactive Forms** (`FormGroup<{...}>`) com validação de tipos em compilação e validadores customizados. | Portal Web Fiscalização (:4200) | Formulário de vistoria em campo com validação instantânea de placa e chassi. |

---

## 6. DIRETRIZES DE ESCRITA E QUALIDADE PARA A EQUIPE DE DOCUMENTAÇÃO

Para garantir que os arquivos finais em `templates-lab/docs/` atinjam o mais alto padrão de engenharia, a equipe de autores deve seguir estritamente as regras abaixo:

1. **Rigor Técnico e Zero Eufemismos:**
   - Nunca use explicações superficiais como "o Spring faz uma mágica aqui".
   - Explique exatamente o que a JVM, o Garbage Collector, o pool de conexões JDBC e o navegador fazem fisicamente.
2. **Proibição de Código Fantasma e "TODOs":**
   - Não use comentários como `// TODO: implementar depois` ou `// resto do código aqui`.
   - Todos os exemplos de código devem ser completos, compiláveis e com importações explícitas no topo do bloco quando relevante.
3. **Didática do Contraste Visual:**
   - Use blocos de código com a anotação `❌ O ERRO LEGADO` seguido de `✅ A SOLUÇÃO DE ELITE`, permitindo que o leitor visualize imediatamente a diferença de padrão.
4. **Alinhamento com o Repositório AGR:**
   - Faça referência constante aos diretórios e scripts do repositório irmão `agr-docs` (ex: `projetos/fiscalizacao/docs/`, `e2e/specs/`, `agr.ps1`).

---

## 7. CONCLUSÃO DO SURVEY 3

A arquitetura pedagógica e o inventário de recursos mapeados neste relatório fornecem a planta baixa completa para a redação dos 5 módulos canônicos e do `README.md`. Com a união da simplicidade didática das analogias do mundo real, a demonstração nua e crua das falhas do legado e a aplicação imediata nos microsserviços reais da AGR e do Teatro-ABC, a suíte de documentação se consolidará como uma referência definitiva de engenharia de software de elite.

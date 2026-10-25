# Módulo 02: Arquitetura Backend Moderna com Spring Boot 3.3+ e Java 21 LTS

---

## Sumário Executivo & Manifesto da Engenharia de Backend Corporativo

O desenvolvimento de serviços de backend em ecossistemas corporativos e governamentais de missão crítica passou por uma revolução profunda nos últimos anos. Durante mais de uma década, o padrão da indústria no ecossistema Java esteve ancorado em premissas originadas na era do Java 8 e do Spring Boot 1.x e 2.x: JavaBeans mutáveis repletos de boilerplate ou excessivamente dependentes de anotações mágicas do Project Lombok (`@Data`), mapeamentos reflexivos em tempo de execução com `ModelMapper`, servidores Tomcat limitados a pools rígidos de 200 threads nativas do sistema operacional (Platform Threads), tratamento ad-hoc e manual de exceções e o antipadrão pernicioso do envelope genérico de resposta (o famigerado `Response<T>`), que mascarava falhas graves de sistema e violações de regras sob respostas com status `HTTP 200 OK`.

No ecossistema de regulação e controle da **Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos (AGR)** — compreendendo mais de 25 microsserviços reais em produção, tais como o `portalservice` (`:8080`), o Cadastro Único de Permissionários e Concessionárias `cadastrounicoservice` (`:8081`), o Sistema de Gestão de Fiscalização e Autos de Infração `fiscalizacaoservice` / `agrfiscalservice` (`:8082` / `:8083`), o Módulo de Arrecadação e DARE `receitaservice` (`:8092`) e a integração de Processo Eletrônico `seiservice` (`:8111`) —, bem como na infraestrutura de alta concorrência da bilhetagem do **Teatro-ABC** (`:8090`), a manutenção dessas práticas legadas gerou gargalos severos de concorrência, vazamento de abstrações, fragilidade de tipagem e incidentes recorrentes de indisponibilidade durante picos de fiscalização e operações de campo.

Este módulo estabelece o guia canônico e definitivo para a construção de serviços backend de alta performance, desacoplados, observáveis e estritamente tipados, alicerçados na dobradinha de elite **Java 21 LTS** e **Spring Boot 3.3+**. 

A engenharia aqui apresentada não tolera atalhos, abstrações vazias ou código incompleto. Cada um dos conceitos arquiteturais é explorado de forma exaustiva através da **Quadrupleta Didática Canônica**:
1. **Parte 1: O que é o conceito / Analogia Didática com o Mundo Real**, construindo a intuição física imediata;
2. **Parte 2: A Dor Histórica / O Desastre do Legado**, detalhando as falhas em produção e integrando citações literais transcritas do acervo masterclass da AlgaWorks (*Especialista Spring REST* - ESR);
3. **Parte 3: A Solução Moderna de Elite**, fornecendo código completo, tipado, compilável e executável em conformidade com as especificações do Jakarta EE 10 e Spring Framework 6.1+;
4. **Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC**, conectando cada decisão arquitetural aos microsserviços regulatórios reais do Estado de Goiás e ao greenfield de eventos.

---

## 1. Matriz de Evolução Geracional da Plataforma: Java 8 vs 17 vs 21 LTS

A evolução do ecossistema Java entre a versão 8 (2014) e a versão 21 LTS (2023–2026) representa uma das transformações de infraestrutura mais radicais da história da computação corporativa. A tabela abaixo resume as rupturas fundamentais de arquitetura, concorrência, modelagem de dados e desempenho:

| Dimensão de Engenharia | Java 8 (O Legado Monolítico) | Java 17 LTS (A Transição Moderna) | Java 21 LTS (A Engenharia de Elite) |
| :--- | :--- | :--- | :--- |
| **Modelo de Dados (DTOs)** | JavaBeans mutáveis com getters/setters, construtores quilométricos ou `@Data` do Lombok. Mapeamento reflexivo dinâmico (`ModelMapper`). | Introdução finalizada de `records` (JEP 395). Imutabilidade rasa nativa garantida pelo compilador. | `records` consolidados com construtores compactos, cópias defensivas estritas e desestruturação via Record Patterns. |
| **Concorrência e Threads** | Platform Threads 1:1 com threads do Sistema Operacional. Limite padrão de ~200 threads no Tomcat. Consumo de 1 MB de memória de Stack por thread. | Mesma mecânica de threads do SO. Reatividade funcional complexa (Spring WebFlux / Project Reactor) para I/O não bloqueante. | **Virtual Threads (Project Loom - JEP 444)** nativas. Milhões de threads leves gerenciadas pela JVM sobre Carrier Threads, sem callback hell. |
| **Controle de Fluxo & Tipos** | `instanceof` clássico com cast manual obrigatório (`Tipo t = (Tipo) obj`). `switch` limitado a tipos primitivos, strings e enums. | Pattern Matching para `instanceof` (eliminação de cast explícito). Classes seladas (`sealed classes` - JEP 409). | **Pattern Matching para `switch` (JEP 441)** com guards `when`, exaustividade verificada pelo compilador e Record Patterns (JEP 440). |
| **Namespace Corporativo** | `javax.*` (legado Java EE sob gestão da Oracle Corporation). | Início da cisão no ecossistema (Jakarta EE 9). | **`jakarta.*` estrito (Jakarta EE 10)**. Spring Boot 3.3 não aceita nenhuma dependência baseada em `javax.persistence` ou `javax.servlet`. |
| **Tratamento de Erros Web** | POJOs artesanais customizados, ausência de padrão IETF, ou envelope artificial `Response<T>` mascarando falhas sob `HTTP 200 OK`. | Primeiras discussões de adoção da RFC 7807, mas ainda implementadas via bibliotecas de terceiros (Problem-Spring-Web). | **`org.springframework.http.ProblemDetail` nativo** incorporado no Spring Framework 6+ e ativado globalmente via configuração. |
| **Comunicação HTTP Cliente** | `RestTemplate` com API de métodos sobrecarregados imperativos ou utilitários manuais (`HttpURLConnection`). | `RestTemplate` colocado em modo de manutenção pelo Spring; adoção forçada do `WebClient` reativo. | **`RestClient` síncrono e fluente (Spring 6.1+)**, combinando a simplicidade imperativa com a potência ergonômica de builders modernos. |

```
ARQUITETURA DE CONCORRÊNCIA: PLATFORM THREADS vs VIRTUAL THREADS (PROJECT LOOM)

 [ LEGADO: Thread-per-Request Tradicional ]           [ ELITE: Virtual Threads (Java 21) ]
 Requisição 1 ──> [ OS Thread 1 (1MB Stack) ]       Requisição 1 ──> [ Virtual Thread 1 (KB) ] ─┐
 Requisição 2 ──> [ OS Thread 2 (1MB Stack) ]       Requisição 2 ──> [ Virtual Thread 2 (KB) ] ─┼─> [ ForkJoinPool ]
 Requisição 3 ──> [ OS Thread 3 (1MB Stack) ]       Requisição 3 ──> [ Virtual Thread 3 (KB) ] ─┤    (16 Carrier Threads
   ...             (Esgota com ~200 requisições)     ...                                         │     presas à CPU)
 Requisição 201 ─> [ FILA / HTTP 504 TIMEOUT ]      Requisição 10.000 > [ Virtual Thread N ] ───┘
```


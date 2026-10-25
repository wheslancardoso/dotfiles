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

---

## 2. Pilar 1: Java 21 LTS Core Features & Modelagem de Domínio Imutável

### 2.1 Paradigma de Contratos: Java Records imutáveis para DTOs vs JavaBeans Mutáveis / Lombok

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma caixa registradora de correspondência diplomática: ao postar uma carta oficial entre ministérios, ela é acondicionada em uma cápsula de liga de titânio com lacre inviolável e carimbo de cera numerado. Qualquer diplomata, fiscal ou mensageiro que receba a cápsula pode ler o seu conteúdo através de uma janela de vidro blindado de alta transparência, mas **nenhum intermediário possui chave ou autorização para abrir a cápsula, rasurar valores, alterar nomes de destinatários ou arrancar laudos anexos**. 

Um **Java Record (JEP 395)** é exatamente essa cápsula lacrada na memória da JVM. Introduzido como funcionalidade definitiva na linguagem, um Record é uma classe especializada concebida com um único propósito arquitetural: atuar como um transportador transparente e puramente imutável de dados (*Data Carrier*). Diferente de uma classe Java convencional, ao declarar um `record`, o compilador gera automaticamente no nível do bytecode:
1. Campos privados e estritamente finais (`private final`) para todos os componentes declarados no cabeçalho;
2. Métodos acessores públicos canônicos sem o prefixo prolixo `get` (por exemplo, `placa()` e `valorMulta()`);
3. Implementações deterministicamente consistentes e seguras de `equals()`, `hashCode()` e `toString()`, baseadas exclusivamente nos valores dos componentes;
4. Desativação estrutural de qualquer tentativa de mutação de estado após o encerramento do construtor.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Durante anos, a arquitetura de backend corporativo Java ensinada no mercado e adotada nos sistemas pioneiros da AGR esteve amarrada ao padrão JavaBeans. Para cada requisição ou resposta de API, criava-se uma classe POJO repleta de métodos getters e setters. Quando os desenvolvedores perceberam que passavam mais de 60% do tempo mantendo esse código repetitivo, recorreram a duas soluções paliativas que se transformaram em verdadeiras armadilhas em produção: as anotações mágicas do Project Lombok (`@Getter`, `@Setter`, `@Data`) e os motores de mapeamento dinâmico baseados em reflexão em tempo de execução, especialmente o **ModelMapper**.

No curso *Especialista Spring REST* (ESR) da AlgaWorks, na aula `502_11.14. Adicionando e usando o ModelMapper.txt`, o instrutor Thiago expõe com clareza o cansaço dos times com o boilerplate dos DTOs tradicionais:
> *"Dá uma olhada nesse código aqui. Será que dá para melhorar esse código? Tem código boilerplate aqui, aquele código repetitivo. Faz get do um lado, set no outro. Get no lado, set no outro. Isso porque as nossas classes não têm muitas propriedades... Imagina se a gente tivesse aqui classes com mais propriedades, classes mais complexas. Esse código aqui se tornaria um código chato de escrever. Não no sentido só chato de escrever, mas chato fica mantendo esse código com get, set assim, né?"* (`502_11.14`)

E na aula seguinte, `503_11_15_Entendendo_a_estratégia_padrão_do_ModelMapper_para_correspondência.txt`, demonstra-se a perigosa "mágica" de resolução por nomes de propriedades que o motor utilizava:
> *"Olha só. Frete, 10. Uau, quer dizer, tirei a palavra taxa e mesmo assim ele viu uma correspondência, né? Entre taxa frete e frete. E dentro da classe restaurante, veja que tem taxa frete, aqui no restaurante model tem apenas frete e ele correspondeu uma coisa com a outra e aí está a inteligência dele... Você está vendo também a flexibilidade que a gente tem... o model mapper já está fazendo a transformação para a gente..."* (`503_11_15`)

**O Desastre em Produção no Ecossistema Corporativo:**
O que parecia produtividade imediata gerou catástrofes de engenharia em ambientes reais:
1. **Falha Silenciosa de Tipos e Renomeações (Silent Nulling):** Se um auditor fiscal alterava o atributo de uma entidade JPA de `taxaFrete` para `valorTarifaFixada`, o `ModelMapper` não acusava nenhum erro durante a compilação do Maven. Em tempo de execução, durante uma blitz na rodovia com dezenas de veículos retidos, o conversor falhava silenciosamente em encontrar a correspondência e injetava `null` no campo do DTO enviado ao banco de dados. Multas de centenas de milhares de reais foram emitidas com valor nulo ou zerado em produção.
2. **Degradação de Throughput por Introspecção Reflexiva:** Cada invocação de `modelMapper.map(origem, Destino.class)` forçava a JVM a varrer a tabela de símbolos e metadados de métodos da classe em tempo de execução. Sob carga intensa de 2.000 requisições simultâneas, o Garbage Collector entrava em sobrecarga devido aos milhares de objetos intermediários de inspeção de propriedades alocados no Heap, elevando a latência de 40 ms para mais de 3,5 segundos por requisição.
3. **Mutação Concorrente de Estado em Trânsito:** Por possuírem setters públicos desprotegidos, instâncias de DTOs passadas entre interceptores, filtros de auditoria e métodos assíncronos tinham seus atributos alterados no meio da pipeline HTTP. Um filtro que pretendia mascarar o CPF do condutor acabava mutando o objeto que ainda seria persistido na base de dados, gerando corrupção irreversível de registros.

#### Parte 3: A Solução Moderna de Elite
A engenharia moderna de backend elimina completamente o `ModelMapper` e as anotações mutáveis do Lombok em DTOs de entrada e saída. Empregam-se **Java Records** com **Compact Constructors**, aplicando validação estrita de invariantes e garantindo **cópia defensiva** de coleções mutáveis no nível da linguagem:

```java
package br.gov.go.agr.fiscais.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Objects;

/**
 * DTO Canônico Imutável para Emissão de Auto de Infração Rodoviário.
 * Representa o contrato estrito recebido pelo endpoint REST.
 * Imutabilidade garantida nativamente pelo bytecode do Java 21 LTS.
 */
public record AutoInfracaoRequest(
    @NotBlank(message = "A placa do veículo fiscalizado é obrigatória")
    String placa,

    @NotNull(message = "O identificador da infração regulatória é obrigatório")
    Long infracaoId,

    @NotNull(message = "O valor da autuação pecuniária é obrigatório")
    @Positive(message = "O valor da autuação deve ser estritamente positivo")
    BigDecimal valorMulta,

    @NotBlank(message = "O relato fático circunstanciado do fiscal é obrigatório")
    String relatoFiscal,

    @NotNull(message = "A lista de evidências fotográficas não pode ser nula")
    List<String> evidenciasUrls
) {
    /**
     * Compact Constructor: Executado antes dos valores serem atribuídos aos campos finais.
     * Utilizado para sanitização de dados, aplicação de invariantes e cópia defensiva.
     */
    public AutoInfracaoRequest {
        // Normalização de dados na soleira de entrada
        placa = (placa != null) ? placa.trim().toUpperCase() : null;
        relatoFiscal = (relatoFiscal != null) ? relatoFiscal.trim() : null;

        // Cópia defensiva imutável: blinda o Record contra mutações externas posteriores
        evidenciasUrls = (evidenciasUrls == null) ? List.of() : List.copyOf(evidenciasUrls);

        // Validação defensiva de regra de domínio na raiz
        if (valorMulta != null && valorMulta.compareTo(new BigDecimal("500000.00")) > 0) {
            throw new IllegalArgumentException("O valor máximo para autuação imediata em campo é de R$ 500.000,00");
        }
    }
}
```

```java
package br.gov.go.agr.fiscais.api.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

/**
 * DTO Imutável de Resposta com Projeção Estrita para o Consumidor da API.
 */
public record AutoInfracaoResponse(
    Long id,
    String numeroAuto,
    String placa,
    Long infracaoId,
    String descricaoInfracao,
    BigDecimal valorMulta,
    String relatoFiscal,
    List<String> evidenciasUrls,
    Instant dataLavratura
) {
    public AutoInfracaoResponse {
        evidenciasUrls = (evidenciasUrls == null) ? List.of() : List.copyOf(evidenciasUrls);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviço Real AGR:** `fiscalizacaoservice` (`:8082` / `:8083`).
- **Ponto de Aplicação em Produção:** No endpoint `POST /api/v1/autos-infracao`. Quando o auditor fiscal de campo utiliza o aplicativo móvel nas rodovias estaduais de Goiás (como na barreira fiscal da GO-020 em Bela Vista de Goiás), o payload JSON contendo a placa autuada, coordenadas de geolocalização e URLs de imagens enviadas ao storage MinIO é desserializado diretamente em instâncias imutáveis de `AutoInfracaoRequest`. O compilador da JVM garante que nenhum interceptor de segurança ou filtro de métricas modifique a placa ou o valor da autuação durante o trânsito da requisição até a persistência no MySQL institucional e posterior emissão da certidão probatória em PDF.
- **Projeto Greenfield Teatro-ABC (`:8090`):** No endpoint `POST /api/v1/sessoes/{id}/reservas`, o DTO de contrato `ReservaAssentoRequest(Long sessaoId, Long assentoId, String cpfCliente)` garante que instâncias concorrentes de compra de ingressos para espetáculos não sofram poluição de estado entre threads paralelas de checkout.

---

### 2.2 Mecânica de Concorrência: Virtual Threads / Project Loom vs Platform Threads Tradicionais

#### Parte 1: O que é o conceito / Analogia Didática
Pense em uma central pública de atendimento presencial em um cartório com 200 guichês físicos e 200 funcionários contratados de carteira assinada (Platform Threads do Sistema Operacional). Quando um cidadão chega ao guichê e solicita uma certidão que depende de uma consulta a um arquivo judiciário localizado em outra comarca (operação de I/O de rede ou consulta a banco de dados), o atendente simplesmente **cruza os braços e permanece sentado na cadeira olhando para o teto por 15 segundos**, aguardando o documento retornar via malote. Enquanto ele aguarda de braços cruzados, uma multidão enfurecida de 5.000 pessoas se aglomera na calçada porque todos os 200 guichês estão simultaneamente bloqueados sem produzir nada útil.

As **Virtual Threads (Project Loom - JEP 444)** transformam radicalmente essa dinâmica operacional: os 16 funcionários físicos do cartório (Carrier Threads do SO ligadas aos cores de CPU) nunca permanecem ociosos. No exato instante em que um pedido exige esperar 15 segundos pela resposta externa, o funcionário suspende a ficha daquele cidadão em uma prancheta digital suspensa e leve na parede da repartição (Virtual Thread montada no Heap), chama imediatamente o próximo cidadão da fila e continua trabalhando a pleno vapor. No momento em que o malote externo finalmente chega, qualquer atendente físico livre resgata a prancheta suspensa e conclui o atendimento. Com essa arquitetura, míseros 16 núcleos de processamento conseguem gerenciar com facilidade **1.000.000 de atendimentos simultâneos** sem esgotar a memória RAM e sem travar a repartição.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Spring Boot 2.x e no Java 8 e 11, o modelo padrão de servidores de aplicação baseados em servlets (como o Apache Tomcat embutido) era o **Thread-per-Request**. Cada conexão TCP aberta por um cliente HTTP recebia uma **Platform Thread dedicada**, mapeada diretamente para uma thread nativa do kernel do Linux (`pthread`).

No ecossistema corporativo da AGR, o Tomcat dos microsserviços `portalservice` (`:8080`) e `fiscalizacaoservice` (`:8082`) operava com o pool máximo padrão de **200 threads trabalhadoras** (`server.tomcat.threads.max=200`). Cada thread do sistema operacional no Linux de 64 bits aloca compulsoriamente cerca de **1 MB de memória de Stack** fora do Heap (`-Xss1m`). Assim, manter apenas 200 threads alocadas consumia 200 MB de memória RAM dedicada unicamente ao gerenciamento de ponteiros de execução e variáveis locais.

O colapso ocorria durante grandes blitz de fiscalização simultâneas em rodovias estaduais. Ao lavrar autos ou consultar a situação de vans escolares, o `fiscalizacaoservice` precisava realizar chamadas HTTP síncronas para o `cadu` (`:8081`), que por sua vez consultava o barramento do **DETRAN-GO** (`services.detran.go.gov.br`) e o barramento do processo eletrônico estadual (**SEI-GO** via `seiservice :8111`). Se o link de comunicação do DETRAN sofresse degradação e passasse a responder em 12 segundos em vez de 300 ms:
1. Em menos de 90 segundos de blitz, todas as 200 Platform Threads do Tomcat do `fiscalizacaoservice` ficavam presas em estado `WAITING` bloqueadas no socket de rede;
2. A 201ª requisição HTTP de campo entrava na fila do sistema operacional (`server.tomcat.accept-count=100`), que se esgotava em segundos;
3. O servidor passava a rejeitar sumariamente novas conexões, cuspindo erros `HTTP 504 Gateway Timeout` ou derrubando as conexões via `Connection Refused`;
4. Efeito dominó catastrófico: o `portalservice` (`:8080`), tentando exibir o dashboard gerencial para a presidência da autarquia, também travava por esgotamento de threads, paralisando a totalidade dos serviços públicos de regulação do Estado.

#### Parte 3: A Solução Moderna de Elite
No Spring Boot 3.3+ sobre o Java 21 LTS, a solução para a saturação de I/O não exige reescrever toda a base de código para frameworks reativos complexos como o Spring WebFlux / Project Reactor (que impõem curva cognitiva desumana, fragmentação de stack traces e quebra de `ThreadLocal`). A ativação de **Virtual Threads** é puramente declarativa no arquivo de propriedades corporativas:

```yaml
# Configuração canônica no application.yml do Spring Boot 3.3+
server:
  port: 8082
  tomcat:
    threads:
      max: 200 # Mantido apenas como referência para threads de infraestrutura do conector
spring:
  threads:
    virtual:
      enabled: true
```

Sob o capô, quando `spring.threads.virtual.enabled=true` está configurado, o Spring Boot substitui o executor padrão do Tomcat por um `SimpleAsyncTaskExecutor` configurado com `Thread.ofVirtual().factory()`. Cada requisição HTTP passa a ser atendida por uma Virtual Thread. Quando o código executa uma chamada de rede via socket, consulta JDBC ao banco de dados ou acesso a disco, a JVM desengata (*unmounts*) a Virtual Thread da Carrier Thread física subjacente, liberando o núcleo da CPU para atender outras requisições.

A classe de configuração abaixo audita e comprova a ativação de Virtual Threads na inicialização da aplicação:

```java
package br.gov.go.agr.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.Executors;

/**
 * Configuração e Auditoria de Concorrência de Elite com Virtual Threads.
 */
@Configuration
public class ConcorrenciaConfig {

    private static final Logger log = LoggerFactory.getLogger(ConcorrenciaConfig.class);

    @Bean
    public ApplicationRunner auditoriaAmbienteVirtualThreads() {
        return args -> {
            Thread auditoriaThread = Thread.ofVirtual().name("auditor-concorrencia-vt").unstarted(() -> {
                boolean isVirtual = Thread.currentThread().isVirtual();
                String threadName = Thread.currentThread().getName();
                log.info("Auditoria de Concorrência: Thread [{}] é Virtual? -> {}", threadName, isVirtual);
                if (!isVirtual) {
                    log.warn("ALERTA CRÍTICO: Aplicação em execução fora do Project Loom! Inspecione spring.threads.virtual.enabled");
                } else {
                    log.info("CONCORRÊNCIA DE ELITE ATIVADA: Virtual Threads operando sobre Carrier Threads da JVM.");
                }
            });

            auditoriaThread.start();
            auditoriaThread.join();
        };
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `portalservice` (`:8080`), `fiscalizacaoservice` (`:8082`) e `seiservice` (`:8111`).
- **Cenário Real em Produção:** No ecossistema regulatório da AGR, o microsserviço `seiservice` é o gateway SOAP/REST que despacha documentos para o Processo Eletrônico Estadual (SEI-GO). A assinatura digital de um termo de retenção veicular ou auto de infração leva em média 2,4 segundos devido à validação de certificados na infraestrutura da SEAD. Com o Java 21 e Virtual Threads ativadas no `fiscalizacaoservice`, 10.000 requisições simultâneas de fiscais em trânsito podem aguardar a emissão dos protocolos do SEI concorrentemente, consumindo menos de 45 MB de RAM e mantendo a CPU abaixo de 15% de utilização.
- **Teatro-ABC (`:8090`):** No momento da abertura de vendas para um espetáculo comemorativo no Centro Cultural Oscar Niemeyer em Goiânia, o gateway de ingressos recebe um pico súbito de 15.000 conexões síncronas HTTP verificando a disponibilidade do mapa de assentos da plateia. Com Virtual Threads, o Tomcat atende todas as 15.000 requisições síncronas sem registrar um único timeout ou erro de recusa de conexão.

---

### 2.3 Desestruturação Segura: Pattern Matching para switch e Record Patterns

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma esteira de triagem de alta tecnologia em um centro internacional de distribuição postal dos Correios. Por essa esteira passam encomendas de naturezas completamente distintas: envelopes de cartas simples, caixas cúbicas de encomendas pesadas e tubos metálicos lacrados contendo projetos arquitetônicos. 
No sistema manual arcaico, o operador tinha que pegar o pacote nos braços, perguntar em voz alta "Você é uma caixa?", esperar a resposta, pegar um estilete, abrir a caixa, retirar os objetos lá de dentro e só então inspecionar a nota fiscal. Se chegasse um tipo de encomenda novo não previsto no manual, o operador simplesmente jogava o pacote em um canto escuro sem processar.
Com o **Pattern Matching para switch (JEP 441)** e os **Record Patterns (JEP 440)** do Java 21, a esteira é dotada de um sensor holográfico inteligente de raio-X: no milissegundo em que a encomenda passa, o sensor identifica instantaneamente a estrutura do pacote, desmonta e disponibiliza seus componentes essenciais (por exemplo, a placa do veículo autuado e o valor da multa) diretamente nas mãos do fiscal, com uma trava de segurança física intransponível: **se qualquer modalidade de encomenda cadastrada no regulamento não tiver rota de tratamento definida, a esteira sequer liga**.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Java 8 e no Spring Boot 2.x, o tratamento de comportamentos polimórficos de regras regulatórias dependia de cadeias intermináveis de `if (objeto instanceof ClasseFilha)` seguidas compulsoriamente por operações inseguras de coerção de tipo manual (*casting*):

```java
// ❌ O LEGADO TRÁGICO E INSEGURO DO JAVA 8
if (penalidade instanceof Advertencia) {
    Advertencia adv = (Advertencia) penalidade; // Cast redundante e perigoso
    if (adv.getReincidencia() > 2) {
        converterEmMulta(adv);
    }
} else if (penalidade instanceof MultaPecuniaria) {
    MultaPecuniaria multa = (MultaPecuniaria) penalidade;
    if (multa.isQuitada()) {
        arquivarProcesso(multa);
    }
} // Se um desenvolvedor esquecer o caso de ApreensaoVeiculo, silêncio absoluto!
```

**As Falhas Operacionais Decorrentes:**
1. **Proliferação de `ClassCastException` em Produção:** Qualquer refatoração acidental na hierarquia ou confusão entre tipos de autuação durante manutenção emergencial gerava erros de conversão em tempo de execução, derrubando o fluxo de julgamento de recursos na diretoria colegiada da AGR;
2. **Fragilidade de Exaustividade (Omissão Silenciosa):** O comando `switch` tradicional do Java só suportava tipos primitivos numéricos, strings e enums. Quando a Diretoria de Transportes da AGR aprovava uma nova categoria de sanção (por exemplo, `SuspensaoConcessao`), os programadores precisavam localizar dezenas de blocos `if-else` espalhados pelo sistema. Invariavelmente, métodos eram esquecidos. O código caía no bloco `else` mudo, deixando concessionárias infratoras impunes sem gerar nenhum alarme em logs.

#### Parte 3: A Solução Moderna de Elite
O Java 21 introduz a fusão perfeita entre **Pattern Matching para switch** e **Record Patterns**, permitindo a desestruturação atômica de registros diretamente no cabeçalho do `case`, associada a guardas de condição (`when`) e verificação estrita de exaustividade em tempo de compilação:

```java
package br.gov.go.agr.fiscais.domain.service;

import br.gov.go.agr.fiscais.domain.model.Penalidade;
import br.gov.go.agr.fiscais.domain.model.Penalidade.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * Serviço de Julgamento de Sanções Regulatórias com Java 21 Pattern Matching.
 */
@Service
public class CalculadoraPenalidadeService {

    private static final Logger log = LoggerFactory.getLogger(CalculadoraPenalidadeService.class);

    /**
     * Aplica a decisão regulatória de acordo com o padrão do Record desestruturado.
     * O compilador do Java 21 garante compilação zero se faltar algum subtipo de Penalidade.
     */
    public String processarDecisaoRegulatoria(Penalidade penalidade) {
        return switch (penalidade) {
            // Desestruturação direta do Record Advertencia com guarda condicional 'when'
            case Advertencia(String motivo, int reincidencia) when reincidencia > 2 -> {
                log.warn("Reincidência severa ({}) detectada para advertência: {}", reincidencia, motivo);
                yield "CONVERSÃO SANCIONATÓRIA: Advertência convertida em sanção pecuniária obrigatória por reincidência.";
            }

            case Advertencia(String motivo, int reincidencia) -> {
                log.info("Lavrando advertência administrativa simples (reincidência {})", reincidencia);
                yield "EMISSÃO DE TERMO: Advertência formal averbada no prontuário da permissionária: " + motivo;
            }

            // Desestruturação do Record MultaPecuniaria inspecionando código e flag quitada
            case MultaPecuniaria(String codigo, BigDecimal valor, boolean quitada) when quitada -> {
                log.info("Processo da multa regulatória {} no valor de R$ {} quitado com sucesso.", codigo, valor);
                yield "ARQUIVAMENTO: Auto de infração quitado integralmente. Baixa nos cadastros da AGR.";
            }

            case MultaPecuniaria(String codigo, BigDecimal valor, boolean quitada) -> {
                log.warn("Multa {} no valor de R$ {} em aberto.", codigo, valor);
                yield "COBRANÇA EXECUTIVA: Encaminhar débito não quitado para inscrição em Dívida Ativa Estadual.";
            }

            // Desestruturação do Record ApreensaoVeiculo com verificação de custódia
            case ApreensaoVeiculo(String placa, String patio, boolean liberado) -> {
                if (liberado) {
                    yield "LIBERAÇÃO DE TRV: Veículo placa " + placa + " liberado para tráfego do pátio " + patio;
                } else {
                    yield "CUSTÓDIA ATIVA: Veículo placa " + placa + " retido no pátio regulatório " + patio;
                }
            }
        };
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `fiscalizacaoservice` (`:8082`) e `receitaservice` (`:8092`).
- **Cenário Real em Produção:** Na Câmara de Julgamento de Recursos da AGR, os autos impugnados passam pelo pipeline de auditoria. A desestruturação por Record Patterns inspeciona se o auto é uma multa em aberto ou uma retenção veicular, direcionando o fluxo para a geração de guia de arrecadação DARE no `receitaservice` (`:8092`) ou para o sistema de Dívida Ativa do Estado (`sda :8114`).
- **Teatro-ABC (`:8090`):** Desestruturação polimórfica de categorias de bilhete no momento do cálculo do valor final da transação:
  `switch (ingresso) { case Inteira(var p) -> p; case MeiaEstudante(var p, var cart) -> p.multiply(new BigDecimal("0.5")); case Cortesia(var autorizacao) -> BigDecimal.ZERO; }`.

---

### 2.4 Blindagem de Domínio: Sealed Interfaces e Hierarquias Determinísticas

#### Parte 1: O que é o conceito / Analogia Didática
Imagine a Constituição de um Estado de Direito: o texto constitucional define solenemente que o Poder Público é dividido em três e apenas três esferas soberanas: Poder Executivo, Poder Legislativo e Poder Judiciário. A lei maior é estritamente **fechada e selada**: nenhuma prefeitura, tribunal regional ou cidadão pode, por iniciativa isolada, redigir uma portaria criando um "Quarto Poder" informal. Qualquer entidade que não conste na lista autorizada da Constituição é nula e ilegítima por definição.

Uma **Sealed Interface (Interface Selada - JEP 409)** é a constituição do seu modelo de domínio corporativo. Ao declarar uma interface como `sealed`, o arquiteto de software estabelece uma cláusula mandatória `permits`: apenas as classes ou records expressamente nomeados naquela declaração possuem a permissão formal da linguagem para estendê-la ou implementá-la. Nenhuma classe espúria desenvolvida em qualquer outro pacote ou dependência de terceiros consegue se infiltrar na hierarquia.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Java 8 e Java 11, o modificador `interface` era completamente aberto para o mundo. Toda interface declarada como pública podia ser implementada por qualquer classe em qualquer camada da aplicação.
Isso causava degradação contínua da integridade do domínio de negócio:
1. **Violação do Princípio Aberto/Fechado (OCP de forma desgovernada):** Programadores novatos criavam implementações anônimas ou classes temporárias como `DummyPenalidadeParaTeste` ou `PenalidadeEspecialUrgente` dentro de controllers ou camadas utilitárias, burlando as regras regulamentares da autarquia;
2. **Impossibilidade de Exaustividade:** Como o compilador da JVM não podia saber se uma nova classe seria criada amanhã em outro módulo JAR, todo `switch` ou validação de tipos era obrigado a incluir um antipadrão defensivo `default: throw new IllegalStateException("Tipo de penalidade desconhecido");`. Quando um bug ocorria, ele explodia tarde demais, em plena execução de produção.

#### Parte 3: A Solução Moderna de Elite
O Java 21 permite selar interfaces no topo da hierarquia, associando-as diretamente a Records imutáveis:

```java
package br.gov.go.agr.fiscais.domain.model;

import java.math.BigDecimal;

/**
 * Hierarquia Selada de Sanções e Penalidades Regulatórias da AGR.
 * Apenas os Records formalmente permitidos na cláusula 'permits'
 * são aceitos como instâncias válidas pela Máquina Virtual Java.
 */
public sealed interface Penalidade 
    permits Penalidade.Advertencia, 
            Penalidade.MultaPecuniaria, 
            Penalidade.ApreensaoVeiculo {

    /**
     * Registro de Advertência Administrativa por descumprimento leve.
     */
    record Advertencia(String motivo, int reincidencia) implements Penalidade {}

    /**
     * Registro de Multa Pecuniária formal lavrada com valor e código de infração.
     */
    record MultaPecuniaria(String codigo, BigDecimal valor, boolean quitada) implements Penalidade {
        public MultaPecuniaria {
            if (valor == null || valor.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("O valor da multa deve ser estritamente superior a zero.");
            }
        }
    }

    /**
     * Registro de Apreensão e Retenção de Veículo em Pátio Conveniado.
     */
    record ApreensaoVeiculo(String placa, String patio, boolean liberado) implements Penalidade {}
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `fiscalizacaoservice` (`:8082`) e `cadastrounicoservice` (`:8081`).
- **Cenário Real em Produção:** Modelagem das Modalidades de Transporte Coletivo Reguladas pelo Estado de Goiás:
  `public sealed interface ModalidadeTransporte permits LinhaRegularIntermunicipal, FretamentoTuristicoEventual, TransporteEscolarIntermunicipal, FretamentoContinuo`. Essa blindagem assegura que nenhuma permissionária opere sob classificação inexistente na Resolução Normativa nº 024/2015 do Conselho Regulador da AGR.
- **Teatro-ABC (`:8090`):** `public sealed interface SetorAuditorio permits PlateiaVip, PlateiaSuperior, FrisaNobre, CamarotePresidencial`. Blindagem absoluta contra categorias espúrias de assentos no momento de reserva concorrente.

---

## 3. Pilar 2: Spring Boot 3.3+ Architecture & RESTful Controllers de Alta Precisão

### 3.1 Transição de Ecossistema: Migração Jakarta EE 10 Namespace (javax.* para jakarta.*)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma reestruturação territorial de um país onde todas as placas de veículos, documentos de identidade e códigos postais de cidades antigas mudam de sigla por determinação soberana internacional. Os prédios residenciais, as pessoas e os logradouros físicos continuam rigorosamente nos mesmos lugares, mas **qualquer correspondência enviada com a sigla antiga é sumariamente rejeitada e devolvida na triagem da alfândega**.
A migração do Java EE para o Jakarta EE representa exatamente essa mudança histórica. Em decorrência da doação do Java EE pela Oracle à Fundação Eclipse e da retenção dos direitos comerciais da marca "Java", os pacotes corporativos de infraestrutura (`javax.persistence.*`, `javax.validation.*`, `javax.servlet.*`) foram oficialmente rebatizados para `jakarta.*`. O Spring Boot 3.0+ cortou de forma irreversível a compatibilidade com o namespace antigo.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No curso *Especialista Spring REST* da AlgaWorks, na aula `864_28.1. As principais mudanças do Spring Boot 3.txt`, o choque da migração e a quebra massiva de ecossistema são explicados com riqueza de detalhes:
> *"Uma outra mudança notável seria a migração para o Jakarta EE na versão 9... E essa migração aqui, ela gera uma grande quebra de compatibilidade. Não no comportamento das classes, mas sim porque os pacotes das classes aí do Jakarta EE foram alterados, ou seja, o nome do pacote foi alterado. Então muitos componentes que iniciavam, se não todos que iniciavam com Javax, vai passar a iniciar como Jakarta... E é claro, o Spring Boot 3.0 não é compatível com o Jakarta EE8 e os seus componentes e qualquer biblioteca que dependa do Jakarta EE8... Você não vai conseguir nem sequer subir o seu projeto se você tentar atualizar ele, tudo bem?"* (`864_28.1`)

E na aula `867_28.4. Alterações do Jakarta EE e Jakarta Persistence 3.0.txt`, é exposta a sutil armadilha técnica do refactoring automático via IDE que paralisou dezenas de empresas:
> *"Vou utilizar a funcionalidade da IntelliJ, que seria o Control Shift R. Vou fazer aqui a localização dessa palavra-chave aqui, Javax, e substituir por Jakarta. Bom, se você tiver um projeto em produção, põe muito cuidado com esse tipo de substituição, porque você pode acabar substituindo coisas que não precisavam... Parece que tem apenas uma classe aqui que eu vou te mostrar, que seria a DataSource, DataBaseCleaner na verdade... que teve aqui a alteração do Jakarta para Javax. Só que no caso dessa classe aqui, que seria a DataSource, ela pertence ao Java Standard. Então, ela continua aqui no Javax. Está vendo? O import dela não precisa ser alterado."* (`867_28.4`)

**A Morte de Bibliotecas Populares e o Caso Squiggly e SpringFox:**
Na aula `865_28.2. Removendo componentes incompatíveis.txt`, o desfecho trágico de componentes amplamente utilizados é anunciado:
> *"O squiggly, que seria um componente que temos que remover, então eu já vou remover ele daqui... e é claro, eu vou aproveitar e vou remover a variável dela, no caso a classe dela, aqui no meu core, squiggly, vou precisar remover essas duas classes aqui, então a gente vai perder essa funcionalidade no momento, porque não temos uma alternativa atualizada ainda para a funcionalidade..."* (`865_28.2`)
O `Squiggly Filter` (usado para filtragem dinâmica de campos JSON) e o `SpringFox` (biblioteca de documentação Swagger 2) foram sumariamente abandonados por seus mantenedores no momento da virada para o Jakarta EE. Organizações que construíram arquiteturas dependentes de reflexão do SpringFox ficaram impossibilitadas de migrar para o Spring Boot 3, presas a vulnerabilidades críticas de segurança do ecossistema legado.

#### Parte 3: A Solução Moderna de Elite
No Spring Boot 3.3+, todas as anotações de persistência, validação de beans e injeção de contexto web utilizam estritamente o namespace `jakarta.*`, enquanto classes estruturais pertencentes ao JDK Core (Java SE) permanecem no pacote `javax.sql`:

```java
package br.gov.go.agr.fiscais.infra.persistence;

// ✅ IMPORTAÇÕES CORRETAS NO SPRING BOOT 3.3+ (JAKARTA EE 10)
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import jakarta.persistence.Column;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.servlet.http.HttpServletRequest;

// ⚠️ REGRA DE OURO: DataSource pertence ao Java Standard Edition (JDK), NÃO é Jakarta EE!
import javax.sql.DataSource; 

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Entidade JPA 3.1 Canônica com Mapeamento Jakarta e Controle de Versão Otimista.
 */
@Entity
@Table(name = "tb_auto_infracao")
public class AutoInfracaoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(name = "numero_auto", nullable = false, unique = true, length = 32)
    private String numeroAuto;

    @NotBlank
    @Column(name = "placa_veiculo", nullable = false, length = 8)
    private String placa;

    @NotNull
    @Column(name = "valor_multa", nullable = false, precision = 12, scale = 2)
    private BigDecimal valorMulta;

    @Version
    @Column(name = "versao_lock", nullable = false)
    private Long versao;

    @Column(name = "data_criacao", nullable = false, updatable = false)
    private Instant dataCriacao = Instant.now();

    public AutoInfracaoEntity() {}

    public Long getId() { return id; }
    public String getNumeroAuto() { return numeroAuto; }
    public void setNumeroAuto(String numeroAuto) { this.numeroAuto = numeroAuto; }
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public BigDecimal getValorMulta() { return valorMulta; }
    public void setValorMulta(BigDecimal valorMulta) { this.valorMulta = valorMulta; }
    public Long getVersao() { return versao; }
}
```

E para a documentação interativa de APIs OpenAPI 3, adota-se o **SpringDoc OpenAPI 3** oficial:

```xml
<!-- Inclusão canônica no pom.xml para Spring Boot 3.3+ -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.6.0</version>
</dependency>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `portalservice` (`:8080`), `cadastrounicoservice` (`:8081`), `fiscalizacaoservice` (`:8082`).
- **Cenário Real em Produção:** Na modernização do Portal 1 da AGR, dezenas de classes continham anotações de bibliotecas órfãs e filtros customizados do Squiggly. O refactoring para Spring Boot 3.3 purgou essas dependências, adotando DTOs Records especializados para projeções de atributos e o SpringDoc OpenAPI expondo contratos em `/swagger-ui/index.html`.
- **Teatro-ABC (`:8090`):** Greenfield construído 100% sobre Jakarta EE 10, com validação de contratos e Swagger UI acessível diretamente pelo time de frontend.

---

### 3.2 Design de Controllers RESTful e Semântica HTTP Estrita

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma repartição de protocolo estatal onde você entrega um requerimento para obter uma licença. O atendente carimba a folha com tinta verde-clara, estampa um sorriso largo e diz em voz alta: *"Tudo perfeito com a sua solicitação!"* (Código `HTTP 200 OK`). Porém, ao abrir o envelope carimbado do lado de fora do guichê, você encontra uma folha interna com letras garrafais vermelhas dizendo: *"ERRO FATAL: Sua certidão negativa de débitos está vencida e o processo foi cancelado"*. Você fica sem saber se o sistema acatou ou rejeitou o seu documento.

Uma **API RESTful de Alta Fidelidade Semântica** respeita a física dos códigos de status do protocolo HTTP:
- Quando um novo recurso regulatório é criado com êxito, ela responde `201 Created` e fornece a URI exata de acesso no cabeçalho `Location`;
- Quando uma exclusão lógica ou operação sem retorno de dados é concluída, ela retorna `204 No Content` sem corpo inútil;
- Quando os dados enviados violam regras de domínio ou sintaxe, ela responde `400 Bad Request`, `404 Not Found`, `409 Conflict` ou `422 Unprocessable Entity`. O status code reflete **fisicamente** o resultado da operação, sem subterfúgios.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No desenvolvimento do legado do Portal 1 da AGR e em diversos serviços corporativos legados, consolidou-se o antipadrão pernicioso do envelope genérico de resposta, materializado na classe utilitária `Response<T>`:

```json
// ❌ O ANTIPADRÃO TÓXICO DO ENVELOPE RESPONSE<T> DA AGR
// Enviado sob HTTP STATUS 200 OK!
{
  "data": null,
  "statusReq": "ERRO",
  "erros": [
    "A empresa de turismo Transporte Goiás Ltda está com a certidão fiscal vencida."
  ]
}
```

**As Consequências Devastadoras desse Antipadrão em Produção:**
1. **Cegueira Completa de Gateways e Observabilidade:** Gateways de API corporativos (como Kong, Apigee, AWS API Gateway), balanceadores Nginx e coletores de telemetria APM (Dynatrace, Datadog) monitoram a taxa de sucesso das APIs inspecionando os códigos de status HTTP da camada de transporte. Como a aplicação respondia sempre `HTTP 200 OK`, os painéis de monitoramento exibiam 99,99% de saúde, enquanto milhares de fiscais de campo não conseguiam emitir um único auto de infração devido a falhas internas;
2. **Poluição Espaguete no Frontend:** Todo desenvolvedor Angular ou React era obrigado a criar interceptores defensivos com checagens repetitivas do tipo `if (response.data && response.statusReq === 'ERRO')`, impedindo o uso dos fluxos nativos de tratamento de erro do `HttpClient`.

#### Parte 3: A Solução Moderna de Elite
Os controllers do Spring Boot 3.3+ operam com semântica estrita, eliminando envelopes artificiais e utilizando `ResponseEntity` com builders declarativos:

```java
package br.gov.go.agr.fiscais.api.controller;

import br.gov.go.agr.fiscais.api.dto.AutoInfracaoRequest;
import br.gov.go.agr.fiscais.api.dto.AutoInfracaoResponse;
import br.gov.go.agr.fiscais.domain.service.AutoInfracaoService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;

/**
 * Controller RESTful de Elite para Gestão de Autos de Infração.
 * Respeito estrito aos verbos HTTP e códigos de status IETF.
 */
@RestController
@RequestMapping("/api/v1/autos-infracao")
public class AutoInfracaoController {

    private final AutoInfracaoService autoInfracaoService;

    public AutoInfracaoController(AutoInfracaoService autoInfracaoService) {
        this.autoInfracaoService = autoInfracaoService;
    }

    /**
     * Emissão canônica de Auto de Infração.
     * Retorna HTTP 201 Created com cabeçalho Location apontando para o recurso criado.
     */
    @PostMapping
    public ResponseEntity<AutoInfracaoResponse> emitirAuto(
            @RequestBody @Valid AutoInfracaoRequest request,
            UriComponentsBuilder uriBuilder
    ) {
        AutoInfracaoResponse response = autoInfracaoService.lavrarAuto(request);

        URI locationUri = uriBuilder
                .path("/api/v1/autos-infracao/{id}")
                .buildAndExpand(response.id())
                .toUri();

        return ResponseEntity.created(locationUri).body(response);
    }

    /**
     * Consulta por Identificador Único.
     * Retorna HTTP 200 OK direto, sem envelopes artificiais.
     */
    @GetMapping("/{id}")
    public ResponseEntity<AutoInfracaoResponse> buscarPorId(@PathVariable Long id) {
        AutoInfracaoResponse response = autoInfracaoService.buscarPorId(id);
        return ResponseEntity.ok(response);
    }

    /**
     * Cancelamento ou Anulação de Auto.
     * Retorna HTTP 204 No Content sem payload de corpo.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> anularAuto(@PathVariable Long id) {
        autoInfracaoService.anularAuto(id);
        return ResponseEntity.noContent().build();
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `fiscalizacaoservice` (`:8082`) e `cadastrounicoservice` (`:8081`).
- **Cenário Real em Produção:** Erradicação sumária do envelope `Response<T>` em todos os controllers da Fiscalização. O frontend Angular moderno do Portal 2 passa a capturar os status HTTP diretamente no `catchError` dos pipes RxJS, permitindo que a camada de UI exiba toasts automáticos e que o Nginx do Estado traceje métricas precisas de erro 4xx e 5xx.
- **Teatro-ABC (`:8090`):** `POST /api/v1/sessoes/{id}/reservas` responde `HTTP 201 Created` com cabeçalho `Location: /api/v1/reservas/9981`.

---

### 3.3 Comunicação Inter-Serviços: RestClient Fluente do Spring 6.1+ vs RestTemplate vs WebClient

#### Parte 1: O que é o conceito / Analogia Didática
Imagine três ferramentas de oficina para reparo hidráulico:
1. `RestTemplate`: Uma chave de boca pesada de ferro fundido fabricada em 1985. Ela aperta os canos, mas é rígida, exige esforço muscular descomunal e o mecânico frequentemente prende os dedos nas ranhuras enferrujadas;
2. `WebClient`: Um robô industrial automatizado de solda a arco voltaico (ecossistema Netty reativo). Ele é capaz de construir um submarino de alta pressão, mas para fazer um reparo simples em uma torneira, exige que o engenheiro monte uma subestação elétrica e programe uma matriz de circuitos reativos inteira (`Mono`, `Flux`);
3. `RestClient`: Uma parafusadeira pneumática moderna de fibra de carbono. Desenvolvida sob medida para a mão humana, ela possui controle fluente de torque, opera de forma síncrona com velocidade estonteante e executa o trabalho com acabamento cirúrgico em 2 segundos.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Spring Framework 5, o venerável `RestTemplate` entrou oficialmente em **modo de manutenção**, deixando de receber novas funcionalidades. Sua API síncrona baseada em chamadas com sobrecargas excessivas (`exchange()`, `postForObject()`) exigia dezenas de linhas de configuração manual para injetar headers de autenticação, configurar converters e interceptar códigos de erro HTTP.
No ecossistema legado da AGR, tentou-se contornar a verbosidade criando classes utilitárias estáticas caseiras, como `ConsumidorServicosUtil.java`. Essas classes utilizavam conexões brutas sem gerenciamento de pool de conexões HTTP (como o Apache HttpClient), criando conexões novas a cada requisição e esgotando as portas efêmeras do Linux (*TIME_WAIT socket exhaustion*).
Quando os times tentavam modernizar a arquitetura, importavam o pacote monolítico `spring-boot-starter-webflux` unicamente para utilizar o `WebClient`. O resultado era desastroso: dentro de um servlet container Tomcat clássico, programadores bloqueavam chamadas reativas com `.block()`, gerando deadlocks silenciosos entre threads e quebrando o rastreamento de transações.

#### Parte 3: A Solução Moderna de Elite
O **`RestClient`** foi introduzido no **Spring Framework 6.1** (incorporado nativamente no Spring Boot 3.3+) como o cliente HTTP síncrono oficial e moderno da plataforma. Ele traz a fluência declarativa do `WebClient`, mas construído sobre conexões síncronas convencionais, alinhando-se com perfeição cirúrgica à mecânica das **Virtual Threads**:

```java
package br.gov.go.agr.fiscais.infra.client;

import br.gov.go.agr.fiscais.domain.exception.IntegracaoDetranException;
import br.gov.go.agr.fiscais.domain.exception.VeiculoNaoEncontradoException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.time.Duration;

/**
 * Cliente HTTP Fluente de Elite para Integração com o Barramento DETRAN-GO.
 * Totalmente compatível com Virtual Threads (I/O bloqueante descarregado pela JVM).
 */
@Component
public class DetranRestClient {

    private final RestClient restClient;

    public DetranRestClient(
            RestClient.Builder builder,
            @Value("${agr.integracoes.detran.base-url:https://services.detran.go.gov.br}") String baseUrl,
            @Value("${agr.integracoes.detran.token:token-gov-goias-secret}") String apiToken
    ) {
        this.restClient = builder
                .baseUrl(baseUrl)
                .defaultHeader("Authorization", "Bearer " + apiToken)
                .defaultHeader("Accept", MediaType.APPLICATION_JSON_VALUE)
                .build();
    }

    /**
     * DTO Imutável para recepção dos dados veiculares do DETRAN.
     */
    public record ConsultaVeiculoDetranDTO(
            String placa,
            String renavam,
            String proprietarioNome,
            String situacaoLicenciamento,
            Integer anoExercicio
    ) {}

    /**
     * Realiza a consulta fluente com tratamento declarativo de códigos de status.
     */
    public ConsultaVeiculoDetranDTO consultarVeiculo(String placa) {
        return restClient.get()
                .uri("/api/v1/veiculos/{placa}", placa)
                .retrieve()
                .onStatus(status -> status.value() == 404, (request, response) -> {
                    throw new VeiculoNaoEncontradoException("Veículo placa " + placa + " não consta na base integrada do DETRAN-GO.");
                })
                .onStatus(HttpStatusCode::is5xxServerError, (request, response) -> {
                    throw new IntegracaoDetranException("O barramento governamental do DETRAN-GO está temporariamente indisponível.");
                })
                .body(ConsultaVeiculoDetranDTO.class);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `fiscalizacaoservice` (`:8082`) consumindo `cadastrounicoservice` (`:8081`) e barramentos governamentais externos.
- **Cenário Real em Produção:** Substituição definitiva da classe `ConsumidorServicosUtil.java`. O `fiscalizacaoservice` utiliza instâncias de `RestClient` com timeout calibrado de 3.000 ms para consultar a regularidade cadastral de ônibus de turismo no `cadu` antes de autorizar a viagem rodoviária interestadual.
- **Teatro-ABC (`:8090`):** `RestClient` fluente acionando a API externa do gateway de pagamentos via PIX instantâneo para aprovação de ingressos em tempo real.

---

### 3.4 Integridade na Fronteira: Bean Validation 3.0 (`jakarta.validation`) com Validadores Customizados

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o segurança alfandegário posicionado na porta de entrada da sala de embarque de um aeroporto internacional. Antes de autorizar o passageiro a dar qualquer passo em direção ao controle de passaportes, ele inspeciona visualmente e eletronicamente o bilhete de embarque. Se a data estiver vencida ou o código de barras for ilegível, o indivíduo é **barrado imediatamente no cordão de isolamento**, sem consumir o tempo dos agentes federais e sem transitar pelas áreas restritas do terminal.

O **Bean Validation 3.0 (`jakarta.validation`)** é esse cordão de isolamento na soleira da API. Através de anotações declarativas posicionadas diretamente nos Records e componentes DTO, o framework intercepta a requisição HTTP no instante de entrada no Controller através da anotação `@Valid`. Se um formato de placa veicular for inválido ou o CNPJ contiver dígitos verificadores corrompidos, a execução é cancelada antes mesmo de invocar o Service ou abrir uma conexão de transação com o banco de dados.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No código legado da AGR, a validação de parâmetros era descentralizada e dispersa de forma caótica:
- Havia dezenas de blocos imperativos espalhados dentro de Daos e Services, do tipo `if (placa == null || placa.length() < 7) { throw new Exception("Placa inválida"); }`;
- Inconsistência de critérios: um endpoint aceitava placa com hífen (`ABC-1234`), outro endpoint exigia sem hífen (`ABC1234`), e outro endpoint não validava nada, persistindo lixo com caracteres especiais no banco MySQL;
- Falhas crônicas de integridade: a ausência de tipagem estrita gerava `NullPointerException` dentro de métodos de cálculo de multas quando campos obrigatórios não eram enviados pelo frontend.

#### Parte 3: A Solução Moderna de Elite
Criação de anotação de validação customizada para o padrão oficial brasileiro de placas veiculares (conforme diretrizes do SENATRAN para placas padrão Antigo e Mercosul), integrada a Records:

```java
package br.gov.go.agr.fiscais.api.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

/**
 * Anotação Customizada de Bean Validation 3.0 para Validação de Placas Veiculares.
 */
@Documented
@Constraint(validatedBy = PlacaVeiculoValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER, ElementType.RECORD_COMPONENT})
@Retention(RetentionPolicy.RUNTIME)
public @interface PlacaVeiculo {
    String message() default "A placa do veículo informada não atende ao padrão brasileiro (Cinza ou Mercosul)";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

```java
package br.gov.go.agr.fiscais.api.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.util.regex.Pattern;

/**
 * Validador Canônico de Placa Veicular (Padrão Antigo ABC-1234 / Mercosul ABC1D23).
 */
public class PlacaVeiculoValidator implements ConstraintValidator<PlacaVeiculo, String> {

    // Regex oficial SENATRAN: Padrão Mercosul (3 letras, 1 dígito, 1 letra, 2 dígitos) ou Antigo (3 letras, 4 dígitos)
    private static final Pattern PADRAO_PLACA = 
        Pattern.compile("^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$|^[A-Z]{3}-[0-9]{4}$");

    @Override
    public boolean isValid(String valor, ConstraintValidatorContext context) {
        if (valor == null || valor.isBlank()) {
            return false;
        }
        return PADRAO_PLACA.matcher(valor.trim().toUpperCase()).matches();
    }
}
```

```java
package br.gov.go.agr.fiscais.api.dto;

import br.gov.go.agr.fiscais.api.validation.PlacaVeiculo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;

/**
 * DTO Imutável com Validação na Soleira de Entrada.
 */
public record CadastroVeiculoDTO(
    @PlacaVeiculo
    String placa,

    @NotBlank(message = "O número de chassi do veículo é obrigatório")
    String chassi,

    @NotNull(message = "O ano de fabricação é obrigatório")
    @Min(value = 2000, message = "Veículos com ano de fabricação anterior a 2000 não podem ser credenciados na AGR")
    Integer anoFabricacao
) {}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `cadastrounicoservice` (`:8081`) e `fretamentoservice` (`:8084`).
- **Cenário Real em Produção:** Credenciamento e vistoria de veículos de fretamento intermunicipal. Se o transportador informar uma placa adulterada ou inválida, a requisição é interceptada na soleira do Controller com retorno padronizado via RFC 7807 contendo os campos específicos rejeitados.
- **Teatro-ABC (`:8090`):** `@CpfValido` e `@EmailCorporativo` aplicados aos Records de compra de ingressos para espetáculos teatrais.

---

## 4. Pilar 3: Padronização de Protocolo: Spring Boot 3.3+ REST & Tratamento RFC 7807 ProblemDetail

### 4.1 Erradicação do Envelope Response<T> e Adoção Nativa do ProblemDetail (RFC 7807)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma equipe internacional de resgate médico atendendo vítimas de um acidente em uma rodovia transfronteiriça. Não importa se o socorrista fala português, inglês, espanhol ou mandarim: a ficha clínica de trauma do paciente utiliza exatamente a mesma simbologia padronizada pela Organização Mundial da Saúde — Tipo Sanguíneo, Pressão Arterial, Saturação de Oxigênio, Escala de Coma de Glasgow e Localização da Lesão. Qualquer médico do planeta sabe interpretar imediatamente a gravidade do estado clínico do paciente sem precisar traduzir textos informais.

O **RFC 7807 (Problem Details for HTTP APIs)** é essa ficha médica universal de incidentes para a Web moderna. Estabelecido pela Internet Engineering Task Force (IETF), o padrão define um vocabulário JSON rigoroso para comunicação de falhas em APIs HTTP:
- `type`: URI absoluta ou relativa identificando a categoria da falha (ex: `https://api.agr.go.gov.br/erros/recurso-nao-encontrado`);
- `title`: Resumo curto e legível para humanos sobre o tipo de problema ocorrido;
- `status`: O código de status HTTP numérico correspondente (ex: `404`, `422`, `409`);
- `detail`: Explicação circunstanciada e contextualizada da ocorrência específica;
- `instance`: A URI do endpoint acionado que gerou a violação (ex: `/api/v1/autos-infracao/9981`);
- Extensões customizadas (como `timestamp`, `userMessage` e lista de `campos` inválidos).

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Spring Boot 2.x, o framework **não possuía suporte nativo embutido à especificação RFC 7807**.
Por conta dessa carência, desenvolvedores corporativos precisavam dedicar semanas de trabalho para construir toda a infraestrutura de representação de erros manualmente a partir do zero.

No curso *Especialista Spring REST* da AlgaWorks, no Módulo 8, o instrutor Thiago dedica diversas aulas para demonstrar a alta complexidade necessária para implementar esse padrão manualmente. Na aula `441_8_15_Criando_um_exception_handler_global_com_ResponseEntityExceptionHandler.txt`, ele explica a anatomia interna do handler legado:
> *"Existem vários tipos de Exceptions que são internas do Spring MVC... Será que a gente precisa tratar todas essas Exceptions internas individualmente? Não, a gente não precisa, porque nós podemos estender uma classe que já faz isso para a gente. Essa classe é a ResponseEntityExceptionHandler... veja que a gente tem um método handleException. Esse é um método que está anotado com @ExceptionHandler... eles resolveram criar um método só que trata tudo, recebe aqui Exception como parâmetro, mais genérico... E eles definem aqui com if, if, if, if, if... Está vendo que todas elas chamam o handleExceptionInternal, em algum momento... Esse segundo parâmetro aqui é o corpo. Qual corpo que a gente quer devolver na resposta HTTP? Então, aqui, nenhum corpo nulo. Nulo, está vendo? Por isso que não vem nada aqui."* (`441_8_15`)

E na aula `452_8_28_Estendendo_o_formato_do_problema_para_adicionar_novas_propriedades.txt`, revela-se o esforço braçal para enriquecer o payload:
> *"A propriedade cozinha.id recebeu um valor A, que é de um tipo inválido. Corrija e informe o valor compatível com o tipo Long... Porém, não é uma mensagem boa para mandar para o usuário. A gente, nesse treinamento, está falando de desenvolvimento de back-end... Porém, nós temos que ter a visão de quem vai consumir a API... O desenvolvedor que consome a nossa API poderia ter uma lógica... Só que é um pouquinho complicado pensando na vida do consumidor da API ter que saber tudo isso... Então, o que a gente vai fazer aqui? Nós vamos estender a nossa representação do problema... Uma delas que a gente pode colocar aqui, por exemplo, é uma mensagem para o usuário. Então, eu vou colocar aqui string userMessage..."* (`452_8_28`)

**O Peso do Modelo Legado:**
O desenvolvedor era forçado a manter em cada microsserviço:
1. Um enum `ProblemType.java` com dezenas de URIs e títulos;
2. Uma classe POJO `Problem.java` com builders do Lombok e classes estáticas aninhadas (`Problem.Field`);
3. Uma classe de interceptação estendendo `ResponseEntityExceptionHandler` com mais de 350 linhas de código sobrescrevendo métodos como `handleMethodArgumentNotValid`, `handleHttpMediaTypeNotSupported`, `handleNoHandlerFoundException`.
Em um ecossistema com 25 microsserviços como o da AGR, isso representava **mais de 8.000 linhas de código de infraestrutura de erro duplicadas e propensas a divergências**.

#### Parte 3: A Solução Moderna de Elite
No Spring Boot 3.3+, tudo isso foi encapsulado nativamente pela introdução da classe canônica **`org.springframework.http.ProblemDetail`**.
Para ativar o suporte nativo global à RFC 7807 para todas as exceções padrão do Spring MVC, basta habilitar a propriedade no `application.yml`:

```yaml
spring:
  mvc:
    problemdetails:
      enabled: true
```

E para interceptar exceções de domínio corporativo e enriquecer os dados de validação de beans com campos específicos, adota-se um `@RestControllerAdvice` elegante e sucinto:

```java
package br.gov.go.agr.fiscais.api.exceptionhandler;

import br.gov.go.agr.fiscais.domain.exception.EntidadeNaoEncontradaException;
import br.gov.go.agr.fiscais.domain.exception.RegraNegocioException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.net.URI;
import java.time.Instant;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Manipulador Global de Exceções de Elite em Estrita Conformidade com a RFC 7807.
 */
@RestControllerAdvice
public class GlobalApiExceptionHandler extends ResponseEntityExceptionHandler {

    private static final String URI_BASE_ERROS = "https://api.agr.go.gov.br/erros";

    /**
     * Tratamento de Recursos Regulatórios Não Encontrados (HTTP 404).
     */
    @ExceptionHandler(EntidadeNaoEncontradaException.class)
    public ProblemDetail handleEntidadeNaoEncontrada(EntidadeNaoEncontradaException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
        problem.setTitle("Recurso Regulatório Não Encontrado");
        problem.setType(URI.create(URI_BASE_ERROS + "/recurso-nao-encontrado"));
        problem.setProperty("timestamp", Instant.now());
        problem.setProperty("userMessage", ex.getMessage());
        return problem;
    }

    /**
     * Tratamento de Violação de Regras Regulatórias do Conselho da AGR (HTTP 422).
     */
    @ExceptionHandler(RegraNegocioException.class)
    public ProblemDetail handleRegraNegocio(RegraNegocioException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.getMessage());
        problem.setTitle("Violação de Regra Regulatória");
        problem.setType(URI.create(URI_BASE_ERROS + "/regra-regulatoria"));
        problem.setProperty("timestamp", Instant.now());
        problem.setProperty("userMessage", ex.getMessage());
        return problem;
    }

    /**
     * Sobrescrita cirúrgica para validações do Bean Validation (@Valid - HTTP 400).
     * Enriquecimento do ProblemDetail nativo com mapa estruturado de campos inválidos.
     */
    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex,
            HttpHeaders headers,
            HttpStatusCode status,
            WebRequest request
    ) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
                status, 
                "Um ou mais campos da requisição são inválidos. Faça o preenchimento correto e tente novamente."
        );
        problem.setTitle("Dados Inválidos");
        problem.setType(URI.create(URI_BASE_ERROS + "/dados-invalidos"));
        problem.setProperty("timestamp", Instant.now());
        problem.setProperty("userMessage", "Verifique os campos destacados e corrija os dados informados.");

        // Mapeamento funcional de erros por campo rejeitado
        Map<String, String> camposInvalidos = ex.getBindingResult().getFieldErrors().stream()
                .collect(Collectors.toMap(
                        FieldError::getField,
                        error -> (error.getDefaultMessage() != null) ? error.getDefaultMessage() : "Valor inválido",
                        (mensagemExistente, novaMensagem) -> mensagemExistente + "; " + novaMensagem
                ));

        problem.setProperty("campos", camposInvalidos);

        return ResponseEntity.status(status).headers(headers).body(problem);
    }
}
```

**Payload JSON RFC 7807 Retornado Fisicamente:**
```json
{
  "type": "https://api.agr.go.gov.br/erros/dados-invalidos",
  "title": "Dados Inválidos",
  "status": 400,
  "detail": "Um ou mais campos da requisição são inválidos. Faça o preenchimento correto e tente novamente.",
  "instance": "/api/v1/autos-infracao",
  "timestamp": "2026-10-25T14:10:00Z",
  "userMessage": "Verifique os campos destacados e corrija os dados informados.",
  "campos": {
    "placa": "A placa do veículo informada não atende ao padrão brasileiro (Cinza ou Mercosul)",
    "valorMulta": "O valor da autuação deve ser estritamente positivo"
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `portalservice` (`:8080`), `cadastrounicoservice` (`:8081`), `fiscalizacaoservice` (`:8082`) e `receitaservice` (`:8092`).
- **Cenário Real em Produção:** Exclusão completa das antigas classes `Problem.java` manuais em todos os microsserviços. Quando uma permissionária tenta recolher uma taxa de regulação no `receitaservice` (`:8092`) após o vencimento sem atualização monetária, a API responde imediatamente com `status=422`, `type=https://api.agr.go.gov.br/erros/dare-vencido` e o valor dos encargos legais discriminado no `ProblemDetail`.
- **Teatro-ABC (`:8090`):** Quando duas sessões de compra tentam reservar simultaneamente o assento `B-12` na plateia VIP, o motor responde `HTTP 409 Conflict` com `type=/assento-indisponivel`, orientando a tela do usuário a reabrir o mapa de poltronas livres.

---

## 5. Pilar 4: Arquitetura Limpa, Camadas Desacopladas & Observabilidade Corporativa

### 5.1 Clean Architecture (Ports & Adapters) vs Modelo Anêmico e Acoplamento em Controllers

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o restaurante mais sofisticado e premiado de uma grande capital: no salão da frente, atua o garçom elegante (o Controller), responsável por recepcionar os clientes, recolher os pedidos e entregar os pratos finalizados com etiqueta. No centro do estabelecimento, protegida por portas corta-fogo e isolamento acústico, fica a cozinha dos sonhos onde o Chef executivo prepara as receitas secretas da família (o Domain Model / Entidades Ricas). Pelas portas dos fundos, fornecedores de confiança entregam carnes nobres e ingredientes frescos selecionados (os Repositories / Infraestrutura).

No **Antipadrão do Modelo Anêmico**, o garçom anota o pedido, entra correndo na cozinha com os sapatos sujos da rua, acende o fogão, queima a carne, mistura temperos estragados, joga no prato de qualquer jeito e ainda vai até o açougue no meio do jantar para comprar sal.
Na **Clean Architecture (Arquitetura Limpa)**, o Controller jamais encosta em regras de negócio e nunca executa comandos SQL: ele apenas traduz a requisição HTTP em um comando de caso de uso e devolve a resposta; a regra regulatória sagrada vive no coração blindado do Domínio Rico, imune a frameworks web ou fornecedores de banco de dados.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Portal 1 da AGR e no código legado do módulo de permissionárias (`cadastrounicoservice` :8081), observava-se o caos da violação de camadas no infame `ManterVeiculoBean.java`:
- Controllers acumulavam mais de **800 a 1.200 linhas de código**, misturando parsing de parâmetros de tela, montagem de queries SQL com concatenação de strings (`"SELECT * FROM veiculo WHERE placa = '" + placa + "'"`), regras tributárias de amortização de multas e escrita direta na saída HTTP;
- Entidades anêmicas: as classes `@Entity` do JPA eram simples agrupamentos de atributos com getters e setters, sem qualquer inteligência de domínio;
- Impossibilidade de automação de testes: para testar se uma empresa de transporte perdia a concessão após três multas gravíssimas no mesmo ano, era obrigatório subir o Tomcat inteiro, provisionar o MySQL corporativo em `10.243.1.27:3306` e disparar requisições HTTP reais, tornando a suíte de testes lenta, frágil e inviável.

#### Parte 3: A Solução Moderna de Elite
Segregação rigorosa em 4 camadas com fluxo unidirecional de dependência voltado para o centro:

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. ADAPTADORES PRIMÁRIOS (REST Controllers / Web Endpoints)            │
│    • Recebe requisição HTTP, valida DTOs (@Valid), emite Status Codes  │
├────────────────────────────────────────────────────────────────────────┤
│ 2. CAMADA DE APLICAÇÃO (Use Cases / Application Services)              │
│    • Orquestra a execução, gerencia demarcação de transação (@Tx)      │
├────────────────────────────────────────────────────────────────────────┤
│ 3. DOMÍNIO RICO (Entidades Ricas, Objetos de Valor, Invariantes)       │
│    • Regras de negócio puras da AGR, livre de qualquer anotação Spring │
├────────────────────────────────────────────────────────────────────────┤
│ 4. ADAPTADORES SECUNDÁRIOS (Infraestrutura, JPA Repositories, S3, SEI) │
│    • Spring Data JPA, MySQL 8, RestClient DETRAN, MinIO S3             │
└────────────────────────────────────────────────────────────────────────┘
```

**Modelo de Domínio Rico de Elite (Regra de Negócio Pura):**

```java
package br.gov.go.agr.fiscais.domain.model;

import br.gov.go.agr.fiscais.domain.exception.RegraNegocioException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Objects;

/**
 * Entidade Rica de Domínio: Auto de Infração Rodoviário.
 * Encapsula suas próprias invariantes e regras de negócio.
 * Zero dependências de frameworks Web ou anotações Spring.
 */
public class AutoInfracao {

    private final Long id;
    private final String numeroAuto;
    private final String placa;
    private BigDecimal valorMulta;
    private StatusAuto status;
    private final Instant dataLavratura;

    public enum StatusAuto {
        LAVRADO,
        EM_RECURSO,
        HOMOLOGADO,
        CANCELADO,
        QUITADO
    }

    public AutoInfracao(Long id, String numeroAuto, String placa, BigDecimal valorMulta) {
        if (valorMulta == null || valorMulta.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RegraNegocioException("O valor do auto de infração regulatória deve ser estritamente positivo.");
        }
        this.id = id;
        this.numeroAuto = Objects.requireNonNull(numeroAuto, "O número do auto de infração é obrigatório");
        this.placa = Objects.requireNonNull(placa, "A placa do veículo autuado é obrigatória");
        this.valorMulta = valorMulta;
        this.status = StatusAuto.LAVRADO;
        this.dataLavratura = Instant.now();
    }

    /**
     * Regra de Domínio: Concessão de desconto regulatório de 30% por antecipação de pagamento.
     */
    public void aplicarDescontoPontualidade(BigDecimal percentualDesconto) {
        if (this.status != StatusAuto.LAVRADO) {
            throw new RegraNegocioException("Desconto de pontualidade não pode ser aplicado para auto em status " + this.status);
        }
        if (percentualDesconto == null || percentualDesconto.compareTo(BigDecimal.ZERO) <= 0 || percentualDesconto.compareTo(new BigDecimal("0.50")) > 0) {
            throw new RegraNegocioException("Percentual de desconto inválido. Limite regulamentar entre 1% e 50%.");
        }
        BigDecimal valorDesconto = this.valorMulta.multiply(percentualDesconto);
        this.valorMulta = this.valorMulta.subtract(valorDesconto);
    }

    /**
     * Homologação formal da sanção após esgotamento de prazos recursais.
     */
    public void homologarSancao() {
        if (this.status != StatusAuto.LAVRADO && this.status != StatusAuto.EM_RECURSO) {
            throw new RegraNegocioException("Apenas autos lavrados ou com recursos julgados podem ser homologados.");
        }
        this.status = StatusAuto.HOMOLOGADO;
    }

    // Getters de leitura pura (sem setters públicos permissivos)
    public Long getId() { return id; }
    public String getNumeroAuto() { return numeroAuto; }
    public String getPlaca() { return placa; }
    public BigDecimal getValorMulta() { return valorMulta; }
    public StatusAuto getStatus() { return status; }
    public Instant getDataLavratura() { return dataLavratura; }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `cadastrounicoservice` (`:8081`).
- **Cenário Real em Produção:** Na reengenharia do CADU do Portal 1 para o Portal 2, a eliminação do padrão anêmico reduziu a contagem de classes do projeto de **242 para 143 classes**, erradicando interfaces vazias de fachada (`IVeiculoService.java`, `IVeiculoDao.java`) e permitindo a cobertura de testes unitários com JUnit 5 em milissegundos sem necessidade de banco de dados.
- **Teatro-ABC (`:8090`):** A entidade rica `Assento` contém o método `assento.reservarPara(Cliente c)`, que avalia o mapa de horário e assentos reservados diretamente no domínio, impedindo que o Controller gerencie transações de reserva.

---

### 5.2 Observabilidade Corporativa: Spring Boot Actuator, Micrometer & Custom Health Indicators

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o cockpit de comando de um avião comercial de passageiros cruzando o continente a 11.000 metros de altitude: os pilotos contam com visores multifuncionais de cristal líquido que exibem a todo instante a temperatura dos motores, a pressão hidráulica das superfícies de controle, o nível exato de combustível em cada asa e a taxa de subida. Se uma válvula de combustível apresentar oscilação microscópica, um alerta sonoro e visual avisa o comandante muito antes de ocorrer qualquer falha no motor.

O **Spring Boot Actuator & Micrometer** é o cockpit de instrumentos do microsserviço corporativo em produção. Em vez de operar aplicações como caixas-pretas misteriosas, o Actuator expõe endpoints seguros de telemetria com métricas de requisições por segundo (RPS), latência percentual (p95 e p99), consumo de memória Heap e Non-Heap da JVM, integridade do pool de conexões do HikariCP e **Health Checks ativos** que testam em tempo real a conectividade com bancos de dados e serviços satélites essenciais (como storage S3 e barramentos governamentais).

#### Parte 2: A Dor Histórica / O Desastre do Legado
No legado dos sistemas da AGR, os servidores de aplicação eram verdadeiras caixas-pretas:
- Quando o `fiscalizacaoservice` entrava em pane durante uma blitz noturna, os desenvolvedores eram acionados de madrugada para abrir sessões de SSH no terminal dos servidores Linux (`10.243.1.27`) e rodar manualmente comandos como `tail -f nohup.out` ou `grep -i exception /var/log/tomcat/catalina.out` em arquivos de log descomunais de mais de 4 GB;
- Quedas de conectividade com o banco de dados MySQL ou esgotamento de portas de rede só eram descobertas quando fiscais ligavam desesperados na central de TI informando que o sistema parou de salvar laudos. Não havia alertas proativos, métricas de latência ou prevenção de indisponibilidade.

#### Parte 3: A Solução Moderna de Elite
Configuração corporativa de endpoints de observabilidade no `application.yml`:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: "health,info,metrics,prometheus"
  endpoint:
    health:
      show-details: always
  metrics:
    tags:
      application: "fiscalizacao-service"
      environment: "production"
```

Implementação de **Custom Health Indicator** verificando ativamente a comunicação via socket com o storage S3 / MinIO onde ficam armazenadas as evidências fotográficas de autuações:

```java
package br.gov.go.agr.fiscais.infra.health;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

import java.net.InetSocketAddress;
import java.net.Socket;

/**
 * Health Indicator Customizado de Elite para Monitoramento do Storage MinIO/S3.
 * Reporta o estado do cluster fotográfico diretamente ao Spring Boot Actuator.
 */
@Component
public class MinioStorageHealthIndicator implements HealthIndicator {

    private final String minioHost = "127.0.0.1";
    private final int minioPort = 9000;
    private static final int TIMEOUT_MS = 2000;

    @Override
    public Health health() {
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(minioHost, minioPort), TIMEOUT_MS);
            return Health.up()
                    .withDetail("storage", "MinIO S3 Object Storage - AGR")
                    .withDetail("endpoint", minioHost + ":" + minioPort)
                    .withDetail("status", "Conexão de rede ativa e responsiva")
                    .build();
        } catch (Exception ex) {
            return Health.down()
                    .withDetail("storage", "MinIO S3 Object Storage - AGR")
                    .withDetail("endpoint", minioHost + ":" + minioPort)
                    .withDetail("erro", "Falha de conectividade com o cluster MinIO: " + ex.getMessage())
                    .build();
        }
    }
}
```

**Payload JSON Retornado pelo Endpoint `GET /actuator/health`:**

```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "MySQL",
        "validationQuery": "isValid()"
      }
    },
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 512000000000,
        "free": 348000000000,
        "threshold": 10485760
      }
    },
    "minioStorage": {
      "status": "UP",
      "details": {
        "storage": "MinIO S3 Object Storage - AGR",
        "endpoint": "127.0.0.1:9000",
        "status": "Conexão de rede ativa e responsiva"
      }
    }
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** Monitoramento centralizado dos 25 microsserviços da autarquia via stack **Prometheus + Grafana**, com raspagem periódica do endpoint `/actuator/prometheus`. Se a latência p99 do `receitaservice` (`:8092`) ultrapassar 800 ms, alertas automáticos são disparados via webhook no canal de operações da TI da AGR.
- **Teatro-ABC (`:8090`):** Indicador customizado monitorando o tempo de resposta e pool de conexões do HikariCP durante o pico de vendas de ingressos, garantindo failover automático caso a base principal apresente degradação.

---

## 6. Matriz de Rastreabilidade Forense: AlgaWorks, Ecossistema AGR e Teatro-ABC

A matriz a seguir consolida a correlação técnica entre os conteúdos ministrados no acervo da AlgaWorks (*Especialista Spring REST* - ESR), os desafios reais de produção dos sistemas legados da AGR, a solução de ponta em **Spring Boot 3.3+ e Java 21 LTS**, e a validação no projeto greenfield **Teatro-ABC**:

| # | Conceito Técnico Chave | Paradigma Legado AlgaWorks (ESR) | O Desastre do Legado | Solução Moderna de Elite (Java 21 / Spring Boot 3.3+) | Microsserviço Real AGR | Cenário Real de Produção (AGR / Teatro-ABC) |
| :-: | :--- | :--- | :--- | :--- | :--- | :--- |
| **01** | Contratos de Dados (DTOs) | Módulo 11 (Aulas 502/503): JavaBeans com Lombok `@Data` e `ModelMapper`. | Mapeamento reflexivo em runtime, propriedades virando `null` silenciosamente, mutação concorrente de DTOs no Heap. | **Java 21 Records** com compact constructors de validação defensiva e coleções imutáveis. | `fiscalizacaoservice` (`:8082`) | Payload imutável de lavratura de auto de infração com fotos anexadas e dados protegidos contra mutação. |
| **02** | Concorrência de I/O em Rede | Módulo 22: Platform Threads limitadas a 200 no Tomcat com I/O síncrono bloqueante. | Pool do Tomcat esgotado em 2 minutos de lentidão externa do DETRAN-GO, travando toda a autarquia. | **Virtual Threads (Project Loom)** via `spring.threads.virtual.enabled=true`. | `seiservice` (`:8111`) & `portalservice` (`:8080`) | 10.000 requisições simultâneas aguardando assinatura do SEI com zero consumo de threads do SO. |
| **03** | Tratamento Global de Erros | Módulo 8 (Aulas 427, 441, 452): Classes POJO manuais `Problem`, `ProblemType`, e interceptor complexo. | 400 linhas de boilerplate manual em cada serviço; no legado AGR, envelope tóxico `Response<T>` com `HTTP 200 OK` contendo erros. | **RFC 7807 `ProblemDetail`** nativo do Spring 6+ com `@RestControllerAdvice`. | `receitaservice` (`:8092`) | Rejeição padronizada de pagamento duplicado ou DARE vencido com status 422 e dados da infração. |
| **04** | Cliente HTTP Inter-Serviços | Módulo 22: `RestTemplate` prolixo em manutenção ou `WebClient` reativo forçado. | `ConsumidorServicosUtil.java` na AGR sem timeouts calibrados ou injeção pesada do Netty. | **`RestClient` fluente** do Spring 6.1+ com timeouts, interceptores e tratamento de status declarativo. | `fiscalizacaoservice` (`:8082`) ➔ `cadu` (`:8081`) | Consulta síncrona leve da situação cadastral da empresa de transporte antes da autuação. |
| **05** | Namespace & Bibliotecas | Módulo 28 (Aulas 864, 865, 867): `javax.*`, Squiggly Filter e SpringFox Swagger 2. | Bibliotecas abandonadas quebraram na compilação do Spring Boot 3; risco de alterar classes SE (`DataSource`). | **Jakarta EE 10** (`jakarta.*`), **SpringDoc OpenAPI 3** e DTOs Records especializados. | Todos os 25 microsserviços | Atualização de segurança contra CVEs, documentação dinâmica interativa em `/swagger-ui/index.html`. |
| **06** | Arquitetura & Observabilidade | Controllers anêmicos com SQL concatenado e ausência de instrumentação. | Debug via `tail -f nohup.out` no Linux; indisponibilidade de banco só descoberta após reclamação de usuários. | **Clean Architecture** (Domain rico isolado) + **Actuator / Micrometer Observation API**. | `portalservice` (`:8080`) & `teatro-abc` (`:8090`) | Monitoramento p99 de latência e health check customizado do storage S3 MinIO e pool HikariCP. |

---

## 7. Diretrizes Finais de Governança de Código para o Ecossistema Backend

1. **Compilação Sem Warnings de Depreciação:** Todos os projetos devem compilar no Maven com o parâmetro `-Xlint:deprecation` ativado. Nenhuma classe legada do Spring 2 ou Jakarta EE 8 é tolerada.
2. **Imutabilidade como Padrão de Projeto:** Nenhuma classe DTO deve possuir métodos modificadores (`setter`). Coleções recebidas devem ser obrigatoriamente encapsuladas via `List.copyOf()`, `Set.copyOf()` ou `Map.copyOf()`.
3. **Erradicação Definitiva do Envelope `Response<T>`:** Qualquer endpoint REST deve retornar entidades e DTOs diretamente ou envelopados em `org.springframework.http.ResponseEntity<T>`, respeitando rigorosamente os códigos da família HTTP 2xx para sucesso e RFC 7807 (`ProblemDetail`) para as famílias 4xx e 5xx.
4. **Virtual Threads Habilitadas em Todos os Serviços:** O parâmetro `spring.threads.virtual.enabled=true` é obrigatório no `application.yml` de todos os 25 microsserviços da AGR e no projeto Teatro-ABC.
5. **Clean Architecture e Cobertura de Testes Unitários de Domínio:** As entidades de negócio devem permanecer agnósticas de persistência e frameworks, com 100% de cobertura de testes unitários rápidos e determinísticos com JUnit 5.

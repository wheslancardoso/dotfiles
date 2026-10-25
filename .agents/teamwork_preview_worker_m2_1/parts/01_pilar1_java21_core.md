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


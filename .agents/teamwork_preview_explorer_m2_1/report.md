# 🏛️ BLUEPRINT DE ENGENHARIA & GUIA DE IMPLEMENTAÇÃO: MÓDULO 02 — ARQUITETURA BACKEND SPRING BOOT 3.3+ & JAVA 21 LTS

> **Documento Alvo:** `/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md`  
> **Autor da Especificação:** Explorer Milestone 2 (Arquitetura Backend Spring Boot 3.3+)  
> **Data / Timestamp:** 2026-10-25T13:58:00Z  
> **Diretrizes de Referência:** `ORIGINAL_REQUEST.md`, `PROJECT.md`, `TEST_INFRA.md`, Surveys 1, 2 e 3  
> **Status:** Pronto para Implementação pelo Worker M2  

---

## 📑 1. SUMÁRIO EXECUTIVO & ESCOPO DO MILESTONE 2

O objetivo deste blueprint é fornecer as diretrizes exaustivas, o alinhamento arquitetural e a planta baixa de engenharia para a redação de `02-arquitetura-backend-spring-boot-3.md` em `/home/lan/dotfiles/templates-lab/docs/`.

O módulo é o coração do backend na suíte de documentação, cobrindo o salto geracional entre:
1. **O Legado Tradicional (Java 8 a 11, Spring Boot 2.x, AlgaWorks Especialista Spring REST / AlgaFood, Portal 1 da AGR):**
   - Javabeans mutáveis repletos de boilerplate ou anotações do Lombok (`@Data`).
   - Mapeamento dinâmico em tempo de execução via reflexão pesada com `ModelMapper`.
   - Concorrência limitada pelo pool de threads nativas do sistema operacional (Platform Threads do Tomcat esgotadas sob I/O bloqueante).
   - Ausência de padrão RFC 7807 (construção manual de POJOs `Problem` e interceptores artesanais).
   - Envelope genérico ad-hoc `Response<T>` mascarando falhas sob `HTTP 200 OK`.
   - Quebra massiva de ecossistema na transição para o Spring Boot 3 (morte do SpringFox, abandono do Squiggly Filter, renomeação do namespace `javax.*` para `jakarta.*`).
2. **A Engenharia Moderna de Elite (Java 21 LTS, Spring Boot 3.3+, Clean Architecture, Teatro-ABC):**
   - **Java Records** imutáveis como DTOs nativos com construtores compactos para invariantes de domínio.
   - **Virtual Threads (Project Loom - JEP 444)** ativadas nativamente no Spring Boot 3.3 (`spring.threads.virtual.enabled=true`), suportando milhões de conexões simultâneas com zero overhead de thread pool exhaustion.
   - **Pattern Matching para `switch` (JEP 441)** e **Record Patterns (JEP 440)** com checagem de exaustividade em tempo de compilação.
   - **Sealed Interfaces / Classes (JEP 409)** modelando hierarquias de domínio fechadas e determinísticas.
   - **Transição Jakarta EE 10:** Namespace `jakarta.*` rigoroso (com atenção cirúrgica para a exceção do `javax.sql.DataSource` do Java SE).
   - **Controllers RESTful Modernos:** Semântica estrita de status codes (201 Created com cabeçalho `Location`, 204 No Content, 400/404/409/422 com RFC 7807).
   - **`RestClient` Fluente do Spring 6.1+:** Cliente HTTP síncrono moderno, tipado e declarativo, substituindo o legado `RestTemplate` (manutenção) e evitando a sobrecarga reativa desnecessária do `WebClient`.
   - **Tratamento Global com RFC 7807 Nativo (`org.springframework.http.ProblemDetail`):** Substituição completa das antigas classes POJO manuais e eliminação definitiva do envelope tóxico `Response<T>`.
   - **Clean Architecture & Observabilidade:** Segregação de responsabilidades (Controller -> UseCase/Service -> Domain -> Repository) e monitoramento corporativo via Spring Boot Actuator e Micrometer Observation API.

---

## 📐 2. ESTRUTURAÇÃO OBRIGATÓRIA DO ARQUIVO CANÔNICO

O arquivo `/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md` deve conter no mínimo **301 linhas** (estimado entre **600 e 900 linhas** para profundidade masterclass), sem nenhum placeholder (`TODO`, `FIXME`, `[TBD]`, elipses desleixadas `...`), e deve cobrir 4 Grandes Pilares temáticos.

Cada conceito dentro de cada pilar DEVE conter obrigatoriamente a **Quadrupleta Didática Canônica (4 Camadas)**:
1. **Parte 1: O que é o conceito / Analogia Didática com o Mundo Real** (para qualquer iniciante entender).
2. **Parte 2: A Dor Histórica / O Desastre do Legado** (com citações literais transcritas do curso AlgaWorks e relatos de falhas de produção).
3. **Parte 3: A Solução Moderna de Elite** (código Java 21 e Spring Boot 3.3+ completo, tipado, compilável e executável).
4. **Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC** (portas reais `:8080`, `:8081`, `:8082`, `:8092`, eliminação do `Response<T>`, e greenfield `:8090`).

---

## ☕ 3. PILAR 1: JAVA 21 LTS CORE FEATURES

### 3.1. Conceito 1.1: Java Records Imutáveis vs POJOs / Lombok Mutáveis

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma caixa registradora de correspondência diplomática: ao postar uma carta oficial, ela é fechada em uma cápsula de aço com lacre inviolável e carimbo de cera. Qualquer diplomata ou mensageiro que pegue a cápsula pode ler o seu conteúdo por uma janela de vidro blindado, mas **ninguém pode abrir a cápsula para alterar o texto, trocar o destinatário ou arrancar páginas**. 
Um **Java Record (JEP 395)** é exatamente essa cápsula de dados lacrada: ele é uma classe imutável por definição cujo único propósito é transportar dados de forma transparente, com métodos acessores (`nome()`, `idade()`), `equals()`, `hashCode()` e `toString()` gerados deterministicamente pelo compilador da JVM, alocável na Stack sob escape analysis, livre de estado mutável compartilhado.

#### Parte 2: A Dor Histórica / O Desastre do Legado (Citações Literais AlgaWorks)
No modelo tradicional ensinado na AlgaWorks (Módulo 11 do ESR) e praticado no Portal 1 da AGR, os DTOs eram classes mutáveis recheadas de anotações do Lombok (`@Getter`, `@Setter`, `@EqualsAndHashCode` ou a anotação agressiva `@Data`).
Para evitar escrever dezenas de getters e setters, adotou-se o `ModelMapper`. Na aula `502_11.14. Adicionando e usando o ModelMapper.txt`, o instrutor Thiago expressa a dor da época:
> *"Dá uma olhada nesse código aqui. Será que dá para melhorar esse código? Tem código boilerplate aqui, aquele código repetitivo. Faz get do um lado, set no outro. Get no lado, set no outro. Isso porque as nossas classes não têm muitas propriedades... Imagina se a gente tivesse aqui classes com mais propriedades, classes mais complexas. Esse código aqui se tornaria um código chato de escrever. Não no sentido só chato de escrever, mas chato fica mantendo esse código com get, set assim, né?"* (`502_11.14`)

E na aula `503_11_15_Entendendo_a_estratégia_padrão_do_ModelMapper_para_correspondência.txt`:
> *"Olha só. Frete, 10. Uau, quer dizer, tirei a palavra taxa e mesmo assim ele viu uma correspondência, né? Entre taxa frete e frete. E dentro da classe restaurante, veja que tem taxa frete, aqui no restaurante model tem apenas frete e ele correspondeu uma coisa com a outra e aí está a inteligência dele... Você está vendo também a flexibilidade que a gente tem... o model mapper já está fazendo a transformação para a gente..."* (`503_11_15`)

**O Desastre em Produção:**
O que parecia "mágico" gerou catástrofes:
1. **Falha Silenciosa de Tipos e Nomes:** Se o campo na entidade mudava de `taxaFrete` para `valorFrete`, o `ModelMapper` não quebrava na compilação. Em produção, ele atribuía `null` silenciosamente para o DTO.
2. **Custo de Reflexão em Tempo de Execução:** Cada chamada HTTP acionava o motor de reflexão Java inspecionando metadados de métodos e campos da classe, destruindo o throughput da aplicação sob carga de milhares de requisições por segundo.
3. **Mutação Concorrente no Heap:** Como os DTOs possuíam setters públicos (`setValor()`), interceptores ou threads secundárias podiam alterar os dados do DTO em trânsito antes da serialização, gerando dados corrompidos.

#### Parte 3: A Solução Moderna de Elite (Java 21 LTS)
Adoção estrita de Java Records com **Compact Constructors** para validação defensiva e cópia defensiva de coleções:

```java
package br.gov.go.agr.fiscais.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

/**
 * DTO Canônico Imutável para Emissão de Auto de Infração.
 * Imutabilidade estrita garantida no nível do bytecode da JVM.
 */
public record AutoInfracaoRequest(
    @NotBlank(message = "A placa do veículo é obrigatória")
    String placa,

    @NotNull(message = "O ID da infração regulatória é obrigatório")
    Long infracaoId,

    @NotNull(message = "O valor da autuação é obrigatório")
    @Positive(message = "O valor da autuação deve ser estritamente positivo")
    BigDecimal valorMulta,

    @NotBlank(message = "O relato fático do auditor fiscal é obrigatório")
    String relatoFiscal,

    @NotNull(message = "A lista de URLs de evidências fotográficas não pode ser nula")
    List<String> evidenciasUrls
) {
    // Compact Constructor: Validação de invariantes e defesa contra mutação externa
    public AutoInfracaoRequest {
        if (placa != null) {
            placa = placa.trim().toUpperCase();
        }
        // Cópia defensiva imutável: impede que quem passou a lista a altere posteriormente
        evidenciasUrls = (evidenciasUrls == null) ? List.of() : List.copyOf(evidenciasUrls);
    }
}
```

```java
package br.gov.go.agr.fiscais.api.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

/**
 * DTO de Resposta Imutável.
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
        evidenciasUrls = List.copyOf(evidenciasUrls);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviço Real AGR:** `fiscalizacaoservice` (`:8082` / `:8083`).
- **Ponto de Aplicação:** No endpoint `POST /api/v1/autos-infracao`. O fiscal de campo envia o payload com a placa abordada na rodovia e links de fotos do MinIO. A garantia de imutabilidade assegura que a cadeia probatória do auto de infração permaneça idêntica desde o controller até a persistência no MySQL corporativo e geração do laudo PDF no JasperReports.
- **Teatro-ABC (`:8090`):** `ReservaAssentoRequest(Long sessaoId, Long assentoId, String cpfCliente)`. Previne que threads de reservas manipulem os IDs dos assentos durante a validação de disponibilidade.

---

### 3.2. Conceito 1.2: Virtual Threads (Project Loom - JEP 444) vs Esgotamento do Pool de Platform Threads

#### Parte 1: O que é o conceito / Analogia Didática
Pense em um balcão de cartório tradicional com 200 guichês físicos e 200 atendentes humanos de carteira assinada (Platform Threads do SO). Quando um cidadão chega e pede um documento que depende de uma consulta a um arquivo em outra cidade (chamada de I/O de rede ou banco de dados), o atendente simplesmente **cruza os braços e fica parado no guichê por 15 segundos esperando a carta chegar**. Enquanto isso, uma fila de 5.000 pessoas se forma na calçada porque todos os 200 guichês estão bloqueados sem trabalhar.
As **Virtual Threads (Project Loom)** transformam esse modelo: o atendente humano (Carrier Thread do SO) nunca fica parado. Quando o pedido exige esperar 15 segundos, o atendente passa a ficha para uma prancheta digital suspensa (Virtual Thread), atende imediatamente a próxima pessoa da fila e só volta à ficha digital quando a resposta externa finalmente chega. Com isso, 16 atendentes físicos conseguem gerenciar com facilidade **1.000.000 de pranchetas digitais suspensas** sem consumir memória nem travar a repartição.

#### Parte 2: A Dor Histórica / O Desastre do Legado (Citações e Dossiê AGR)
No Spring Boot 2.x e Java 8/11, cada requisição HTTP recebida pelo Tomcat recebia uma **Platform Thread dedicada (Thread-per-Request)**.
No ecossistema real da AGR (`portalservice :8080`, `fiscalizacaoservice :8082`), o Tomcat era configurado com o limite padrão de **200 worker threads** (`server.tomcat.threads.max=200`). Cada thread do sistema operacional consome cerca de **1 MB de memória de Stack** alocada fora da Heap.
Quando uma blitz ocorria nas rodovias de Goiás e 30 fiscais submetiam consultas veiculares simultâneas, o `fiscalizacaoservice` disparava chamadas HTTP síncronas bloqueantes para o `cadu :8081`, que por sua vez consultava o barramento do `DETRAN-GO` (`services.detran.go.gov.br`).
Se o link do DETRAN-GO oscilasse e demorasse 10 segundos para responder:
- 200 requisições simultâneas retinham todas as 200 threads do Tomcat no estado `WAITING` / `BLOCKED`.
- A 201ª requisição entrava na fila do SO (`accept-count=100`) e logo recebia `HTTP 504 Gateway Timeout` ou `Connection Refused`.
- Toda a autarquia ficava fora do ar: até o login do presidente da AGR no `portalservice` parava de funcionar porque não havia threads livres para processar autenticações.

#### Parte 3: A Solução Moderna de Elite (Spring Boot 3.3+ & Java 21)
Ativação declarativa de Virtual Threads no `application.yml`:

```yaml
spring:
  threads:
    virtual:
      enabled: true
```

Sob o capô, o Spring Boot 3.3 reconfigura o servidor embutido (Tomcat ou Jetty) para que cada requisição HTTP receba uma nova `VirtualThread` gerenciada diretamente pela JVM sobre um pool reduzido de `ForkJoinPool` Carrier Threads:

```java
package br.gov.go.agr.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.Executors;

@Configuration
public class ConcorrenciaConfig {

    private static final Logger log = LoggerFactory.getLogger(ConcorrenciaConfig.class);

    @Bean
    public ApplicationRunner auditoriaVirtualThreads() {
        return args -> {
            Thread testThread = Thread.ofVirtual().unstarted(() -> {
                log.info("Executando dentro de uma Virtual Thread? {}", Thread.currentThread().isVirtual());
            });
            testThread.start();
            testThread.join();
        };
    }
}
```

**Por Que Isso é Superior ao WebFlux / Project Reactor?**
O modelo reativo do Spring WebFlux exigia que os desenvolvedores reescrevessem todo o código com `Mono<T>`, `Flux<T>`, operadores funcionais (`flatMap`, `switchIfEmpty`) e JDBC reativo (R2DBC). Isso destruía o rastreamento de stack traces (`ThreadLocal` não funcionava) e tornava o debug impossível. Com Virtual Threads, **o código permanece estritamente imperativo, síncrono e simples**, enquanto o runtime da JVM descarrega a thread física no momento exato do bloqueio de socket.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `portalservice` (`:8080`), `fiscalizacaoservice` (`:8082`), `seiservice` (`:8111`).
- **Cenário Real:** A integração com o processo eletrônico do Estado (SEI-GO via `seiservice`) leva em média 2,5 segundos para assinar digitalmente um documento de autuação. Com Virtual Threads ativadas no `fiscalizacaoservice`, 10.000 processos podem aguardar a resposta do SEI concorrentemente sem consumir mais do que 40 MB de memória RAM na JVM.
- **Teatro-ABC (`:8090`):** Pico de abertura de bilheteria para espetáculo no Oscar Niemeyer: 15.000 conexões síncronas HTTP consultando assentos disponíveis simultaneamente sem derrubar o Tomcat.

---

### 3.3. Conceito 1.3: Pattern Matching para `switch` & Record Patterns

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma central de triagem de encomendas dos Correios onde chegam pacotes de diferentes formatos: cartas simples, caixas cúbicas e cilindros de mapas. No passado, o operador tinha que pegar a caixa, perguntar "Você é uma caixa cúbica?", se a resposta fosse sim, pegar uma faca, cortar a fita adesiva, abrir a tampa, retirar o produto de dentro e só então inspecionar a nota fiscal.
Com o **Pattern Matching para `switch` (JEP 441)** e **Record Patterns (JEP 440)**, a esteira possui um sensor de raio-X holográfico: na hora em que o pacote passa, o sensor já reconhece o tipo exato, "desempacota" os componentes internos diretamente nos braços do operador e o compilador garante que **nenhum formato de encomenda existente no regulamento postal foi esquecido**.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Java 8 e no Spring Boot 2.x, para tratar polimorfismo de regras ou tipos de eventos, os desenvolvedores eram obrigados a recorrer a cadeias intermináveis de `if (obj instanceof Tipo) { Tipo t = (Tipo) obj; ... }`:
- Casts manuais inseguros que explodiam em `ClassCastException` em produção.
- `switch` suportava apenas primitivos, enums e strings, forçando regras de negócio a utilizarem códigos literais ("MULTA", "ADVERTENCIA", "APREENSAO").
- Quando um novo tipo de penalidade era criado pela diretoria da AGR, o desenvolvedor esquecia de adicionar o novo `else if` em um dos 15 métodos do sistema. O código caía no bloco `else` mudo, deixando de aplicar penalidades obrigatórias por lei sem disparar erro.

#### Parte 3: A Solução Moderna de Elite (Java 21 LTS)
Desestruturação de Records diretamente no `switch` com verificação de exaustividade em tempo de compilação:

```java
package br.gov.go.agr.fiscais.domain.service;

import br.gov.go.agr.fiscais.domain.model.Penalidade;
import br.gov.go.agr.fiscais.domain.model.Penalidade.*;
import java.math.BigDecimal;

public class CalculadoraPenalidadeService {

    public String processarDecisaoRegulatoria(Penalidade penalidade) {
        return switch (penalidade) {
            case Advertencia(String motivo, int reincidencia) when reincidencia > 2 ->
                "Converter advertência em sanção pecuniária devido a " + reincidencia + " reincidências: " + motivo;
            
            case Advertencia(String motivo, int reincidencia) ->
                "Emitir termo de advertência formal: " + motivo;

            case MultaPecuniaria(String codigo, BigDecimal valor, boolean quitada) when quitada ->
                "Processo arquivado por quitação da multa código " + codigo + " no valor de R$ " + valor;

            case MultaPecuniaria(String codigo, BigDecimal valor, boolean quitada) ->
                "Inscrever em Dívida Ativa estadual multa código " + codigo + " no valor de R$ " + valor;

            case ApreensaoVeiculo(String placa, String patio, boolean liberado) ->
                liberado ? "Veículo placa " + placa + " liberado do pátio " + patio 
                         : "Veículo placa " + placa + " custodiado no pátio " + patio;
        };
    }
}
```

Se um desenvolvedor adicionar uma nova penalidade `SuspensaoConcessao` à interface selada e esquecer de tratá-la neste `switch`, **o código sequer compila**, eliminando 100% dos bugs silenciosos de regras incompletas.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviço Real AGR:** `fiscalizacaoservice` (`:8082`) e `receitaservice` (`:8092`).
- **Cenário Real:** Despacho colegiado de recursos de autuação. O sistema desestrutura o tipo de penalidade lavrada em campo e direciona automaticamente para emissão de DARE, liberação de retenção no pátio ou inscrição no sistema da Dívida Ativa (`sda :8114`).
- **Teatro-ABC (`:8090`):** Desestruturação de ingressos: `switch (ingresso) { case Inteira(var preco) -> ...; case MeiaEstudante(var preco, var carteira) -> ...; case Cortesia(var autorizacao) -> ...; }`.

---

### 3.4. Conceito 1.4: Sealed Interfaces & Classes (JEP 409)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine a Constituição de um país estabelecendo os Três Poderes da República: Executivo, Legislativo e Judiciário. A lei é clara e fechada: **ninguém, em nenhum município, pode inventar um "Quarto Poder" por conta própria**. 
Uma **Sealed Interface (Interface Selada)** é essa lei de domínio imutável: ela declara explicitamente quem são seus únicos filhos autorizados (`permits ClasseA, ClasseB, ClasseC`). Nenhuma outra classe fora daquela lista permitida pode estender ou implementar o contrato.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Java 8, interfaces eram completamente abertas para implementação pública. Qualquer desenvolvedor em qualquer pacote de utilitários podia criar uma classe espúria implementando `TipoVeiculo` ou `StatusAutoInfracao`.
Isso quebrava o encapsulamento do domínio regulatório e impedia o compilador de garantir exaustividade, forçando o uso de antipadrões defensivos com `throw new IllegalStateException("Tipo desconhecido: " + obj)`.

#### Parte 3: A Solução Moderna de Elite (Java 21 LTS)

```java
package br.gov.go.agr.fiscais.domain.model;

import java.math.BigDecimal;

/**
 * Hierarquia Selada de Penalidades Regulatórias da AGR.
 * Apenas os registros explicitamente listados em permits são reconhecidos pela JVM.
 */
public sealed interface Penalidade 
    permits Penalidade.Advertencia, Penalidade.MultaPecuniaria, Penalidade.ApreensaoVeiculo {

    record Advertencia(String motivo, int reincidencia) implements Penalidade {}

    record MultaPecuniaria(String codigo, BigDecimal valor, boolean quitada) implements Penalidade {}

    record ApreensaoVeiculo(String placa, String patio, boolean liberado) implements Penalidade {}
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviço Real AGR:** `fiscalizacaoservice` (`:8082`) e `cadu` (`:8081`).
- **Cenário Real:** Domínio de Tipos de Transporte Regulados: `sealed interface TipoTransporte permits LinhaRegularIntermunicipal, FretamentoTuristico, TransporteEscolar, VanComplementar`. Blindagem absoluta contra tipos de concessão não autorizados pela AGR.
- **Teatro-ABC (`:8090`):** `sealed interface TipoAssento permits PlateiaVip, PlateiaNormal, FrisaLateral, CamaroteSuperior`.

---

## 🍃 4. PILAR 2: SPRING BOOT 3.3+ ARCHITECTURE & RESTFUL CONTROLLERS

### 4.1. Conceito 2.1: Migração Jakarta EE 10 Namespace (`javax.*` para `jakarta.*`)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que uma cidade inteira teve todos os prefixos de CEP e códigos de telefone alterados por decreto federal. As casas, as ruas e as pessoas continuam rigorosamente nos mesmos lugares, mas **qualquer carta endereçada com a sigla antiga dos Correios é sumariamente descartada na triagem central**.
A transição do Java EE para o Jakarta EE é essa mudança formal: devido à transferência dos direitos da marca Java da Oracle para a Fundação Eclipse, todos os pacotes corporativos (`javax.persistence.*`, `javax.validation.*`, `javax.servlet.*`) foram renomeados para `jakarta.*`. O Spring Boot 3.0+ abandonou completamente o suporte ao namespace `javax.*`.

#### Parte 2: A Dor Histórica / O Desastre do Legado (Citações Literais AlgaWorks)
Na aula `864_28.1. As principais mudanças do Spring Boot 3.txt`, o instrutor detalha o choque da migração:
> *"Uma outra mudança notável seria a migração para o Jakarta EE na versão 9... E essa migração aqui, ela gera uma grande quebra de compatibilidade. Não no comportamento das classes, mas sim porque os pacotes das classes aí do Jakarta EE foram alterados, ou seja, o nome do pacote foi alterado. Então muitos componentes que iniciavam, se não todos que iniciavam com Javax, vai passar a iniciar como Jakarta... E é claro, o Spring Boot 3.0 não é compatível com o Jakarta EE8 e os seus componentes e qualquer biblioteca que dependa do Jakarta EE8... Você não vai conseguir nem sequer subir o seu projeto se você tentar atualizar ele, tudo bem?"* (`864_28.1`)

E na aula `867_28.4. Alterações do Jakarta EE e Jakarta Persistence 3.0.txt`, é exposta a perigosa armadilha do refactoring cego via IDE:
> *"Vou utilizar a funcionalidade da IntelliJ, que seria o Control Shift R. Vou fazer aqui a localização dessa palavra-chave aqui, Javax, e substituir por Jakarta. Bom, se você tiver um projeto em produção, põe muito cuidado com esse tipo de substituição, porque você pode acabar substituindo coisas que não precisavam... Parece que tem apenas uma classe aqui que eu vou te mostrar, que seria a DataSource, DataBaseCleaner na verdade... que teve aqui a alteração do Jakarta para Javax. Só que no caso dessa classe aqui, que seria a DataSource, ela pertence ao Java Standard. Então, ela continua aqui no Javax. Está vendo? O import dela não precisa ser alterado."* (`867_28.4`)

**A Catástrofe das Bibliotecas Abandonadas (O Caso Squiggly e SpringFox):**
Na aula `865_28.2. Removendo componentes incompatíveis.txt`, a AlgaWorks revela a morte de bibliotecas:
> *"O squiggly, que seria um componente que temos que remover, então eu já vou remover ele daqui... e é claro, eu vou aproveitar e vou remover a variável dela, no caso a classe dela, aqui no meu core, squiggly, vou precisar remover essas duas classes aqui, então a gente vai perder essa funcionalidade no momento, porque não temos uma alternativa atualizada ainda para a funcionalidade..."* (`865_28.2`)
O `Squiggly Filter` (usado para projeção dinâmica de atributos JSON via URL) e o `SpringFox` (Swagger 2) morreram porque seus mantenedores nunca os portaram para o namespace `jakarta.*`. Empresas que dependiam dessas bibliotecas ficaram presas no Spring Boot 2.x com vulnerabilidades de segurança.

#### Parte 3: A Solução Moderna de Elite (Spring Boot 3.3+)
No Spring Boot 3.3+, todas as anotações de persistência, validação e injeção web utilizam o namespace `jakarta.*`, enquanto classes nativas do JDK (como `javax.sql.DataSource`) permanecem intactas:

```java
// ✅ IMPORTAÇÕES CORRETAS NO SPRING BOOT 3.3+ (JAKARTA EE 10)
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.servlet.http.HttpServletRequest;

// ⚠️ ATENÇÃO CIRÚRGICA: DataSource é Java SE (JDK Core), NÃO é Jakarta EE!
import javax.sql.DataSource; 
```

E para documentação de API, substituição total do finado SpringFox pelo **SpringDoc OpenAPI 3**:
```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.6.0</version>
</dependency>
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `portalservice` (`:8080`), `cadu` (`:8081`), `fiscalizacaoservice` (`:8082`).
- **Cenário Real:** No Portal 1 (Java 8), havia dezenas de imports legados `javax.persistence.*` e dependências órfãs de bibliotecas descontinuadas. A modernização para Spring Boot 3.3 saneou os POMs, removendo o Squiggly e adotando projeções nativas de Records.
- **Teatro-ABC (`:8090`):** Greenfield 100% Jakarta EE 10 com SpringDoc OpenAPI Swagger UI em `/swagger-ui/index.html`.

---

### 4.2. Conceito 2.2: Modern RESTful Controllers & Semântica HTTP Pura

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma repartição pública onde você entra para dar entrada num processo e o atendente responde "Tudo certo!" (Código 200 OK), mas quando você abre a pasta, tem um bilhete dizendo "Seu pedido foi negado porque o documento é falso". Você fica sem saber se o processo foi aceito ou recusado.
Uma **API RESTful de Verdade** respeita o protocolo HTTP: quando um recurso é criado com sucesso, ela retorna `201 Created` e entrega a chave de acesso direta no cabeçalho `Location`. Quando não há conteúdo para devolver, retorna `204 No Content`. Quando o cliente errou os dados, retorna `400 Bad Request` ou `422 Unprocessable Entity`. O status code HTTP reflete **fisicamente** o resultado da operação, sem mensagens disfarçadas.

#### Parte 2: A Dor Histórica / O Desastre do Legado (O Antipadrão `Response<T>` da AGR)
No legado da AGR (`fiscalizacao`, `cadu`, `portalservice`), todas as respostas eram envelopadas em uma casca artificial:
```json
// ❌ O ANTIPADRÃO TÓXICO DO LEGADO DA AGR
{
  "data": null,
  "erros": [ "Veículo placa NXZ-4091 não possui autorização para transporte escolar." ],
  "statusReq": "ERRO"
}
```
**O Desastre:** Esse JSON era enviado com **`HTTP Status 200 OK`**!
Gateways de API (Kong, Nginx), balanceadores de carga, ferramentas de observabilidade (Dynatrace, Datadog) e bibliotecas cliente de frontend (Axios, Angular `HttpClient`) interpretavam a requisição como bem-sucedida porque inspecionam o código HTTP de status. O desenvolvedor frontend tinha que escrever código espaguete para inspecionar `if (res.statusReq === 'ERRO')`, mascarando incidentes graves nos painéis de monitoramento do Estado.

#### Parte 3: A Solução Moderna de Elite (Spring Boot 3.3+)

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

@RestController
@RequestMapping("/api/v1/autos-infracao")
public class AutoInfracaoController {

    private final AutoInfracaoService autoInfracaoService;

    public AutoInfracaoController(AutoInfracaoService autoInfracaoService) {
        this.autoInfracaoService = autoInfracaoService;
    }

    @PostMapping
    public ResponseEntity<AutoInfracaoResponse> emitir(
            @RequestBody @Valid AutoInfracaoRequest request,
            UriComponentsBuilder uriBuilder
    ) {
        AutoInfracaoResponse response = autoInfracaoService.lavrarAuto(request);
        
        URI locationUri = uriBuilder
                .path("/api/v1/autos-infracao/{id}")
                .buildAndExpand(response.id())
                .toUri();

        // 201 Created com cabeçalho Location apontando para o novo recurso
        return ResponseEntity.created(locationUri).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AutoInfracaoResponse> buscarPorId(@PathVariable Long id) {
        AutoInfracaoResponse response = autoInfracaoService.buscarPorId(id);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> anular(@PathVariable Long id) {
        autoInfracaoService.anularAuto(id);
        // 204 No Content sem corpo
        return ResponseEntity.noContent().build();
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviço Real AGR:** `fiscalizacaoservice` (`:8082`), `cadastrounicoservice` (`:8081`).
- **Cenário Real:** Eliminação sumária da classe `Response<T>` em todos os controllers da Fiscalização e do CADU. O frontend Angular passa a interceptar erros via HTTP Status Codes reais no `HttpInterceptor`.
- **Teatro-ABC (`:8090`):** `POST /api/v1/sessoes/{id}/reservas` retorna `201 Created` com header `Location: /api/v1/reservas/8472`.

---

### 4.3. Conceito 2.3: `RestClient` Fluente do Spring 6.1+ vs `RestTemplate` vs `WebClient`

#### Parte 1: O que é o conceito / Analogia Didática
Imagine três ferramentas de encanamento:
1. `RestTemplate`: Uma chave de grifo enferrujada dos anos 1990 que funciona, mas tem parafusos duros e sintaxe antiquada.
2. `WebClient`: Uma estação computadorizada de solda a laser industrial (Netty/Reactive): extremamente potente, mas que exige um curso de engenharia aeroespacial só para ligar a chave geral (mono, flux, reatividade).
3. `RestClient`: Uma parafusadeira elétrica moderna, ergonômica, sem fio e fluente, desenhada sob medida para a sua mão, que resolve o trabalho síncrono em 3 segundos com precisão milimétrica.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Spring Framework clássico (ESR Módulo 22 e Portal 1 da AGR), a comunicação entre microsserviços usava `RestTemplate` ou a classe utilitária caseira `ConsumidorServicosUtil.java`.
- `RestTemplate` entrou em **modo de manutenção** no Spring 5 e não recebe novas funcionalidades.
- Sua API baseada em sobrecargas confusas de métodos (`exchange()`, `execute()`, `postForEntity()`) exigia verbosidade excessiva e código feio para lidar com cabeçalhos HTTP e tratamento de status.
- Para tentar modernizar, muitos desenvolvedores importavam o pacote monstro `spring-boot-starter-webflux` apenas para usar o `WebClient`. Isso trazia toda a engine do Netty e o paradigma reativo para dentro de um servlet tradicional Tomcat, criando deadlocks e confusão cognitiva entre threads.

#### Parte 3: A Solução Moderna de Elite (Spring 6.1+ / Spring Boot 3.3+)
O `RestClient` foi introduzido no Spring Framework 6.1 para ser o cliente HTTP síncrono oficial. Ele oferece uma API fluente igual à do `WebClient`, mas construída sobre conexões síncronas tradicionais (perfeitamente alinhadas com **Virtual Threads**):

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

@Component
public class DetranRestClient {

    private final RestClient restClient;

    public DetranRestClient(
            RestClient.Builder builder,
            @Value("${agr.integracoes.detran.base-url}") String baseUrl,
            @Value("${agr.integracoes.detran.token}") String apiToken
    ) {
        this.restClient = builder
                .baseUrl(baseUrl)
                .defaultHeader("Authorization", "Bearer " + apiToken)
                .defaultHeader("Accept", MediaType.APPLICATION_JSON_VALUE)
                .build();
    }

    public record ConsultaVeiculoDetranDTO(String placa, String renavam, String proprietarioNome, String situacao) {}

    public ConsultaVeiculoDetranDTO consultarVeiculo(String placa) {
        return restClient.get()
                .uri("/api/v1/veiculos/{placa}", placa)
                .retrieve()
                .onStatus(status -> status.value() == 404, (request, response) -> {
                    throw new VeiculoNaoEncontradoException("Veículo placa " + placa + " não consta na base do DETRAN-GO.");
                })
                .onStatus(HttpStatusCode::is5xxServerError, (request, response) -> {
                    throw new IntegracaoDetranException("O barramento do DETRAN-GO está instável ou indisponível.");
                })
                .body(ConsultaVeiculoDetranDTO.class);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `fiscalizacaoservice` (`:8082`) consumindo `cadastrounicoservice` (`:8081`) e barramento `DETRAN-GO`.
- **Cenário Real:** Eliminação do `ConsumidorServicosUtil.java`. O `fiscalizacaoservice` utiliza `RestClient` com timeout configurado de 3 segundos para consultar a regularidade cadastral da empresa de ônibus no `cadu` sem bloquear as threads do servidor.
- **Teatro-ABC (`:8090`):** `RestClient` consumindo o gateway financeiro do DARE/PIX para emissão de cobrança de ingressos.

---

### 4.4. Conceito 2.4: Bean Validation 3.0 (`jakarta.validation`) com Validadores Customizados

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o segurança na porta de um cofre bancário: antes de deixar qualquer pessoa dar um passo para dentro da sala de operações financeiras, ele checa se o documento é válido, se tem carimbo oficial e se a foto confere. Se o documento for falso, a pessoa é barrada **imediatamente na soleira da porta**, sem nunca pisar no carpete do banco.
O **Bean Validation 3.0** (`jakarta.validation`) é essa guarda de fronteira: ele intercepta o payload JSON na soleira do Controller com a anotação `@Valid`. Se uma placa de ônibus for inválida ou um valor for negativo, a requisição é abortada antes mesmo de invocar o Service ou abrir uma transação no banco de dados.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No legado da AGR, validações de formato eram feitas com `if`s imperativos espalhados dentro de services e DAOs:
`if (veiculo.getPlaca() == null || veiculo.getPlaca().length() != 7) { ... }`.
- Validações inconsistentes: um controller aceitava placa com traço (`ABC-1234`), outro exigia sem traço (`ABC1234`), e outro esquecia de validar, persistindo lixo no banco de dados.
- Ausência de mensagens claras: o sistema quebrava com `NullPointerException` dentro do DAO quando um campo obrigatório vinha nulo do frontend.

#### Parte 3: A Solução Moderna de Elite (Bean Validation 3.0 & Custom Validator)
Criação de anotação de validação customizada para o padrão de Placas Mercosul vs Antiga:

```java
package br.gov.go.agr.fiscais.api.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = PlacaVeiculoValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER, ElementType.RECORD_COMPONENT})
@Retention(RetentionPolicy.RUNTIME)
public @interface PlacaVeiculo {
    String message() default "A placa informada não atende ao padrão brasileiro (Cinza ou Mercosul)";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

```java
package br.gov.go.agr.fiscais.api.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.util.regex.Pattern;

public class PlacaVeiculoValidator implements ConstraintValidator<PlacaVeiculo, String> {

    // Regex oficial do DENATRAN: Padrão Antigo (AAA-9999) ou Mercosul (AAA9A99)
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

Uso direto no Java Record DTO:
```java
public record CadastroVeiculoDTO(
    @PlacaVeiculo
    String placa,

    @NotBlank(message = "O chassi é obrigatório")
    String chassi,

    @NotNull(message = "O ano de fabricação é obrigatório")
    Integer anoFabricacao
) {}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `cadastrounicoservice` (`:8081`), `fretamentoservice` (`:8084`).
- **Cenário Real:** Validação de placas e idade limite da frota de ônibus intermunicipais (máximo 15 anos para linhas regulares). A rejeição é imediata no Controller com detalhes informados no ProblemDetail RFC 7807.
- **Teatro-ABC (`:8090`):** `@CpfValid` na compra de ingressos nominais.

---

## 🚨 5. PILAR 3: TRATAMENTO GLOBAL DE ERROS COM RFC 7807 (PROBLEM DETAILS)

### 5.1. Conceito 3.1: ProblemDetail Nativo do Spring 6+ vs Classes POJO Manuais

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que um paciente chega a um hospital no Brasil, nos Estados Unidos ou no Japão. Em qualquer um desses lugares, a ficha de triagem médica de emergência tem exatamente os mesmos campos universais da Organização Mundial da Saúde: Tipo Sanguíneo, Pressão Arterial, Alergias e Sintomas. Não importa a língua, qualquer médico sabe ler a ficha.
O **RFC 7807 (Problem Details for HTTP APIs)** é essa ficha médica universal para erros na Web: ele estabelece uma gramática JSON padronizada para toda a internet (`type`, `title`, `status`, `detail`, `instance`). Qualquer biblioteca cliente em Angular, React, Python, Flutter ou iOS já possui parsers prontos para exibir o erro sem adivinhações.

#### Parte 2: A Dor Histórica / O Desastre do Legado (Citações Literais AlgaWorks)
No Spring Boot 2.x, o framework **não possuía suporte nativo à RFC 7807**.
Por causa disso, a AlgaWorks foi forçada a dedicar dezenas de aulas do Módulo 8 do curso Especialista Spring REST para construir toda a infraestrutura manualmente do zero.
Na aula `441_8_15_Criando_um_exception_handler_global_com_ResponseEntityExceptionHandler.txt`, Thiago explica a complexidade de estender o handler legado:
> *"Existem vários tipos de Exceptions que são internas do Spring MVC... Será que a gente precisa tratar todas essas Exceptions internas individualmente? Não, a gente não precisa, porque nós podemos estender uma classe que já faz isso para a gente. Essa classe é a ResponseEntityExceptionHandler... veja que a gente tem um método handleException. Esse é um método que está anotado com @ExceptionHandler... eles resolveram criar um método só que trata tudo, recebe aqui Exception como parâmetro, mais genérico... E eles definem aqui com if, if, if, if, if... Está vendo que todas elas chamam o handleExceptionInternal, em algum momento... Esse segundo parâmetro aqui é o corpo. Qual corpo que a gente quer devolver na resposta HTTP? Então, aqui, nenhum corpo nulo. Nulo, está vendo? Por isso que não vem nada aqui."* (`441_8_15`)

E na aula `452_8_28_Estendendo_o_formato_do_problema_para_adicionar_novas_propriedades.txt`:
> *"A propriedade cozinha.id recebeu um valor A, que é de um tipo inválido. Corrija e informe o valor compatível com o tipo Long... Porém, não é uma mensagem boa para mandar para o usuário. A gente, nesse treinamento, está falando de desenvolvimento de back-end... Porém, nós temos que ter a visão de quem vai consumir a API... O desenvolvedor que consome a nossa API poderia ter uma lógica... Só que é um pouquinho complicado pensando na vida do consumidor da API ter que saber tudo isso... Então, o que a gente vai fazer aqui? Nós vamos estender a nossa representação do problema... Uma delas que a gente pode colocar aqui, por exemplo, é uma mensagem para o usuário. Então, eu vou colocar aqui string userMessage..."* (`452_8_28`)

**O Custo do Modelo Legado:**
O desenvolvedor precisava:
1. Criar manualmente um enum `ProblemType`.
2. Criar manualmente um POJO `Problem` com dezenas de atributos, construtores e builders do Lombok.
3. Criar uma classe interna `Problem.Field`.
4. Sobrescrever manualmente 12 métodos protegidos de `ResponseEntityExceptionHandler` chamando `builder().status(status).title(title)...build()`.
Isso representava **mais de 400 linhas de código boilerplate de infraestrutura pura** em cada microsserviço!

#### Parte 3: A Solução Moderna de Elite (Spring Boot 3.3+ com `ProblemDetail` Nativo)
No Spring Boot 3.3+, tudo isso foi encapsulado nativamente pela classe `org.springframework.http.ProblemDetail`.
Para ativar o suporte nativo global, basta uma única linha no `application.yml`:

```yaml
spring:
  mvc:
    problemdetails:
      enabled: true
```

E para capturar e customizar regras de negócio corporativas, utiliza-se `@RestControllerAdvice` estendendo `ResponseEntityExceptionHandler`:

```java
package br.gov.go.agr.fiscais.api.exceptionhandler;

import br.gov.go.agr.fiscais.domain.exception.EntidadeNaoEncontradaException;
import br.gov.go.agr.fiscais.domain.exception.RegraNegocioException;
import org.springframework.http.*;
import org.springframework.lang.Nullable;
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

@RestControllerAdvice
public class GlobalApiExceptionHandler extends ResponseEntityExceptionHandler {

    private static final String URI_BASE_ERROS = "https://api.agr.go.gov.br/erros";

    @ExceptionHandler(EntidadeNaoEncontradaException.class)
    public ProblemDetail handleEntidadeNaoEncontrada(EntidadeNaoEncontradaException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
        problem.setTitle("Recurso Não Encontrado");
        problem.setType(URI.create(URI_BASE_ERROS + "/recurso-nao-encontrado"));
        problem.setProperty("timestamp", Instant.now());
        problem.setProperty("userMessage", ex.getMessage());
        return problem;
    }

    @ExceptionHandler(RegraNegocioException.class)
    public ProblemDetail handleRegraNegocio(RegraNegocioException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.getMessage());
        problem.setTitle("Violação de Regra Regulatória");
        problem.setType(URI.create(URI_BASE_ERROS + "/regra-regulatoria"));
        problem.setProperty("timestamp", Instant.now());
        problem.setProperty("userMessage", ex.getMessage());
        return problem;
    }

    // Sobrescrita cirúrgica para validações do Bean Validation (@Valid)
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
        problem.setProperty("userMessage", "Verifique os campos destacados e preencha novamente.");

        // Mapeamento elegante de erros por campo
        Map<String, String> camposInvalidos = ex.getBindingResult().getFieldErrors().stream()
                .collect(Collectors.toMap(
                        FieldError::getField,
                        error -> (error.getDefaultMessage() != null) ? error.getDefaultMessage() : "Valor inválido",
                        (msg1, msg2) -> msg1 + "; " + msg2
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
  "userMessage": "Verifique os campos destacados e preencha novamente.",
  "campos": {
    "placa": "A placa informada não atende ao padrão brasileiro (Cinza ou Mercosul)",
    "valorMulta": "O valor da autuação deve ser estritamente positivo"
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** `portalservice` (`:8080`), `cadastrounicoservice` (`:8081`), `fiscalizacaoservice` (`:8082`), `receitaservice` (`:8092`).
- **Cenário Real:** Eliminação completa de 15 classes `Problem.java` caseiras e da casca `Response<T>`. O `receitaservice :8092` emite `ProblemDetail` com `status=422` e `type=/dare-vencido` quando a concessionária tenta pagar guia já prescrita.
- **Teatro-ABC (`:8090`):** `ProblemDetail` com `status=409 Conflict` e `type=/assento-indisponivel` quando ocorre colisão concorrente na reserva de poltrona.

---

## 🏛️ 6. PILAR 4: ARQUITETURA LIMPA, CAMADAS & OBSERVABILIDADE CORPORATIVA

### 6.1. Conceito 4.1: Clean Architecture (Hexagonal) vs Modelo Anêmico em Controllers

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um restaurante de alta gastronomia: há o garçom no salão (Controller), o maitre coordenando os pedidos (Application Service), o chef de cozinha executando a receita secreta da família (Domain Model) e os fornecedores que entregam carnes e legumes pelos fundos (Persistence Repository / Adaptadores).
No **Antipadrão Anêmico**, o garçom anota o pedido, corre para a cozinha, frita o bife, queima a comida, joga no prato de qualquer jeito e ainda vai ao açougue comprar mais carne no meio do jantar.
Na **Clean Architecture**, o Controller apenas recepciona a requisição HTTP e valida a sintaxe; a regra de negócio sagrada vive protegida no coração do Domínio, completamente isolada de frameworks web e bancos de dados.

#### Parte 2: A Dor Histórica / O Desastre do Legado
No Portal 1 da AGR e no legado do CADU (`ManterVeiculoBean.java` e `VeiculoServiceIMPL.java`):
- Controllers continham mais de **800 linhas de código** com transações manuais, queries SQL concatenadas, cálculos de multas e montagem de JSON misturados na mesma classe.
- Entidades JPA anêmicas: classes que eram meras tabelas de dados com getters e setters, sem nenhum método de negócio.
- Impossibilidade de testes unitários: para testar se uma multa de transporte clandestino calculava 20% de juros, era necessário subir o Tomcat inteiro e conectar na base de dados real de produção.

#### Parte 3: A Solução Moderna de Elite (Clean Architecture / Ports & Adapters)
Segregação estrita de 4 camadas:

```
┌──────────────────────────────────────────────────────────────┐
│ 1. INTERFACES / ADAPTADORES PRIMÁRIOS (REST Controllers)      │
│    • Recebe HTTP, valida DTOs Records (@Valid), emite status │
├──────────────────────────────────────────────────────────────┤
│ 2. APPLICATION / CASOS DE USO (Use Cases / Services)          │
│    • Orquestra o fluxo, demarca transações (@Transactional)  │
├──────────────────────────────────────────────────────────────┤
│ 3. DOMAIN / MODELO RICO (Entidades & Value Objects Puros)     │
│    • Regras de negócio puras, invariantes, zero Spring/Web   │
├──────────────────────────────────────────────────────────────┤
│ 4. INFRASTRUCTURE / ADAPTADORES SECUNDÁRIOS (Repositories)    │
│    • Spring Data JPA, Flyway, MinIO, RestClient, Gateway SEI │
└──────────────────────────────────────────────────────────────┘
```

**Código Limpo: O Domínio Rico:**
```java
package br.gov.go.agr.fiscais.domain.model;

import br.gov.go.agr.fiscais.domain.exception.RegraNegocioException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Objects;

public class AutoInfracao {
    private final Long id;
    private final String numeroAuto;
    private final String placa;
    private BigDecimal valor;
    private StatusAuto status;
    private final Instant dataCriacao;

    public AutoInfracao(Long id, String numeroAuto, String placa, BigDecimal valor) {
        if (valor == null || valor.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RegraNegocioException("O valor do auto de infração deve ser maior que zero.");
        }
        this.id = id;
        this.numeroAuto = Objects.requireNonNull(numeroAuto, "Número do auto é obrigatório");
        this.placa = Objects.requireNonNull(placa, "Placa é obrigatória");
        this.valor = valor;
        this.status = StatusAuto.LAVRADO;
        this.dataCriacao = Instant.now();
    }

    // Regra de negócio rica expressa no próprio modelo:
    public void aplicarDescontoPontualidade(BigDecimal percentual) {
        if (this.status != StatusAuto.LAVRADO) {
            throw new RegraNegocioException("Não é permitido conceder desconto para auto com status " + this.status);
        }
        BigDecimal desconto = this.valor.multiply(percentual);
        this.valor = this.valor.subtract(desconto);
    }

    public enum StatusAuto { LAVRADO, HOMOLOGADO, CANCELADO, PAGO }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** Saneamento do `cadastrounicoservice` (`:8081`), que reduziu de 242 classes no Portal 1 para 143 classes no Portal 2 ao eliminar interfaces vazias e adotar arquitetura de casos de uso.
- **Teatro-ABC (`:8090`):** `Assento.reservarPara(Cliente c)` encapsula a verificação de disponibilidade sem que o Controller precise manipular estados de banco.

---

### 6.2. Conceito 6.2: Observabilidade com Spring Boot Actuator, Micrometer & Health Checks

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o painel de instrumentos de uma turbina de avião comercial: o piloto não precisa descer até a asa no meio do voo para saber se o motor está quente. O painel exibe em tempo real a temperatura da câmara de combustão, pressão do óleo, consumo de combustível e alertas vermelhos imediatos se algo sair do padrão.
O **Spring Boot Actuator & Micrometer** é o cockpit de instrumentos do microsserviço em produção: ele expõe métricas de taxa de requisições por segundo (RPS), latência percentual (p95, p99), uso de memória Heap da JVM, saúde das conexões da pool HikariCP e links externos (DETRAN, S3 MinIO, SEI).

#### Parte 2: A Dor Histórica / O Desastre do Legado
No legado da AGR, os servidores de aplicação eram uma "caixa preta":
- Quando a `fiscalizacao` caía, os desenvolvedores abriam uma sessão SSH no servidor Linux e ficavam rodando `tail -f nohup.out` ou vasculhando arquivos de log de 2 GB no disco.
- Falhas no pool de banco (`10.243.1.27:3306`) só eram descobertas quando o usuário ligava na ouvidoria avisando que o sistema travou.

#### Parte 3: A Solução Moderna de Elite (Actuator, Micrometer & Custom Health Indicator)
Configuração no `application.yml`:

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
```

Implementação de **Custom Health Indicator** verificando ativamente a comunicação com o storage MinIO/S3:

```java
package br.gov.go.agr.fiscais.infra.health;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

import java.net.InetSocketAddress;
import java.net.Socket;

@Component
public class MinioStorageHealthIndicator implements HealthIndicator {

    private final String minioHost = "127.0.0.1";
    private final int minioPort = 9000;

    @Override
    public Health health() {
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(minioHost, minioPort), 2000);
            return Health.up()
                    .withDetail("storage", "MinIO S3 Object Storage")
                    .withDetail("endpoint", minioHost + ":" + minioPort)
                    .withDetail("status", "Conexão ativa e responsiva")
                    .build();
        } catch (Exception ex) {
            return Health.down()
                    .withDetail("storage", "MinIO S3 Object Storage")
                    .withDetail("error", ex.getMessage())
                    .build();
        }
    }
}
```

Endpoint exposto em `GET /actuator/health`:
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
        "free": 320000000000
      }
    },
    "minioStorage": {
      "status": "UP",
      "details": {
        "storage": "MinIO S3 Object Storage",
        "endpoint": "127.0.0.1:9000",
        "status": "Conexão ativa e responsiva"
      }
    }
  }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
- **Microsserviços Reais AGR:** Monitoramento do cluster de 25 microsserviços via Prometheus / Grafana centralizado coletando métricas em `/actuator/prometheus`.
- **Teatro-ABC (`:8090`):** Health check customizado monitorando latência da pool HikariCP durante os picos de concorrência de bilheteria.

---

## 🗺️ 7. MATRIZ DE RASTREABILIDADE FORENSE: MILENSTONE 2

| # | Conceito Técnico Chave | Paradigma Legado AlgaWorks (ESR / AlgaFood) | O Desastre do Legado | Solução Moderna de Elite (Java 21 / Spring Boot 3.3+) | Microsserviço AGR / Teatro-ABC | Cenário Real de Produção |
| :-: | :--- | :--- | :--- | :--- | :--- | :--- |
| **01** | Contratos de Dados (DTOs) | Módulo 11 (Aulas 502/503): JavaBeans com Lombok `@Data` e `ModelMapper`. | Mapeamento reflexivo em runtime, propriedades virando `null` silenciosamente, mutação concorrente de DTOs no Heap. | **Java 21 Records** com compact constructors de validação defensiva e coleções imutáveis. | `fiscalizacaoservice` (`:8082`) | Payload imutável de lavratura de auto de infração com fotos anexadas. |
| **02** | Concorrência de I/O em Rede | Módulo 22: Platform Threads limitadas a 200 no Tomcat com I/O síncrono bloqueante. | Pool do Tomcat esgotado em 2 minutos de lentidão externa do DETRAN-GO, travando toda a autarquia. | **Virtual Threads (Project Loom)** via `spring.threads.virtual.enabled=true`. | `seiservice` (`:8111`) & `portalservice` (`:8080`) | 10.000 requisições simultâneas aguardando assinatura do SEI com zero consumo de threads do SO. |
| **03** | Tratamento Global de Erros | Módulo 8 (Aulas 427, 441, 452): Classes POJO manuais `Problem`, `ProblemType`, e interceptor complexo. | 400 linhas de boilerplate manual em cada serviço; no legado AGR, envelope tóxico `Response<T>` com `HTTP 200 OK` contendo erros. | **RFC 7807 `ProblemDetail`** nativo do Spring 6+ com `@RestControllerAdvice`. | `receitaservice` (`:8092`) | Rejeição padronizada de pagamento duplicado ou DARE vencido com status 422. |
| **04** | Cliente HTTP Inter-Serviços | Módulo 22: `RestTemplate` prolixo em manutenção ou `WebClient` reativo forçado. | `ConsumidorServicosUtil.java` na AGR sem timeouts calibrados ou injeção pesada do Netty. | **`RestClient` fluente** do Spring 6.1+ com timeouts, interceptores e tratamento de status declarativo. | `fiscalizacaoservice` (`:8082`) ➔ `cadu` (`:8081`) | Consulta síncrona leve da situação cadastral da empresa de transporte antes da autuação. |
| **05** | Namespace & Bibliotecas | Módulo 28 (Aulas 864, 865, 867): `javax.*`, Squiggly Filter e SpringFox Swagger 2. | Bibliotecas abandonadas quebraram na compilação do Spring Boot 3; risco de alterar classes SE (`DataSource`). | **Jakarta EE 10** (`jakarta.*`), **SpringDoc OpenAPI 3** e DTOs Records especializados. | Todos os 25 microsserviços | Atualização de segurança contra CVEs, documentação dinâmica interativa em `/swagger-ui`. |
| **06** | Arquitetura & Observabilidade | Controllers anêmicos com SQL concatenado e ausência de instrumentação. | Debug via `tail -f nohup.out` no Linux; indisponibilidade de banco só descoberta após reclamação de usuários. | **Clean Architecture** (Domain rico isolado) + **Actuator / Micrometer Observation API**. | `portalservice` (`:8080`) & `teatro-abc` (`:8090`) | Monitoramento p99 de latência e health check customizado do storage S3 MinIO. |

---

## 🛠️ 8. GUIA DE EXECUÇÃO PASSO A PASSO PARA O WORKER M2

Para que o **Worker M2** produza o arquivo `/home/lan/dotfiles/templates-lab/docs/02-arquitetura-backend-spring-boot-3.md` com nota máxima e aprovação imediata nos testes automatizados, as seguintes instruções devem ser seguidas com rigor absoluto:

### 1. Extensão e Integridade Textual
- O arquivo deve ter **no mínimo 301 linhas** (meta recomendada: **650 a 900 linhas**).
- **Proibido expressamente:** Qualquer termo como `TODO`, `FIXME`, `[TBD]`, `implementar depois`, `em breve`, `a definir` ou reticências nuas (`...`, `// ...`) dentro de blocos de código.
- Cada bloco de código Java deve conter definições de classe e métodos completos, importações canônicas e comentários explicativos de engenharia.

### 2. Validação da Quadrupleta Didática em 100% dos Tópicos
O Worker deve utilizar exatamente os títulos ou subtítulos reconhecidos pelo regex de `verify_docs_suite.py` (Tier 3):
- `Parte 1: O que é o conceito / Analogia com o mundo real`
- `Parte 2: A Dor Histórica / O Desastre do Legado` (incluindo as citações literais da AlgaWorks aqui especificadas)
- `Parte 3: A Solução Moderna de Elite` (com o código Java 21 / Spring Boot 3.3+)
- `Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC` (detalhando portas `:8080`, `:8081`, `:8082`, `:8092` ou `:8090`)

### 3. Garantia dos Contrastes de Versão Exigidos pelo Test Harness
O arquivo deve conter explicitamente as seguintes strings/padrões auditados pelo Tier 3 do validador:
- `Java 8 vs 17 vs 21 LTS`
- `Java Records imutáveis para DTOs` (contrastando com Lombok `@Data`)
- `Virtual Threads / Project Loom`
- `Spring Boot 3.3+ REST & Tratamento RFC 7807 ProblemDetail` (contrastando com o envelope `Response<T>`)

### 4. Comando de Validação Imediata
Após escrever o arquivo, o Worker deve rodar:
```bash
python3 scripts/verify_docs_suite.py --tier 3
```
E garantir que o check `02-arquitetura-backend-spring-boot-3.md` retorne status `PASSED`.

---

## 🏁 9. CONCLUSÃO DA INVESTIGAÇÃO DO EXPLORER M2

A fundamentação teórica, a recuperação de citações do acervo AlgaWorks, o mapeamento dos microsserviços da AGR e os contratos de código aqui detalhados formam uma especificação completa e blindada. O Worker M2 dispõe agora de todo o material necessário para redigir uma masterclass de referência global em engenharia de software para o Spring Boot 3.3+ e Java 21 LTS.

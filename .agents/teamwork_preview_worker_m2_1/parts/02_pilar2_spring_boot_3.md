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


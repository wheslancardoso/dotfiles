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


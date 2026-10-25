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


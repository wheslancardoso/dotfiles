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

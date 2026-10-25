# Módulo 04: Segurança Corporativa Stateless: Spring Security 6, OAuth2 Resource Server, JWT & RBAC Granular

> **Autor:** Suíte de Engenharia de Software & Arquitetura Pedagógica (templates-lab)  
> **Versão Normativa:** Java 21 LTS | Spring Boot 3.3+ | Spring Security 6.3+ | OAuth 2.1 / RFC 6749 / RFC 7636 / RFC 7519  
> **Ambientes de Referência:** Ecossistema Regulatório AGR-Docs (25 Microsserviços Reais) & Plataforma Greenfield Teatro-ABC (:8090)  
> **Status:** Especificação Canônica de Elite — Top 5% Global

---

## Sumário Executivo & Manifesto da Segurança Stateless de Elite

A segurança de software em arquiteturas distribuídas e ecossistemas de microsserviços corporativos atingiu um divisor de águas irrevogável: o colapso definitivo dos modelos de segurança baseados em estado de sessão no servidor (**Stateful Security / JSESSIONID**) e o banimento de fluxos de credenciais opacas em prol do padrão **Zero-Trust com Tokens Autocontidos Assinados Criptograficamente (Stateless JWT / OAuth 2.1)**.

Em sistemas governamentais de fiscalização e arrecadação de alta sensibilidade — como a malha de 25 microsserviços da **Agência Goiana de Regulação, Controle e Fiscalização de Serviços Públicos (AGR)** — e em plataformas de alta concorrência com validação de acesso em tempo real — como a bilhetagem do **Teatro-ABC (Centro Cultural Oscar Niemeyer)** —, o desconhecimento dos princípios modernos de segurança de APIs provoca catástrofes de proporções épicas:
1. **Acoplamento Destrutivo e Incompatibilidade de Escala:** O uso de sessões HTTP em memória (`HttpSession`) e cookies de sessão (`JSESSIONID`) inviabiliza o balanceamento de carga horizontal, forçando o uso de sessões pegajosas (*sticky sessions*) no gateway de rede e gerando estouro de memória (*Out-of-Memory*) sob picos de tráfego;
2. **Vulnerabilidade Sistêmica por Chave Simétrica Compartilhada:** O compartilhamento irresponsável de uma mesma senha/segredo simétrico (`jwt.secret=sw!tch14`) entre dezenas de microsserviços. Caso um único serviço satélite menos protegido sofresse invasão, o atacante obtinha a chave simétrica e conseguia forjar tokens JWT válidos para todo o ecossistema estadual, incluindo permissões de Administrador e Auditor Fiscal;
3. **A Armadilha do Password Grant (`grant_type=password`):** Aplicações clientes (frontends SPA Angular e aplicativos móveis) coletando diretamente as credenciais puras de login e senha do usuário final, expondo senhas em trânsito e na memória volátil do navegador, além de inviabilizar a integração com autenticação federada (Gov.br) e Múltiplo Fator de Autenticação (MFA);
4. **Bypass de Autorização por Falha de Matching de URL (CVE-2023-34035):** O uso do legado `antMatchers()`, suscetível a divergências de interpretação de barras duplas e sufixos entre o Spring MVC e o Spring Security, superado obrigatoriamente pelo `requestMatchers()`;
5. **Confusão de Escopos vs Perfis de Negócio:** Mistura indiscriminada de `scope` (delegação de cliente OAuth2) e `roles` (papel de negócio do usuário), permitindo que um aplicativo parceiro com escopo de leitura consiga acidentalmente invocar endpoints de gravação se a verificação de autoridade não for estritamente prefixada.

O Módulo 04 da suíte pedagógica tem como missão desmistificar a arquitetura de segurança do **Spring Security 6.3+ / Spring Boot 3.3+**, instruindo o desenvolvedor a construir uma fortaleza digital com separação estrita entre **Authorization Server** (emissor de tokens via chaves assimétricas RSA/JWKS) e **Resource Server** (validador stateless), com autorização declarativa em nível de método via `@PreAuthorize` e expressões SpEL refinadas.

Todo o conteúdo deste módulo obedece rigorosamente à **Quadrupleta Didática Canônica**:
- **Parte 1: O que é o conceito / Analogia Didática** — Modelagem mental intuitiva conectada a sistemas físicos do mundo real;
- **Parte 2: A Dor Histórica / O Desastre do Legado** — Dissecação forense das falhas reais em produção, com citações literais transcritas do acervo canônico AlgaWorks (*Especialista Spring REST* - ESR);
- **Parte 3: A Solução Moderna de Elite** — Implementações completas em Java 21 LTS e Spring Security 6.3+, tipadas, compiláveis e com boas práticas de engenharia;
- **Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC** — Aplicação nos 25 microsserviços regulatórios de Goiás e na bilhetagem de eventos.

---

## Matriz de Evolução Arquitetural de Segurança: Legado vs Elite

A evolução dos padrões de segurança no Spring Framework e nas especificações OAuth reflete uma transição profunda de arquitetura de software:

| Dimensão de Segurança | Paradigma Legado (Spring Boot 2.x / OAuth 2.0) | Paradigma de Transição (Spring Boot 2.7 / Security 5.x) | Paradigma de Elite (Spring Boot 3.3+ / Security 6.3+ / OAuth 2.1) |
| :--- | :--- | :--- | :--- |
| **Configuração Web** | Herança da classe abstrata `WebSecurityConfigurerAdapter` e chamadas `configure(HttpSecurity)`. | Depreciação de `WebSecurityConfigurerAdapter` (anúncio na v5.7). Configurações híbridas com `antMatcher`. | **Component-based configuration estrita** via `@Bean SecurityFilterChain` utilizando DSL fluente com lambdas. |
| **Mapeamento de Rotas** | `antMatchers()` e `regexMatchers()` suscetíveis a discrepâncias de parsing entre servlet e controller. | Transição para `requestMatchers()` com incompatibilidades pontuais no Spring Boot 2.7. | **`requestMatchers()` unificado** com `MvcRequestMatcher` integrado ao `PathPatternParser` do Spring MVC (Anti-Bypass). |
| **Estado de Sessão** | `SessionCreationPolicy.IF_REQUIRED` com cookies `JSESSIONID` em memória e replicação pesada. | Sessões stateless em REST, mas com resquícios de filtros manuais checando sessão HTTP. | **`SessionCreationPolicy.STATELESS` obrigatório**. Eliminação do `HttpSession`. Zero cookies de sessão de API. |
| **Proteção CSRF** | CSRF ativado para toda a aplicação, exigindo tokens sincronizados em cookies ou desativação global cega. | Desativação imperativa `.csrf().disable()`. Falta de entendimento sobre por que APIs stateless não usam CSRF. | **`csrf(AbstractHttpConfigurer::disable)` cirúrgico**, motivado pela ausência de cookies de autenticação no browser. |
| **Criptografia JWT** | Algoritmos simétricos HMAC-SHA256 (`HS256`) com segredos compartilhados (`jwt.secret`) em arquivos `.properties`. | Introdução de chaves RSA, mas frequentemente distribuídas via arquivos JKS manuais nos microsserviços. | **Criptografia Assimétrica RSA (RS256)** com rotação contínua e distribuição dinâmica via **JWKS (`/.well-known/jwks.json`)**. |
| **Fluxo de Clientes SPA** | **Resource Owner Password Credentials (`grant_type=password`)** e Implicit Grant (`response_type=token`). | Desencorajamento formal do Password Grant; surgimento do PKCE para mobile e navegadores. | **Banimento oficial do Password Grant e do Implicit Grant**. Adoção universal de **Authorization Code Flow com PKCE (RFC 7636)**. |
| **Comunicação M2M** | Senhas estáticas codificadas em base64 (Basic Auth) ou tokens forjados com identidade de usuários admin. | Tokens JWT de longa duração compartilhados sem rotação ou auditoria de microsserviço chamador. | **OAuth 2.1 Client Credentials Grant** com `RestClient` integrado a `OAuth2AuthorizedClientManager`. |
| **Controle de Acesso RBAC** | Verificações manuais `if (user.hasRole(...))` espalhadas no corpo de métodos de controllers e services. | `@EnableGlobalMethodSecurity(prePostEnabled = true)` com `@Secured` e `@RolesAllowed` confusos. | **`@EnableMethodSecurity(prePostEnabled = true)`** com `@PreAuthorize`, `@PostAuthorize` e SpEL granular avaliando regras ABAC. |

```
ARQUITETURA DE SEGURANÇA: STATEFUL (LEGADO) vs STATELESS ZERO-TRUST (ELITE)

 [ MODELO STATEFUL LEGADO: Acoplamento em Memória ]
  Cliente Web ──[ POST /login ]──> [ Servidor Tomcat ]
                                           │ Cria Session em Memória
  Cliente Web <──[ Set-Cookie: JSESSIONID ]┘ (Heap consumido por usuário)
  Cliente Web ──[ GET /api com Cookie ]──> [ Servidor Tomcat ]
                                           │ Busca sessão no Heap local
                                           └──> Falha se balanceado para Servidor 2!

 [ MODELO STATELESS OAUTH 2.1: Soberania Criptográfica ]
  Cliente SPA ──[ Auth Code + PKCE ]──> [ Keycloak / Authorization Server ]
                                                   │ Emite JWT Assinado (RS256)
  Cliente SPA <──[ Bearer eyJhbGciOi... ]──────────┘ (Chave Privada Segura)
  Cliente SPA ──[ Header: Authorization: Bearer JWT ]──> [ Resource Server 1 ]
                                                          │ Valida com Chave Pública
                                                          ├── Sem bater em banco!
                                                          └── Sem estado em memória!
```

---

## 1. Spring Security 6 Architecture & SecurityFilterChain Component-Based

### 1.1 A Morte Definitiva do WebSecurityConfigurerAdapter e a Nova DSL com Lambdas

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma guarita de segurança em um condomínio empresarial: no modelo antigo, para alterar as regras de entrada de pedestres ou veículos, a administração exigia que você construísse um anexo físico no prédio da portaria, herdando todas as fundações de concreto e tubulações antigas do edifício principal. Se o edifício original sofresse uma reforma estrutural, seu anexo rachava ou desabava por acoplamento físico indevido. 

No modelo moderno, a guarita opera por **módulos independentes de serviço (Component-Based Architecture)**: a cancela de veículos é um equipamento plugável, o leitor biométrico de crachás é outro módulo autônomo, e as câmeras de vigilância operam em rede. Você não precisa herdar o concreto da guarita; basta declarar um roteador de cabos e plugar os módulos funcionais através de interfaces padronizadas.

No Spring Security, essa transformação física é a substituição da classe abstrata `WebSecurityConfigurerAdapter` pelo bean componentizado `@Bean SecurityFilterChain`. Até a versão 5.6 do Spring Security, todo desenvolvedor era obrigado a estender `WebSecurityConfigurerAdapter` e sobrescrever métodos protegidos `configure(HttpSecurity http)`. O encadeamento de regras utilizava uma sintaxe procedural com o método `.and()`, que acumulava estado mutável no builder e gerava erros de compilação confusos e comportamentos imprevisíveis caso a ordem das chamadas fosse alterada.

A partir do **Spring Security 6.0 (integrado ao Spring Boot 3.0+)**, a classe `WebSecurityConfigurerAdapter` foi **definitivamente removida do framework**. A configuração passa a ser 100% declarativa, baseada na injeção de beans onde o desenvolvedor recebe uma instância de `HttpSecurity` e constrói a cadeia de filtros de forma funcional, utilizando exclusivamente expressões lambda (`Customizer<T>`). Essa abordagem elimina a necessidade do método `.and()`, melhora a legibilidade do código, isola o escopo léxico de cada filtro e viabiliza a inferência estrita de tipos pelo compilador do Java 21.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A herança forçada do `WebSecurityConfigurerAdapter` foi ensinada durante anos em cursos consagrados de Spring e causou dores crônicas na evolução dos sistemas empresariais. Na aula **713_22_11** (*Configurando o Resource Server com a nova stack do Spring*) do curso *Especialista Spring REST* da AlgaWorks, o instrutor demonstra a dependência estrutural desse acoplamento:

> *"Vou renomear essa classe aqui para ResourceServerConfig. Beleza. Ela vai continuar herdando aqui o WebSecurityConfigurerAdapter... Bom, esse método aqui para configurar os usuários e senhas para a autenticação, a gente não precisa no Resource Server. Quem faz isso é o Authorization Server..."* (Linhas 26-32).

Essa herança gerava desastres reais em produção:
1. **Acoplamento Indesejado de Funcionalidades:** Ao herdar `WebSecurityConfigurerAdapter`, o desenvolvedor herdava silenciosamente configurações padrão de autenticação em memória, formulários de login HTML (`formLogin`) e suporte a HTTP Basic que não tinham nenhuma utilidade em uma API REST stateless, gerando vulnerabilidades caso esquecesse de desativá-los explicitamente;
2. **O Pesadelo da Sintaxe `.and()`:** As configurações no Spring Security 5 utilizavam encadeamentos infinitos de `.and()`. Quando uma regra de CORS ou CSRF precisava ser ajustada, o desenvolvedor frequentemente anexava a diretiva no ponto errado da árvore sintática, alterando acidentalmente as permissões de rotas subsequentes:
   ```java
   // O CAOS DO LEGADO (Spring Security 5): Acoplamento e .and() infinito
   http
       .authorizeRequests()
           .antMatchers("/public/**").permitAll()
           .anyRequest().authenticated()
       .and()
           .cors()
       .and()
           .csrf().disable(); // Onde termina o authorizeRequests e onde começa o csrf?
   ```
3. **Quebra Traumática na Atualização para o Spring Boot 3:** Quando equipes tentavam atualizar suas aplicações de Spring Boot 2.7 para 3.0, seus projetos simplesmente não compilavam. Milhares de linhas de código espalhadas em classes de segurança herdadas precisavam ser reescritas do zero, expondo a fragilidade de confiar em herança em vez de composição de componentes.

#### Parte 3: A Solução Moderna de Elite
No Spring Security 6.3+ com Java 21, a segurança é configurada através de métodos anotados com `@Bean` que retornam uma instância de `SecurityFilterChain`. O encadeamento de métodos é estritamente funcional, onde cada subsistema de segurança (CORS, CSRF, gerenciamento de sessão, autorização de requisições e OAuth2 Resource Server) recebe um consumidor de configuração em forma de lambda.

Abaixo está a implementação canônica e completa do `SecurityFilterChain`, sem qualquer dependência de classes obsoletas, com imports limpos e validações estritas:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class ResourceServerSecurityConfig {

    private final Converter<Jwt, ? extends AbstractAuthenticationToken> jwtAuthenticationConverter;

    public ResourceServerSecurityConfig(Converter<Jwt, ? extends AbstractAuthenticationToken> jwtAuthenticationConverter) {
        this.jwtAuthenticationConverter = jwtAuthenticationConverter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
            // 1. Desativação consciente do CSRF para clientes Bearer token stateless
            .csrf(AbstractHttpConfigurer::disable)
            
            // 2. Configuração declarativa de CORS baseada em fonte explícita
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            
            // 3. Imposição mandatória de sessões HTTP sem estado (Stateless)
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            
            // 4. Regras de autorização de requisições HTTP via requestMatchers modernos
            .authorizeHttpRequests(authorize -> authorize
                // Observabilidade e Documentação OpenAPI abertas
                .requestMatchers("/actuator/health", "/actuator/info").permitAll()
                .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                
                // Rotas públicas da bilhetagem do Teatro-ABC
                .requestMatchers(HttpMethod.GET, "/api/v1/espetaculos/**").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/v1/sessoes/*/mapa-assentos").permitAll()
                
                // Rotas administrativas e fiscais protegidas por escopo OAuth2 estrito
                .requestMatchers("/api/v1/autos-infracao/**").hasAuthority("SCOPE_fiscalizacao:write")
                .requestMatchers("/api/v1/cadastros/**").hasAuthority("SCOPE_cadu:read")
                
                // Qualquer outro endpoint exige autenticação por padrão (Zero-Trust)
                .anyRequest().authenticated()
            )
            
            // 5. Ativação do OAuth2 Resource Server com conversor customizado de JWT
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter))
            )
            .build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("https://portal.agr.go.gov.br", "https://teatroabc.go.gov.br"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type", "If-Match", "Accept"));
        configuration.setExposedHeaders(List.of("Location", "ETag"));
        configuration.setAllowCredentials(false);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No ecossistema da **AGR**, o serviço central de identidade **`portalservice` (`:8080`)** operava historicamente em Java 8 com uma classe `WebSecurityConfig` herdando de `WebSecurityConfigurerAdapter`. Dentro dessa classe, métodos gigantescos de 300 linhas misturavam configuração de autenticação LDAP, autenticação de banco de dados e filtros legados de token. Quando a equipe tentava atualizar qualquer dependência do Spring Boot, o serviço falhava na inicialização devido a colisões entre os interceptores do Servlet e as configurações herdadas.

A refatoração moderna do `portalservice` e a implementação do **`agrfiscalservice` (`:8083`)** para o padrão `@Bean SecurityFilterChain` permitiu desmembrar completamente as responsabilidades: o `portalservice` tornou-se um emissor puro de identidade (integrado ao Keycloak e Gov.br), enquanto o `agrfiscalservice` tornou-se um Resource Server leve, sem dependência de classes de infraestrutura compartilhada, subindo em containers Docker em menos de 1,8 segundos graças ao isolamento e à ausência de filtros legados não utilizados.

---

### 1.2 Substituição de antMatchers por requestMatchers & Proteção Contra Bypasses de URL

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma cancela de pedágio eletrônico em que o leitor de placas reconhece a placa oficial de um caminhão de bombeiros (`BOM-1930`) como isenta de tarifa. No entanto, se o motorista afixar uma placa de papelão com uma barra invertida ou caracteres adicionais (`BOM-1930/`), o leitor da cancela confunde-se, não consegue consultar a lista de veículos pagantes e simplesmente levanta a cancela para evitar fila, permitindo a passagem gratuita de qualquer fraudador.

Essa discrepância entre o que o leitor da portaria enxerga e o que o guarda de trânsito na pista seguinte processa é a essência da vulnerabilidade de **Bypass de Autorização por Falha de Matching de URL**. No Spring Framework, existem dois motores que analisam URLs: o **Spring MVC** (que roteia as requisições para os métodos `@GetMapping` dos `@RestController`) e o **Spring Security** (que intercepta a requisição HTTP antes de chegar ao controller). 

No passado, o Spring Security utilizava o método `antMatchers()`, baseado na sintaxe do Apache Ant. O problema residia no fato de que o `antMatchers()` e o Spring MVC utilizavam algoritmos diferentes para normalizar caminhos. Uma rota como `/api/v1/autos-infracao` podia ser interpretada pelo Spring Security como uma rota não mapeada se enviada com uma barra no final (`/api/v1/autos-infracao/`) ou com uma extensão (`/api/v1/autos-infracao.json`), ignorando o bloqueio de segurança. Porém, quando a requisição avançava para o Spring MVC, o controller limpava a barra e executava o método restrito com sucesso.

Para estancar em definitivo essas brechas catastróficas, o Spring Security 6 **aboliu o `antMatchers()` e introduziu o `requestMatchers()`**. O novo método delega nativamente a resolução de padrões para o `MvcRequestMatcher` integrado ao `PathPatternParser` do Spring MVC, garantindo que o filtro de segurança e o despachante de requisições analisem exatamente a mesma árvore semântica de rota, sem qualquer discrepância.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A transição entre o modelo antigo e o novo motor foi formalmente abordada na aula **869_28.6** (*Atualizando o Spring Authorization Server*) do curso *Especialista Spring REST* da AlgaWorks:

> *"Nessa aula aqui vamos realizar as alterações e a atualização do Spring Authorization Server para que ele fique compatível com o Spring Boot 3.0... Aqui no Resource Server, devido a algumas alterações no próprio Spring e no Spring Security, essa configuração aqui vai precisar ser reescrita... Aqui embaixo no RequestMatcher, ele sofreu uma alteração também... Agora vamos passar aqui, antes de tudo, o SecurityMatcher... E aqui na autenticação dos endpoints: authorizeHttpRequests..."* (Linhas 2-21, 39-44).

O desastre real do legado é corporificado na vulnerabilidade **CVE-2023-34035** (Spring Security Authorization Bypass via `antMatchers`):
1. **Discrepância de Trailing Slash (`/`):** Em configurações legadas com `antMatchers("/admin")`, uma requisição maliciosa para `/admin/` burlava o filtro do Spring Security porque a string do padrão Ant não correspondia exatamente à URL com barra. No entanto, o `DispatcherServlet` do Spring MVC realizava o *suffix matching* e entregava a requisição para o controller administrativo, permitindo execução não autenticada de comandos de governo;
2. **Injeção de Prefixos de Contexto:** Caso a aplicação estivesse hospedada sob um caminho base como `/servicos/api`, o `antMatchers` frequentemente exigia que o prefixo do servlet fosse replicado manualmente na regra de segurança (`antMatchers("/servicos/api/relatorios/**")`). Se o servlet context mudasse no `application.yml`, as regras de segurança tornavam-se silenciosamente inoperantes, escancarando os endpoints;
3. **Erros Silenciosos de Configuração:** Desenvolvedores utilizavam expressões com asteriscos duplos (`/**`) acreditando que estavam protegendo todas as variações de um recurso, sem perceber que parâmetros de consulta (*query parameters*) e matrizes de caminho (*path matrices*) podiam alterar a interpretação das regras.

#### Parte 3: A Solução Moderna de Elite
No Spring Security 6.3+, o desenvolvedor utiliza exclusivamente `authorizeHttpRequests()` combinado com `requestMatchers()`. Quando o Spring MVC está presente no classpath, o Spring Security instancia automaticamente um `MvcRequestMatcher.Builder` sincronizado com o manipulador do Spring MVC.

Veja a comparação direta de código entre as abordagens:

```java
// ============================================================================
// 1. CÓDIGO LEGADO VULNERÁVEL (Spring Security 5 / Banido no Spring Boot 3)
// ============================================================================
// http.authorizeRequests()
//     .antMatchers(HttpMethod.POST, "/api/v1/autos-infracao").hasRole("FISCAL")
//     .antMatchers("/api/v1/autos-infracao/**").authenticated()
//     .anyRequest().permitAll();
// Falhas:
// - Requisição para '/api/v1/autos-infracao/' não bate no antMatcher acima!
// - Não compartilha o contexto do PathPatternParser do Spring MVC.

// ============================================================================
// 2. CÓDIGO MODERNO DE ELITE (Spring Security 6.3+ / Zero Vulnerabilidade)
// ============================================================================
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.servlet.util.matcher.MvcRequestMatcher;
import org.springframework.web.servlet.handler.HandlerMappingIntrospector;

@Configuration
public class StrictUrlMatchingSecurityConfig {

    @Bean
    public SecurityFilterChain configureUrlRules(
            HttpSecurity http, 
            HandlerMappingIntrospector introspector) throws Exception {
        
        MvcRequestMatcher.Builder mvcMatcher = new MvcRequestMatcher.Builder(introspector);

        return http
            .authorizeHttpRequests(authorize -> authorize
                // Bloqueio rigoroso alinhado ao Spring MVC Handler
                .requestMatchers(mvcMatcher.pattern(HttpMethod.POST, "/api/v1/autos-infracao")).hasAuthority("SCOPE_fiscalizacao:write")
                .requestMatchers(mvcMatcher.pattern(HttpMethod.PUT, "/api/v1/autos-infracao/*")).hasAuthority("SCOPE_fiscalizacao:write")
                .requestMatchers(mvcMatcher.pattern(HttpMethod.GET, "/api/v1/autos-infracao/**")).hasAuthority("SCOPE_fiscalizacao:read")
                
                // Endpoints de Arrecadação e Guias DARE
                .requestMatchers(mvcMatcher.pattern("/api/v1/dares/**")).hasAuthority("SCOPE_receita:write")
                
                // Tranca obrigatória por padrão (Zero-Trust)
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
            .build();
    }
}
```

Essa abordagem garante que uma rota declarada como `/api/v1/autos-infracao` tratará `/api/v1/autos-infracao/`, `/api/v1/autos-infracao?filtro=true` e qualquer variante exatamente da mesma forma tanto no filtro de segurança quanto no método do `@RestController`.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No subsistema de arrecadação da AGR, o microsserviço **`receitaservice` (`:8092`)** possui endpoints críticos responsáveis por emitir guias DARE e conceder parcelamento de multas fiscais (`/api/v1/dares/parcelamentos`). Durante uma auditoria interna de conformidade de segurança, identificou-se que o código legado utilizava `antMatchers("/api/v1/dares/parcelamentos")`. 

Um usuário externo com credenciais de fretador básico descobriu que ao efetuar uma requisição `POST` para `/api/v1/dares/parcelamentos/` (com barra final), o Spring Security legado não disparava a regra de checagem do perfil de Auditor Fiscal, e o Spring MVC executava o método de parcelamento sem aplicar a autorização necessária. 

Com a migração para o Spring Security 6 e a substituição por `requestMatchers()`, a brecha foi 100% mitigada. Qualquer tentativa de variação de URI agora bate no mesmo nó do `PathPatternParser`, bloqueando instantaneamente requisições sem as devidas permissões corporativas.

---

### 1.3 Sessões HTTP Stateless vs Stateful & Desativação Consciente do CSRF

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que você faça uma reserva em uma grande rede de hotéis com filiais em Goiânia, Rio Verde e Anápolis:
- **No Modelo Stateful:** Ao chegar na recepção do hotel em Goiânia, o recepcionista anota seu nome e dados em um caderno de papel mantido trancado na gaveta do balcão local e lhe entrega uma ficha de papel com o número do quarto (`JSESSIONID`). Se você precisar fazer checkout ou solicitar serviço na filial de Anápolis, o recepcionista de Anápolis não terá acesso ao caderno de Goiânia. Para que funcione, o hotel precisaria contratar mensageiros de motocicleta para copiar o caderno em tempo real para todas as cidades (**Replicação de Sessão HTTP**). Se o mensageiro atrasar ou o caderno queimar em um incêndio (**Crash do Servidor**), sua reserva desaparece e você é expulso do hotel;
- **No Modelo Stateless:** O hotel emite para você um cartão inteligente de policarbonato com chip criptográfico contendo seu nome, nível de fidelidade e data de expiração, assinado digitalmente pela matriz da rede hoteleira (**Token JWT**). Em qualquer filial que você comparecer, a fechadura eletrônica da porta lê o chip, valida a assinatura criptográfica em menos de 10 milissegundos e autoriza sua entrada. O hotel não precisa manter cadernos em gavetas, não precisa de mensageiros e pode abrir 50 novas filiais sem que nenhuma precise sincronizar memória com as demais.

Essa é a distinção fundamental entre segurança baseada em estado no servidor (**Stateful Authentication**) e segurança puramente sem estado (**Stateless Authentication**).

Adicionalmente, compreender a mecânica do **CSRF (Cross-Site Request Forgery)** é mandatório para um engenheiro de elite. O ataque CSRF só é fisicamente possível quando o navegador do usuário armazena credenciais em **Cookies** e os envia automaticamente em requisições de origens cruzadas. Em uma arquitetura verdadeiramente Stateless onde a autenticação reside no cabeçalho HTTP `Authorization: Bearer <JWT>`, o navegador **nunca anexa o token de forma implícita ou automática**. Portanto, desabilitar o CSRF em APIs stateless não é um atalho perigoso de desenvolvimento, mas uma decisão arquitetural consciente e matematicamente respaldada pela física do protocolo HTTP.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A fundamentação teórica de por que REST deve ser Stateless e o impacto destrutivo de armazenar estado no servidor são expostos com clareza cristalina na aula **732_23_3** (*Entendendo a diferença entre Stateful e Stateless Authentication*) do curso *Especialista Spring REST* da AlgaWorks:

> *"Na dissertação do Roy Fielding, ele diz que uma das constraintes para ser considerado REST é que a comunicação tem que ser Stateless... Ele escreveu assim: a comunicação deve ser Stateless, ou seja, sem estado, por natureza, de forma que cada requisição do cliente para o servidor deve conter as informações necessárias para entendê-la e não pode usar informações contextuais armazenadas no servidor. O estado da sessão deve ser armazenado inteiramente no cliente... Vamos separar entre Application State e Resource State. O que Roy diz que deve ser Stateless é o estado da aplicação..."* (Linhas 5-30).

A violação dessa diretriz no legado gerou catástrofes históricas:
1. **O Esgotamento do Java Heap Space por Sessões Fantasmas:** Aplicações configuradas com `SessionCreationPolicy.IF_REQUIRED` criavam um objeto `HttpSession` para cada requisição recebida, mesmo para clientes de API ou chamadas AJAX rápidas. Sob ataques de scraping ou picos de consulta, milhares de sessões vazias eram alocadas no Heap da JVM, disparando pausas destrutivas de Garbage Collection (*Stop-The-World*) e travando os servidores Tomcat;
2. **A Dependência Destrutiva de Sticky Sessions:** Para contornar a perda de sessão em ambientes com múltiplos nós, administradores configuravam o balanceador de carga (NGINX ou HAProxy) para fixar o cliente no mesmo nó (*Sticky Session*). Isso destruía a resiliência do sistema: se um container Docker precisasse ser reiniciado para aplicação de patch de segurança, todos os usuários conectados àquele container tinham suas sessões deslogadas abruptamente, perdendo autos de infração e cadastros em andamento;
3. **A Confusão Generalizada sobre CSRF:** Equipes corporativas mantinham o filtro de CSRF ativado em APIs REST sem entender o propósito. Como os clientes móveis e frontends Angular não enviavam o token CSRF em cookies sincronizados, as requisições `POST` e `PUT` falhavam silenciosamente com código `HTTP 403 Forbidden`. A resposta comum dos desenvolvedores inexperientes era ativar sessões com cookies para fazer o CSRF funcionar, destruindo o paradigma stateless da API.

#### Parte 3: A Solução Moderna de Elite
No ecossistema Spring Boot 3.3+, a garantia de que o servidor não criará nem utilizará sessões HTTP sob nenhuma hipótese é estabelecida configurando expressamente o `SessionCreationPolicy.STATELESS`. Com essa política ativada, a cadeia de segurança do Spring Security não consulta o `HttpSession` e instancia um `SecurityContextHolder` novo e efêmero a cada requisição, descartando-o imediatamente ao término do processamento.

Abaixo está o trecho de configuração de alta precisão que isola a gestão de sessão e o desligamento consciente do CSRF:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.context.NullSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;

@Configuration
public class StatelessSessionSecurityConfig {

    @Bean
    public SecurityFilterChain configureStatelessPipeline(HttpSecurity http) throws Exception {
        return http
            // Desativação cirúrgica do CSRF: a API aceita apenas Authorization: Bearer <token>
            .csrf(AbstractHttpConfigurer::disable)
            
            // Política sem estado inegociável
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            
            // Impede que o Spring Security grave o SecurityContext na sessão HTTP do Tomcat
            .securityContext(context -> context
                .securityContextRepository(statelessSecurityContextRepository())
            )
            
            .authorizeHttpRequests(authorize -> authorize
                .anyRequest().authenticated()
            )
            .build();
    }

    @Bean
    public SecurityContextRepository statelessSecurityContextRepository() {
        // Implementação nula: garante zero alocação de estado no Servlet Container
        return new NullSecurityContextRepository();
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No cenário real de fiscalização de rodovias em Goiás, o microsserviço **`agrfiscalservice` (`:8083`)** recebe conexões simultâneas de centenas de tablets de fiscais de campo realizando blitz de transporte clandestino nas rodovias GO-020, GO-070 e GO-080. Durante feriados prolongados e operações especiais, a infraestrutura da AGR precisa escalar dinamicamente o `agrfiscalservice` de 2 para 10 réplicas em um cluster Kubernetes.

Graças à adoção estrita de `SessionCreationPolicy.STATELESS`, o balanceador de carga distribui as requisições de forma puramente round-robin. Um fiscal pode enviar a foto de uma placa de ônibus na requisição 1 para a Réplica A e, 500 milissegundos depois, enviar os dados do auto de infração na requisição 2 para a Réplica B. Como cada requisição carrega seu próprio token JWT autenticado criptograficamente, não há perda de contexto, não há dependência de sticky sessions e o consumo de memória de cada container permanece estável em torno de 250 MB de RAM.

---

## 2. OAuth2 Stateless & JWT Token Architecture

### 2.1 Separação Estrita de Papéis: Resource Server vs Authorization Server

#### Parte 1: O que é o conceito / Analogia Didática
Pense na estrutura monetária de um país soberano:
- **A Casa da Moeda / Banco Central (Authorization Server):** É a autoridade máxima de emissão de valor. Ela possui equipamentos de alta segurança, cofres blindados e as matrizes secretas de gravação de papel-moeda. É o único órgão autorizado a emitir cédulas de 100 reais com marca d'água e fibras luminescentes;
- **O Comerciante ou Fiscal na Rua (Resource Server):** É o estabelecimento que vende o produto ou o fiscal que valida o pagamento. O comerciante **não imprime dinheiro e não guarda matrizes de impressão**. Para aceitar a cédula de 100 reais, ele simplesmente utiliza uma pequena lâmpada de luz ultravioleta para verificar se a marca d'água e os selos de segurança emitidos pelo Banco Central são autênticos.

Misturar os dois papéis no mesmo sistema seria o equivalente a instalar uma prensa de dinheiro e matrizes secretas de impressão no caixa de cada padaria, farmácia e guichê de rodoviária do estado. Se uma única padaria fosse assaltada, os criminosos roubariam as matrizes de impressão e poderiam emitir dinheiro oficial falso para inundar a economia inteira.

Em arquiteturas distribuídas modernas, o **Authorization Server** é o serviço centralizado responsável por gerenciar credenciais de usuários, autenticar identidades (usuário/senha, MFA, biometria, Gov.br), gerenciar consentimentos e emitir tokens criptograficamente assinados. Já o **Resource Server** é o microsserviço de negócio (como o sistema de fiscalização ou bilhetagem) cuja única responsabilidade é receber requisições HTTP, validar o token de acesso recebido no cabeçalho `Authorization: Bearer <JWT>` e entregar ou negar os recursos solicitados.

A topologia entre esses papéis é delineada no diagrama abaixo:

```
TOPOLOGIA OAUTH 2.1: AUTHORIZATION SERVER (JWKS) vs RESOURCE SERVERS SATÉLITES

 ┌──────────────────────────────────────┐       ┌───────────────────────────────────────┐
 │     AUTHORIZATION SERVER (KEYCLOAK)  │       │       RESOURCE SERVER (SPRING 6)      │
 │          portalservice :8080         │       │          agrfiscalservice :8083       │
 ├──────────────────────────────────────┤       ├───────────────────────────────────────┤
 │ • Gera Par de Chaves RSA (2048 bits) │       │ • NÃO possui a Chave Privada!         │
 │ • Chave Privada: Mantida em segredo  │       │ • Possui apenas a Chave Pública       │
 │ • Assina Tokens JWT (Algoritmo RS256)│       │ • Consulta /.well-known/jwks.json     │
 │ • Expõe JWKS em:                     │       │ • Valida assinatura em memória        │
 │   GET /oauth2/jwks                   │◄──────┼── Sem bater no banco de dados!        │
 │   (Retorna { keys: [ { kid, n, e } ]})       │ • Verifica iss, exp, aud, roles       │
 └──────────────────┬───────────────────┘       └───────────────────▲───────────────────┘
                    │                                               │
                    │ Emite JWT Assinado                            │ Envia Requisição com
                    │ com Claims e Permissões                       │ Bearer Token
                    ▼                                               │
         ┌──────────────────────────────────────────────────────────┴┐
         │            CLIENTE (ANGULAR SPA / MOBILE APP)             │
         │               Armazena Access Token em Memória            │
         └───────────────────────────────────────────────────────────┘
```

#### Parte 2: A Dor Histórica / O Desastre do Legado
A evolução conturbada dos papéis OAuth2 no ecossistema Spring foi documentada de forma emblemática na aula histórica **708_22_6** (*Soluções para OAuth2 nova stack do Spring Security vs Spring*) do curso *Especialista Spring REST* da AlgaWorks:

> *"Até a pouco tempo atrás a opção que a gente tinha quando a gente desenvolveu uma API com Spring para usar o OAuth era o Spring Security OAuth. Então o Spring Security OAuth ele dá suporte tanto para implementar o Resource Server como para implementar o Authorization Server. Porém, começou um movimento dos desenvolvedores do Spring para portar o código... A ideia deles é depreciar, é matar um dia esse projeto Spring Security OAuth... Aí quando eles lançaram a versão 5.2 do Spring Security... Eles informaram que agora o Spring Security já portou todas as funcionalidades essenciais do Resource Server, então não precisa mais usar o Spring Security OAuth... Só que eles informaram que não vai ter mais suporte a Authorization Server no Spring Security... Como que a comunidade ficou? Ela ficou assim: beleza, se eu não vou ter o suporte ao Authorization Server, vou ter que usar um Authorization Server de um terceiro... Mas a comunidade reclamou, não gostou disso... Depois de tanta gente dando feedback negativo para eles, eles adicionaram um update... Devido a esse feedback e algumas discussões internas, nós vamos dar uma olhada novamente nessa decisão..."* (Linhas 13-52).

A confusão desses papéis no legado causou desastres profundos:
1. **O Monolito de Autenticação Replicado:** Desenvolvedores incluíam a dependência legada `spring-security-oauth2` em cada um dos seus microsserviços. Cada microsserviço acabava implementando tabelas de usuários, encoders de senha (`BCryptPasswordEncoder`) e endpoints de autenticação próprios, fragmentando a base de dados de servidores públicos e criando ilhas de permissão não sincronizadas;
2. **Carga Massiva no Banco de Dados Central:** Em sistemas onde o Resource Server precisava checar a validade de tokens opacos fazendo consultas HTTP reversas (*Token Introspection*) a cada requisição recebida, o Authorization Server tornava-se o maior gargalo da infraestrutura, sofrendo indisponibilidade e derrubando toda a malha de serviços;
3. **Complexidade Impossível de Manutenção:** Ao misturar a lógica de emissão de tokens com a lógica de negócio regulatório, qualquer atualização de segurança ou ajuste na política de senhas forçava a recompilação e o redesdobramento de dezenas de microsserviços independentes.

#### Parte 3: A Solução Moderna de Elite
A arquitetura moderna de elite estabelece uma segregação irrevogável:
1. **Authorization Server Dedicado:** Implementado via **Keycloak** corporativo ou instâncias do moderno **Spring Authorization Server 1.3+**, posicionado atrás do portal de identidade unificado;
2. **Resource Server Puro:** Implementado com a biblioteca padrão `spring-boot-starter-oauth2-resource-server`. O microsserviço satélite não conhece senhas de usuários, não acessa tabelas de autenticação e valida tokens puramente em memória através da chave pública obtida via JWKS.

Veja como o `application.yml` de um Resource Server de elite é simples, limpo e desacoplado:

```yaml
spring:
  application:
    name: agrfiscalservice
  security:
    oauth2:
      resourceserver:
        jwt:
          # URI do conjunto de chaves públicas expostas pelo Authorization Server
          jwk-set-uri: https://identidade.agr.go.gov.br/oauth2/jwks
          # Validação estrita do emissor oficial do token
          issuer-uri: https://identidade.agr.go.gov.br
```

Com apenas essas duas propriedades e a cadeia do `SecurityFilterChain`, o Spring Security 6 configura automaticamente todo o pipeline de decodificação criptográfica, cache de chaves públicas e validação de assinaturas sem escrever uma única linha de código proprietário de integração.

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No desenho arquitetural do **AGR-Docs**, o **`portalservice` (`:8080`)** atua como o ponto focal de identidade, conectando-se ao LDAP estadual e ao provedor Gov.br (via protocolo OpenID Connect / OIDC). É ele que emite os tokens de acesso para os auditores e cidadãos.

Por sua vez, os microsserviços regulatórios satélites — **`agrfiscalservice` (`:8083`)**, **`cadastrounicoservice` (`:8081`)** e **`receitaservice` (`:8092`)** — atuam puramente como Resource Servers. Quando um fiscal lavra um auto de infração em Goiânia ou autoriza uma viagem de turismo em Caldas Novas, o `agrfiscalservice` apenas consulta o cache local de chaves públicas providas por `:8080`, valida o token em menos de 1 milissegundo e executa o comando de negócio com zero acoplamento ao banco de dados de usuários.

---

### 2.2 Assinatura Criptográfica Assimétrica (RSA/JWKS) vs A Vulnerabilidade Simétrica da AGR

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o sistema de reconhecimento de firma em um cartório tradicional:
- **Criptografia Simétrica (Segredo Compartilhado):** É como se o tabelião e todos os cidadãos da cidade combinassem uma única palavra-passe secreta para validar escrituras de imóveis. Se o tabelião, o corretor, o comprador e o office boy souberem a senha secreta, qualquer um deles pode produzir uma escritura falsa em sua própria casa. Basta que um único office boy perca o papel com a senha na rua para que qualquer cidadão possa forjar compras e vendas de fazendas em nome do estado;
- **Criptografia Assimétrica (Chave Privada + Chave Pública):** É como se o tabelião fosse a única pessoa no mundo detentora de um carimbo de alto relevo em aço inoxidável lapidado com micropadrões tridimensionais impossíveis de clonar (**Chave Privada**). Qualquer pessoa na cidade pode adquirir uma lupa de ampliação óptica padrão vendida em qualquer papelaria (**Chave Pública**) para verificar se o relevo no papel é genuíno. Mesmo que a cidade inteira tenha lupas, **ninguém com uma lupa consegue estampar um novo documento falso**, pois a matriz de alto relevo permanece guardada sob sete chaves no cofre do cartório.

No ecossistema de tokens JWT:
- **Algoritmos Simétricos (ex: HMAC-SHA256 / `HS256`):** Utilizam a mesmíssima chave secreta tanto para assinar o token quanto para validar sua assinatura;
- **Algoritmos Assimétricos (ex: RSA-SHA256 / `RS256`):** Utilizam um par de chaves matematicamente correlacionadas. A **Chave Privada** é mantida em segredo absoluto pelo Authorization Server para assinar os tokens emitidos. A **Chave Pública** é disponibilizada publicamente para todos os Resource Servers através de um endpoint padronizado chamado **JWKS (JSON Web Key Set)**, localizado convencionalmente em `/.well-known/jwks.json`.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A necessidade da criptografia assimétrica e a distinção entre chave pública e privada foram destacadas nas aulas **736_23.9** (*Assinando o JWT com RSA SHA-256*) e **738_23.11** (*Extraindo a chave pública no formato PEM*) da AlgaWorks:

> *"Para assinar um JWT, a gente assina usando a chave privada... Para validar o token JWT, a validação é feita com a chave pública... Se todos os desenvolvedores estão usando esse arquivo JKS para assinar seus tokens em tempo de desenvolvimento, quando você for para produção é legal que você gere um outro par de chaves para não correr risco... Um certificado contém a chave pública... A chave pública é a chave criptográfica que precisamos para validar a assinatura do JWT..."* (736: Linhas 10-23; 738: Linhas 7-19).

O desastre real do legado corporativo é exemplificado na história verídica da infraestrutura da **AGR**:
1. **O Segredo Simétrico Hardcoded:** No código legado dos microsserviços da AGR, a validação de JWT utilizava o algoritmo simétrico HS512. Em dezenas de arquivos `application.properties` espalhados pelos repositórios Git de diferentes setores, encontrava-se a propriedade explícita:
   ```properties
   # VULNERABILIDADE CRÍTICA REAL ENCONTRADA NO LEGADO AGR
   jwt.secret=sw!tch14
   ```
2. **A Quebra Completa da Confiança Institucional:** Como a chave simétrica `sw!tch14` estava presente no código-fonte de microsserviços secundários mantidos por estagiários e empresas terceirizadas, qualquer desenvolvedor ou invasor que tivesse acesso a um único repositório satélite conseguia forjar tokens JWT em seu próprio computador com privilégios de `ROLE_ADMIN` e `ROLE_AUDITOR_FISCAL`. Esse token forjado era aceito cegamente por todos os outros 24 microsserviços da agência, permitindo o cancelamento de autos de infração e alteração fraudulenta de cadastros de frotas;
3. **Impossibilidade de Rotação de Chaves:** Como a chave simétrica estava embutida estaticamente em dezenas de aplicações, rotacionar a senha exigia coordenar o redesdobramento simultâneo de todos os 25 microsserviços. Se um serviço atrasasse o deploy, passava a rejeitar tokens dos usuários, paralisando a arrecadação do estado.

#### Parte 3: A Solução Moderna de Elite
A solução de elite para proteger ecossistemas distribuídos adota **Chaves Assimétricas RSA de 2048 ou 4096 bits com JWKS dinâmico**. O Resource Server nunca conhece nem armazena a chave privada. Ele consulta periodicamente o endpoint de JWKS do Authorization Server, que retorna a chave pública formatada em JSON com um identificador de chave (`kid` - Key ID).

Abaixo está a configuração completa de um `NimbusJwtDecoder` com suporte a chaves públicas assimétricas via JWKS e validadores estritos de cadeia:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;

import java.util.List;

@Configuration
public class AsymmetricJwtDecoderConfig {

    @Value("${spring.security.oauth2.resourceserver.jwt.jwk-set-uri}")
    private String jwkSetUri;

    @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}")
    private String expectedIssuer;

    @Value("${agr.security.jwt.expected-audience:agr-fiscal-api}")
    private String expectedAudience;

    @Bean
    public JwtDecoder jwtDecoder() {
        // 1. Instancia o NimbusJwtDecoder apontando para o JWK Set URI oficial
        NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder.withJwkSetUri(this.jwkSetUri).build();

        // 2. Validador padrão do Spring Security (valida timestamps de expiração e emissor)
        OAuth2TokenValidator<Jwt> defaultValidator = JwtValidators.createDefaultWithIssuer(this.expectedIssuer);

        // 3. Validador customizado de Audience ('aud') para impedir uso de tokens de outros clientes
        OAuth2TokenValidator<Jwt> audienceValidator = new JwtAudienceValidator(this.expectedAudience);

        // 4. Delegação encadeada de validadores
        OAuth2TokenValidator<Jwt> delegatingValidator = new DelegatingOAuth2TokenValidator<>(
            List.of(defaultValidator, audienceValidator)
        );

        jwtDecoder.setJwtValidator(delegatingValidator);
        return jwtDecoder;
    }
}
```

E a estrutura JSON canônica retornada pelo endpoint `/.well-known/jwks.json` no Authorization Server, permitindo rotação transparente de chaves com base no `kid`:

```json
{
  "keys": [
    {
      "kty": "RSA",
      "e": "AQAB",
      "use": "sig",
      "kid": "agr-key-2026-v1",
      "alg": "RS256",
      "n": "u1P8Z1xG0wPqO3k7wV...[módulo público da chave RSA de 2048 bits]...x9Q=="
    }
  ]
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
Com a erradicação do segredo simétrico `sw!tch14` e a introdução da infraestrutura de chaves públicas assimétricas nos 25 microsserviços da AGR, alcançou-se o estado de **Zero-Trust**:
- Mesmo que o código-fonte de serviços satélites como o **`gratuidadeservice` (`:4207`)** seja exposto, ele contém apenas o endereço público do JWKS (`https://identidade.agr.go.gov.br/oauth2/jwks`);
- Nenhum invasor consegue assinar tokens válidos sem invadir o cofre digital blindado do Keycloak/Authorization Server;
- Quando o setor de segurança da informação da AGR necessita rotacionar as chaves anualmente, o Keycloak publica um novo `kid` no JWKS. Os Resource Servers recarregam a nova chave pública automaticamente sob demanda, com zero tempo de inatividade (*Zero Downtime*).

---

### 2.3 Decodificação e Validação Estrita de Claims JWT (iss, exp, aud, nbf, jti)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine o passaporte internacional emitido pelo Departamento de Polícia Federal:
- **`iss` (Issuer - Emissor):** Indica quem emitiu o documento ("República Federativa do Brasil"). Um passaporte emitido por uma empresa de turismo privada não tem valor jurídico;
- **`exp` (Expiration Time - Expiração):** A data limite de validade. Um passaporte vencido há 1 minuto é retido imediatamente na imigração;
- **`aud` (Audience - Destinatário / Audiência):** A quem o documento se destina. Se um visto diplomático foi emitido exclusivamente para entrada na França, as autoridades alfandegárias do Japão devem recusá-lo;
- **`nbf` (Not Before - Não Válido Antes De):** O documento não pode ser aceito antes de determinada data de início de vigência;
- **`jti` (JWT ID - Identificador Único do Token):** O número de série perfurado a laser em cada página do passaporte. Se dois passageiros tentarem embarcar em portões diferentes apresentando passaportes com o mesmíssimo número de série, a segurança do aeroporto sabe imediatamente que houve uma cópia fraudulenta (**Ataque de Replay**).

No padrão **RFC 7519 (JSON Web Token)**, essas claims registradas são atributos estruturados presentes no corpo do token (*Payload*). A simples validação da assinatura criptográfica do token não é suficiente: o Resource Server é obrigado a inspecionar semanticamente o conteúdo das claims para garantir que o token não expirou, foi emitido pelo servidor correto e foi endereçado especificamente para a API receptora.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A fragilidade de serialização e a manipulação manual e falha de claims foram ressaltadas na aula **869_28.6** (*Atualizando o Spring Authorization Server*) da AlgaWorks:

> *"Nessa classe aqui temos um problema de serialização na hora de buscar o usuário ID do nosso token... Long.valueOf(usuarioId.toString()) porque na mais recente versão do JWT está tudo sendo serializado como String e não mais como um Long..."* (Linhas 66-77).

Dentre os desastres históricos provocados pela negligência na checagem de claims, destacam-se:
1. **O Token Eterno sem Expiração (`exp` ausente):** Desenvolvedores inexperientes emitiam tokens sem claim de expiração para "evitar que o usuário precisasse fazer login de novo". Quando um funcionário era demitido ou um dispositivo corporativo era furtado, o token continuava válido para sempre, possibilitando acessos não autorizados durante meses;
2. **Confusão de Audiência (`aud` ignorado):** Um token emitido para o aplicativo móvel público do cidadão consultar horários de ônibus era aceito sem ressalvas pelos endpoints administrativos da fiscalização, pois ambos validavam apenas se a assinatura vinha do mesmo emissor, sem verificar para quem o token havia sido concedido;
3. **Vulnerabilidade a Ataques de Replay:** A ausência de controle do identificador único `jti` permitia que atacantes capturassem uma requisição legítima na rede e a reenviassem dezenas de vezes, duplicando emissões de multas ou reservas financeiras.

#### Parte 3: A Solução Moderna de Elite
A solução de elite implementa validadores customizados do Spring Security vinculados à interface `OAuth2TokenValidator<Jwt>`, rejeitando tokens que não atendam estritamente aos contratos corporativos.

Abaixo está o validador de audiência e unicidade de token de nível de produção:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;

import java.time.Instant;
import java.util.List;

public class JwtAudienceValidator implements OAuth2TokenValidator<Jwt> {

    private final String requiredAudience;

    public JwtAudienceValidator(String requiredAudience) {
        this.requiredAudience = requiredAudience;
    }

    @Override
    public OAuth2TokenValidatorResult validate(Jwt jwt) {
        List<String> audiences = jwt.getAudience();

        // 1. Validação mandatória de Audience ('aud')
        if (audiences == null || !audiences.contains(this.requiredAudience)) {
            OAuth2Error error = new OAuth2Error(
                "invalid_token",
                "O token apresentado não foi endereçado à audiência necessária: " + this.requiredAudience,
                "https://api.agr.go.gov.br/erros/token-invalido"
            );
            return OAuth2TokenValidatorResult.failure(error);
        }

        // 2. Validação estrita de Expiração ('exp')
        Instant expiresAt = jwt.getExpiresAt();
        if (expiresAt == null || expiresAt.isBefore(Instant.now())) {
            OAuth2Error error = new OAuth2Error(
                "token_expired",
                "O token de acesso apresentado encontra-se expirado.",
                "https://api.agr.go.gov.br/erros/token-expirado"
            );
            return OAuth2TokenValidatorResult.failure(error);
        }

        // 3. Validação de emissor não-nulo
        if (jwt.getIssuer() == null || jwt.getIssuer().toString().isBlank()) {
            OAuth2Error error = new OAuth2Error(
                "invalid_issuer",
                "O emissor do token ('iss') é obrigatório e não foi informado.",
                "https://api.agr.go.gov.br/erros/emissor-invalido"
            );
            return OAuth2TokenValidatorResult.failure(error);
        }

        return OAuth2TokenValidatorResult.success();
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
Na plataforma de bilhetagem do **Teatro-ABC (`:8090`)**, cada ingresso eletrônico comprado gera um QR Code contendo um token JWT compacto com assinatura assimétrica. O token possui duas claims vitais:
- `aud: "teatro-abc-catraca"`: Garante que o ingresso é válido especificamente para os leitores de catraca do teatro, e não para outros eventos parceiros;
- `jti: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d"`: O identificador único e universal do ingresso.

No momento em que o espectador aproxima o QR Code da catraca eletrônica na entrada do auditório, a aplicação do leitor óptico decodifica o JWT, valida a assinatura e consulta uma estrutura atômica em memória distribuída (Redis com TTL). Se o `jti` nunca foi visto, ele é registrado instantaneamente e a catraca libera a passagem. Caso uma pessoa tente reutilizar a fotocópia do mesmo QR Code 5 segundos depois, o validador detecta a colisão do `jti` e bloqueia o acesso imediatamente, impedindo fraudes de bilhetagem com latência de resposta inferior a 8 milissegundos.

---

## 3. RBAC & Granular Method Security

### 3.1 Mapeamento de Claims Customizadas com JwtAuthenticationConverter

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um passaporte oficial emitido pela Organização das Nações Unidas (ONU) para um diplomata brasileiro. O passaporte possui um carimbo internacional padrão que diz *"Diplomat"*. No entanto, ao desembarcar no aeroporto de Brasília para conduzir uma missão oficial, as autoridades brasileiras precisam saber detalhes operacionais que não interessam a outros países: qual é a matrícula funcional do servidor, em qual ministério ele é lotado e qual é o número da portaria ministerial que o designou para a operação.

O **`JwtAuthenticationConverter`** é o intérprete consular que atua na fronteira da aplicação. Ele recebe o token JWT genérico da internet e converte seus atributos abstratos em condecorações militares e títulos oficiais compreendidos pela legislação local do sistema. No Spring Security, isso significa transformar campos JSON do payload (como `roles`, `scope`, `permissoes`, `cpf` e `orgao_id`) em objetos concretos `GrantedAuthority` dentro do `SecurityContextHolder`, viabilizando o uso de regras `@PreAuthorize`.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A fragilidade de extrair dados e mapear permissões de tokens JWT de forma manual foi detalhada na aula **869_28.6** (*Atualizando o Spring Authorization Server*) da AlgaWorks:

> *"Nessa aula aqui vamos realizar as alterações e a atualização do Spring Authorization Server para que ele fique compatível com o Spring Boot 3.0... Aqui no Resource Server, devido a algumas alterações no próprio Spring e no Spring Security, essa configuração aqui vai precisar ser reescrita... Nessa classe aqui temos um problema de serialização na hora de buscar o usuário ID do nosso token... Long.valueOf(usuarioId.toString()) porque na mais recente versão do JWT está tudo sendo serializado como String e não mais como um Long..."* (Linhas 2-21, 66-77).

No legado governamental da AGR e em projetos tradicionais, o mapeamento incorreto gerava falhas críticas:
1. **O Prefixo Fantasma `SCOPE_` vs `ROLE_`:** Por padrão, o conversor nativo do Spring Security (`JwtGrantedAuthoritiesConverter`) lê apenas a claim `scope` ou `scp` e prefixa cada autoridade com `SCOPE_`. Como resultado, um usuário que recebia uma role corporativa `"ADMIN"` tinha essa permissão ignorada se a anotação do controller checasse `hasRole("ADMIN")`, pois o Spring Security espera que `hasRole` procure por `ROLE_ADMIN`;
2. **Perda de Dados Corporativos Críticos:** Controllers precisavam saber o CPF ou a lotação do auditor para gravar o histórico do auto de infração. Desenvolvedores legados realizavam o parsing manual da String do token em pleno controller utilizando bibliotecas de JSON, quebrando o princípio da responsabilidade única e degradando o desempenho;
3. **Casting de Tipos Não Seguro:** Tentativas de extrair claims numéricas (como IDs de banco) geravam `ClassCastException` quando o provedor de identidade serializava os valores como Strings ou arrays heterogêneos.

#### Parte 3: A Solução Moderna de Elite
A solução de engenharia de elite consiste em implementar um `Converter<Jwt, AbstractAuthenticationToken>` customizado e altamente performático. Esse conversor extrai concorrentemente os escopos de delegação OAuth2, os papéis de negócio com prefixo `ROLE_` e as permissões atômicas de negócio, encapsulando tudo em uma instância imutável de `JwtAuthenticationToken`.

Abaixo está a implementação canônica completa:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
public class CustomJwtAuthenticationConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private static final String CLAIM_AUTHORITIES = "authorities";
    private static final String CLAIM_PERMISSOES = "permissoes";
    private static final String CLAIM_ROLES = "roles";
    private static final String CLAIM_SCOPE = "scope";
    private static final String CLAIM_SCP = "scp";

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        Collection<GrantedAuthority> authorities = extractAuthorities(jwt);
        String principalClaimName = jwt.getClaimAsString("sub");
        return new JwtAuthenticationToken(jwt, authorities, principalClaimName);
    }

    private Collection<GrantedAuthority> extractAuthorities(Jwt jwt) {
        Set<GrantedAuthority> grantedAuthorities = new HashSet<>();

        // 1. Extração de Scopes OAuth2 padrão (prefixados obrigatoriamente com SCOPE_)
        extractScopes(jwt, grantedAuthorities);

        // 2. Extração de Roles de Negócio (prefixadas com ROLE_)
        extractRoles(jwt, grantedAuthorities);

        // 3. Extração de Permissões Corporativas Granulares (ex: FISCALIZACAO_LAVRAR_AUTO)
        extractCustomPermissions(jwt, grantedAuthorities);

        return Collections.unmodifiableSet(grantedAuthorities);
    }

    private void extractScopes(Jwt jwt, Set<GrantedAuthority> authorities) {
        Object scopeClaim = jwt.getClaims().get(CLAIM_SCOPE);
        if (scopeClaim == null) {
            scopeClaim = jwt.getClaims().get(CLAIM_SCP);
        }

        if (scopeClaim instanceof String scopeString) {
            for (String scope : scopeString.split(" ")) {
                if (!scope.isBlank()) {
                    authorities.add(new SimpleGrantedAuthority("SCOPE_" + scope));
                }
            }
        } else if (scopeClaim instanceof Collection<?> scopeList) {
            for (Object scope : scopeList) {
                if (scope != null && !scope.toString().isBlank()) {
                    authorities.add(new SimpleGrantedAuthority("SCOPE_" + scope.toString()));
                }
            }
        }
    }

    private void extractRoles(Jwt jwt, Set<GrantedAuthority> authorities) {
        List<String> roles = jwt.getClaimAsStringList(CLAIM_ROLES);
        if (roles != null) {
            for (String role : roles) {
                if (!role.isBlank()) {
                    String roleName = role.startsWith("ROLE_") ? role : "ROLE_" + role;
                    authorities.add(new SimpleGrantedAuthority(roleName));
                }
            }
        }
    }

    private void extractCustomPermissions(Jwt jwt, Set<GrantedAuthority> authorities) {
        List<String> permissoes = jwt.getClaimAsStringList(CLAIM_PERMISSOES);
        if (permissoes == null) {
            permissoes = jwt.getClaimAsStringList(CLAIM_AUTHORITIES);
        }

        if (permissoes != null) {
            for (String permissao : permissoes) {
                if (!permissao.isBlank()) {
                    authorities.add(new SimpleGrantedAuthority(permissao));
                }
            }
        }
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No fluxo operacional do **`agrfiscalservice` (`:8083`)**, o Keycloak central emite um token JWT contendo a seguinte estrutura de claims reais:

```json
{
  "sub": "01234567199",
  "name": "Wheslan Cardoso",
  "orgao_id": 14,
  "matricula": "AGR-2026-99",
  "scope": "fiscalizacao:write fiscalizacao:read",
  "roles": ["FISCAL", "ADMIN_REGIONAL"],
  "permissoes": [
    "FISCALIZACAO_LAVRAR_AUTO",
    "FISCALIZACAO_APREENDER_VEICULO",
    "CADU_CONSULTAR_FROTA"
  ]
}
```

Graças ao `CustomJwtAuthenticationConverter`, o Spring Security injeta instantaneamente no contexto de segurança tanto as autoridades delegadas (`SCOPE_fiscalizacao:write`), quanto os perfis (`ROLE_FISCAL`) e as ações cirúrgicas (`FISCALIZACAO_LAVRAR_AUTO`). Quando o método do controller é executado, a auditoria governamental sabe com precisão atômica quem está executando a ação, qual é sua matrícula e se ele possui permissão formal para lavrar o auto de apreensão.

---

### 3.2 Distinção Semântica: SCOPE_ (OAuth2 Delegation) vs ROLE_ (Perfis de Negócio)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que você contrate um escritório de contabilidade para calcular e pagar seus impostos:
- **`ROLE_` (Seu Papel Civil de Negócio):** Você é um cidadão proprietário de uma empresa de transporte intermunicipal (**`ROLE_EMPRESARIO_TRANSPORTE`**). Você tem direito legal de assinar balanços, solicitar linhas de ônibus e receber dividendos;
- **`SCOPE_` (A Procuração de Delegação concedida ao Aplicativo):** Você instala o aplicativo do escritório de contabilidade e concede a ele uma procuração específica para consultar suas guias fiscais e emitir certidões negativas (**`SCOPE_impostos:read`**). Você **NUNCA** concedeu ao aplicativo autorização para vender os ônibus da sua empresa ou demitir seus motoristas.

Se a repartição pública aceitasse que o aplicativo fizesse qualquer coisa apenas porque você é o dono da empresa, o aplicativo de contabilidade poderia vender todos os seus veículos sem o seu consentimento.

Essa é a distinção mais crítica e frequentemente negligenciada na engenharia de segurança de APIs:
1. **`SCOPE_` (Escopo OAuth2):** Representa **o que a aplicação cliente tem autorização para fazer em nome do usuário** (Princípio da Delegação de Acesso). É a permissão do cliente de software;
2. **`ROLE_` / Permissões (Perfis do Usuário):** Representa **o que a pessoa física humana tem direito de fazer segundo as regras de negócio da organização**. É a autoridade do operador humano.

A autorização de alto nível de segurança exige a verificação concomitante de ambos: para executar uma ação sensível, a aplicação cliente precisa possuir o escopo delegado **E** o usuário autenticado precisa possuir o papel de negócio correspondente.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Historicamente, sistemas corporativos ignoravam essa dualidade e implementavam validações míopes:
1. **A Invasão por Escopo Excessivo:** Em sistemas que checavam apenas `hasAuthority("SCOPE_read")`, qualquer aplicativo terceiro autorizado a ler dados públicos conseguia ler folhas de pagamento sigilosas caso o usuário conectado fosse um diretor financeiro;
2. **A Fraude por Bypass de Cliente:** Em sistemas que checavam apenas `hasRole("ADMIN")`, um administrador que fizesse login em um jogo casual ou aplicativo terceirizado que solicitasse apenas escopo de perfil público tinha seu perfil de Administrador herdado integralmente pela aplicação externa, permitindo que o aplicativo terceiro realizasse chamadas maliciosas à API corporativa pelas costas do usuário;
3. **Colisões de Nomenclatura:** A ausência de prefixos estritos fazia com que uma permissão de escopo `"admin"` colidisse com a role de negócio `"ADMIN"`, concedendo acesso irrestrito a sistemas sem qualquer distinção de contexto.

#### Parte 3: A Solução Moderna de Elite
No Spring Security 6.3+, a autorização de elite adota uma **Estratégia Híbrida de Autorização**. O Spring Security aplica o prefixo `SCOPE_` a todas as permissões originadas da claim de escopo do OAuth2 e o prefixo `ROLE_` às permissões originadas da claim de papéis de negócio.

Nas expressões `@PreAuthorize`, o desenvolvedor exige a conjunção lógica estrita (`and`):

```java
// Validação Híbrida de Elite: Exige delegação do cliente E poder do usuário
@PreAuthorize("hasAuthority('SCOPE_fiscalizacao:write') and hasRole('FISCAL')")
public AutoInfracaoResponse lavrarAuto(...) {
    // Só executa se o aplicativo tem permissão de escrita E o usuário é um fiscal habilitado
}
```

A tabela abaixo sintetiza a semântica inegociável de avaliação de autoridades:

| Prefixo no Spring Security | Origem da Claim no JWT | Semântica Arquitetural | Exemplo de Expressão SpEL |
| :--- | :--- | :--- | :--- |
| **`SCOPE_`** | `scope` ou `scp` | Delegação de acesso do aplicativo cliente | `hasAuthority('SCOPE_cadu:write')` |
| **`ROLE_`** | `roles` ou `realm_access.roles` | Papel macro de negócio do usuário no órgão | `hasRole('FISCAL')` *(busca `ROLE_FISCAL`)* |
| **Sem prefixo** | `permissoes` ou `authorities` | Ação funcional atômica do domínio | `hasAuthority('FISCALIZACAO_APREENDER')` |

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No subsistema de cadastro regulatório **`cadastrounicoservice` (`:8081`)**, frotas inteiras de empresas de ônibus são cadastradas. O aplicativo móvel de autoatendimento das permissionárias possui escopo restrito a `SCOPE_cadu:read` e `SCOPE_cadu:frotas:update`.

Se um motorista de ônibus ou auditor fiscal utilizar esse aplicativo comercial de autoatendimento para tentar excluir uma empresa permissionária do estado, a requisição é barrada imediatamente pelo método:

```java
@DeleteMapping("/empresas/{id}")
@PreAuthorize("hasAuthority('SCOPE_cadu:admin') and hasRole('ADMIN_AGR')")
public void revogarConcessaoEmpresa(@PathVariable Long id) {
    empresaService.revogarConcessao(id);
}
```

Mesmo que o usuário autenticado seja o Presidente da AGR (`hasRole('ADMIN_AGR')`), a operação é bloqueada com `HTTP 403 Forbidden` porque o aplicativo cliente que ele está utilizando não possui a autoridade de delegação necessária (`SCOPE_cadu:admin`), protegendo o sistema contra vazamento de credenciais por softwares satélites.

---

### 3.3 Controle Fino Declarativo com @EnableMethodSecurity e SpEL Refinado

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um hospital universitário de alta complexidade:
- **A Portaria Principal do Prédio (Filtro HTTP de Rede):** O porteiro na entrada da rua confere se você é funcionário do hospital e tem um crachá válido. Se tiver, você entra no saguão;
- **As Portas Eletrônicas dos Centros Cirúrgicos (Method Security Granular):** Na porta de cada sala de cirurgia, existe uma fechadura eletrônica independente conectada ao prontuário médico. Não basta ser médico: a fechadura só abre se o médico logado for o **cirurgião titular designado para o paciente que está naquela maca específica**, ou se for o Chefe Geral de Cirurgia em plantão de emergência.

No desenvolvimento de software, proteger apenas as URLs na camada web (`authorizeHttpRequests`) é o equivalente a trancar apenas a portaria da rua e deixar todas as portas dos centros cirúrgicos, cofres de medicamentos e salas de exames escancaradas por dentro. Se um método de serviço for invocado internamente por um job assíncrono, uma fila RabbitMQ ou outro controller, as regras de segurança da URL são totalmente ignoradas.

A anotação **`@EnableMethodSecurity(prePostEnabled = true)`** ativa a segurança declarativa no nível mais profundo da aplicação, interceptando diretamente a chamada dos métodos Java através de proxies AOP (*Aspect-Oriented Programming*). Combinada com o poder expressivo do **SpEL (Spring Expression Language)**, ela permite construir regras de **ABAC (Attribute-Based Access Control)** refinadas, onde o acesso é avaliado com base não apenas em quem o usuário é, mas em atributos em tempo real dos parâmetros passados para o método ou do objeto retornado.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A transição das anotações legadas para a sintaxe moderna do Spring Boot 3 foi registrada na aula **869_28.6** (*Atualizando o Spring Authorization Server*) da AlgaWorks:

> *"E aqui em cima, essa anotação sofreu uma alteração também de nome: basta utilizar agora esse EnableMethodSecurity e não EnableGlobalMethodSecurity, mas o comportamento continua o mesmo..."* (Linhas 39-44).

No legado anterior ao Spring Security 6, o controle de acesso nos métodos sofria de graves defeitos de projeto:
1. **O Caos do `@EnableGlobalMethodSecurity`:** O desenvolvedor precisava configurar propriedades arcaicas como `jsr250Enabled = true`, `securedEnabled = true` e `prePostEnabled = true`, gerando dúvidas sobre qual anotação utilizar (`@Secured`, `@RolesAllowed` ou `@PreAuthorize`);
2. **Poluição de Lógica de Negócio com Segurança:** Como os desenvolvedores não dominavam expressões SpEL avançadas, eles injetavam o `SecurityContext` manualmente dentro da camada de domínio/serviço e escreviam condicionais imperativas prolixas:
   ```java
   // O ANTIPADRÃO LEGADO: Código de negócio poluído com checagens manuais
   public void retificarAuto(Long autoId, AutoRequest request) {
       Authentication auth = SecurityContextHolder.getContext().getAuthentication();
       AutoInfracao auto = repository.findById(autoId).orElseThrow(...);
       if (!auto.getCpfFiscal().equals(auth.getName()) && !auth.getAuthorities().contains(...)) {
           throw new AccessDeniedException("Você não pode editar o auto de outro fiscal!");
       }
       // Só então executa o negócio...
   }
   ```
   Essa abordagem feria gravemente os princípios de Clean Architecture, impedia testes unitários limpos da regra de negócio e gerava duplicação de validações em múltiplos métodos.

#### Parte 3: A Solução Moderna de Elite
No Spring Security 6.3+, a anotação moderna `@EnableMethodSecurity` (que já vem com `prePostEnabled = true` por padrão) habilita a inspeção de métodos via proxies de alto desempenho. O desenvolvedor delega a verificação de regras contextuais complexas para beans de segurança dedicados invocados diretamente via SpEL (`@nomeDoBean.metodo(...)`).

Abaixo está a implementação completa do controller e do bean de segurança contextual (ABAC) demonstrando o poder do `@PreAuthorize`:

```java
package br.gov.go.agr.fiscalservice.api.controller;

import br.gov.go.agr.fiscalservice.api.dto.AutoInfracaoRequest;
import br.gov.go.agr.fiscalservice.api.dto.AutoInfracaoResponse;
import br.gov.go.agr.fiscalservice.domain.service.AutoInfracaoService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/autos-infracao")
public class AutoInfracaoController {

    private final AutoInfracaoService autoInfracaoService;

    public AutoInfracaoController(AutoInfracaoService autoInfracaoService) {
        this.autoInfracaoService = autoInfracaoService;
    }

    // Regra 1: Apenas fiscais credenciados com autoridade específica e escopo de escrita podem lavrar autos
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @PreAuthorize("hasAuthority('FISCALIZACAO_LAVRAR_AUTO') and hasAuthority('SCOPE_fiscalizacao:write')")
    public AutoInfracaoResponse lavrarAuto(
            @RequestBody @Valid AutoInfracaoRequest request,
            Authentication authentication) {
        String cpfFiscalAutenticado = authentication.getName();
        return autoInfracaoService.lavrarAuto(request, cpfFiscalAutenticado);
    }

    // Regra 2: Consulta pública permitida para cidadão com chave do auto, ou fiscais e administradores
    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('SCOPE_fiscalizacao:read') and (hasRole('FISCAL') or hasRole('ADMIN') or hasAuthority('AUTORIZACAO_CONSULTAR_PUBLICO'))")
    public ResponseEntity<AutoInfracaoResponse> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(autoInfracaoService.buscarPorId(id));
    }

    // Regra 3: Edição restrita ao próprio fiscal que lavrou o auto (ABAC com SpEL) ou ao Administrador do Órgão
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or (hasRole('FISCAL') and @autoInfracaoSecurity.isFiscalTitular(#id, authentication.name))")
    public ResponseEntity<AutoInfracaoResponse> retificarAuto(
            @PathVariable Long id,
            @RequestBody @Valid AutoInfracaoRequest request) {
        return ResponseEntity.ok(autoInfracaoService.retificarAuto(id, request));
    }
}
```

E o componente de segurança contextual invocado pela expressão SpEL `@autoInfracaoSecurity.isFiscalTitular(#id, authentication.name)`:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import br.gov.go.agr.fiscalservice.domain.repository.AutoInfracaoRepository;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component("autoInfracaoSecurity")
public class AutoInfracaoSecurityHelper {

    private final AutoInfracaoRepository autoInfracaoRepository;

    public AutoInfracaoSecurityHelper(AutoInfracaoRepository autoInfracaoRepository) {
        this.autoInfracaoRepository = autoInfracaoRepository;
    }

    @Transactional(readOnly = true)
    public boolean isFiscalTitular(Long autoInfracaoId, String cpfAutenticado) {
        if (autoInfracaoId == null || cpfAutenticado == null || cpfAutenticado.isBlank()) {
            return false;
        }

        return autoInfracaoRepository.findCpfFiscalById(autoInfracaoId)
            .map(cpfTitular -> cpfTitular.equals(cpfAutenticado))
            .orElse(false);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No processo legal e administrativo da **AGR**, a lavratura e retificação de autos de infração é um ato administrativo solene e com fé pública. Segundo o regulamento jurídico da agência, **um fiscal não pode alterar a descrição de fatos ou atenuantes de um auto lavrado por outro colega de corporação**, salvo o Gerente de Fiscalização (com perfil `ROLE_ADMIN`) em grau de recurso tempestivo.

Com o uso de `@PreAuthorize("hasRole('ADMIN') or (hasRole('FISCAL') and @autoInfracaoSecurity.isFiscalTitular(#id, authentication.name))")`, essa regra jurídica estadual é imposta com perfeição matemática em tempo de execução:
- Se o auditor fiscal José (CPF `111`) tentar retificar um auto lavrado pelo auditor fiscal Pedro (CPF `222`), a consulta de verificação de titularidade é disparada pelo SpEL e o Spring Security aborta a requisição lançando `AccessDeniedException` (HTTP 403) antes que qualquer linha do método de serviço seja executada;
- A regra de negócio permanece limpa e sem acoplamento a objetos de infraestrutura do Spring Security, garantindo segurança corporativa Zero-Trust.

---

## 4. Transição OAuth 2.1 & Fim do Password Grant

### 4.1 A Descontinuação Oficial do Resource Owner Password Credentials Grant

#### Parte 1: O que é o conceito / Analogia Didática
Imagine que você vá a um restaurante almoçar:
- **No Modelo Antigo (Password Grant):** Na hora de pagar a conta, você entrega seu cartão de crédito bancário e fala em voz alta a sua senha de 6 dígitos para o garçom. O garçom anota sua senha em um guardanapo de papel, vai até a cozinha nos fundos do restaurante onde fica a máquina de cartão, digita sua senha, conclui a transação e volta com o recibo. Mesmo que o garçom seja honesto, **você acabou de expor a chave mestra de todas as suas finanças pessoais a um intermediário**;
- **No Modelo Moderno (OAuth 2.1 / Redirecionamento Autônomo):** O garçom traz a máquina de cartão lacrada pelo banco até a sua mesa. O visor da máquina é de uso exclusivo seu: você insere o cartão com chip, confere o valor diretamente no visor do banco, digita a senha sem que o garçom veja e o próprio chip autoriza o pagamento diretamente com a rede bancária. O restaurante **nunca tocou na sua senha e nunca soube quais dígitos você teclou**.

O fluxo **Resource Owner Password Credentials (`grant_type=password`)** do OAuth 2.0 original era exatamente o cenário do garçom levando a sua senha para a cozinha: o aplicativo cliente (como um frontend SPA Angular ou aplicativo Android) solicitava o login e senha do usuário final em um formulário próprio e enviava essas credenciais puras para o Authorization Server.

No **OAuth 2.1 (a consolidação definitiva da especificação IETF)**, o fluxo de Password Grant foi **oficialmente descontinuado e banido**. As aplicações clientes são terminantemente proibidas de manipular senhas de usuários. Toda autenticação passa a ser delegada para o Authorization Server através do navegador do usuário, permitindo o uso universal de Múltiplo Fator de Autenticação (MFA), chaves físicas de segurança (FIDO2/WebAuthn) e login federado único (Gov.br).

#### Parte 2: A Dor Histórica / O Desastre do Legado
O ensino intensivo do fluxo de Password Credentials no passado e o alerta premonitório de sua periculosidade foram documentados na aula **709_22.7** (*Conhecendo o fluxo Resource Owner Password Credentials*) do curso *Especialista Spring REST* da AlgaWorks:

> *"O fluxo resource owner password credentials grant é uma forma de obter um access token, ou seja, um token de acesso a partir de um usuário e senha. Ou seja, você troca um usuário senha em troca de um access token... O client vai passar no corpo da requisição o username e o password do resource owner... E vai passar também um campo grant_type igual a password... O client não deve armazenar o usuário senha... Ele deve usar apenas uma vez para trocar esse usuário senha em troca do access token, pronto, acabou... Agora, esse cliente aqui pode ser qualquer tipo de cliente? Não, não é recomendado que seja qualquer tipo de cliente... No caso do AlgaFood, por exemplo, a gente não poderia permitir que esse cliente aqui fosse de uma outra empresa qualquer... Porque esses clientes não são confiáveis... E aí os usuários do AlgaFood ter que digitar o usuário e senha em uma aplicação desconhecida é um risco de segurança... Mesmo que o cliente seja seu, você desenvolveu a API e o cliente é seu também. Ainda assim, esse fluxo é desencorajado pelo pessoal do OAuth... Evite usar esse fluxo aqui..."* (Linhas 8-43, 99-121).

O uso do Password Grant em sistemas reais provocou incidentes gravíssimos:
1. **O Phishing Corporativo Interno:** Como os usuários estavam acostumados a digitar sua senha institucional em caixas de texto de qualquer tela feita em Angular ou Vue.js, desenvolvedores mal-intencionados ou atacantes que comprometessem um frontend conseguiam capturar credenciais corporativas no evento `submit` do formulário antes mesmo de chamar a API;
2. **Incompatibilidade com Múltiplo Fator de Autenticação (MFA):** O payload do Password Grant aceitava apenas os campos planos `username` e `password`. Se o governo do estado exigisse autenticação de dois fatores via aplicativo TOTP (Google Authenticator) ou certificado digital em nuvem, o fluxo quebrava completamente, pois não havia mecanismo padronizado para conduzir os passos intermediários de verificação;
3. **Senhas em Memória e Logs de Rede:** O login e a senha trafegavam no corpo de requisições HTTP `POST`. Falhas de configuração em proxies reversos, gateways e coletores de log (Elasticsearch / CloudWatch) gravavam senhas em texto puro em arquivos de log de auditoria de rede.

#### Parte 3: A Solução Moderna de Elite
No OAuth 2.1, qualquer cliente que envolva a interação de um usuário humano (seja ele um navegador web executando um Single Page Application em Angular ou um aplicativo móvel em Flutter/Android/iOS) deve obrigatoriamente utilizar o **Authorization Code Flow com PKCE (Proof Key for Code Exchange)**.

A tabela abaixo contrasta o fluxo banido com o padrão moderno de elite:

| Critério de Engenharia | OAuth 2.0 Legado (Password Grant) | OAuth 2.1 Moderno de Elite (Auth Code + PKCE) |
| :--- | :--- | :--- |
| **Parâmetro de concessão** | `grant_type=password` | `grant_type=authorization_code` com `code_verifier` |
| **Manipulação de senhas pelo client** | Sim (o frontend lê e envia usuário e senha do operador) | **Não** (a senha é digitada diretamente na página segura do Auth Server) |
| **Suporte a MFA / Gov.br / Biometria** | Praticamente inviável (exige hacks fora da especificação) | **Nativo e transparente** (gerenciado integralmente pelo Auth Server) |
| **Vulnerabilidade a Phishing de tela** | Altíssima (qualquer SPA clone captura a senha) | **Zero** (o navegador exibe a URL oficial com certificado SSL da autoridade) |
| **Status normativo no Spring Security 6** | **Completamente removido do Spring Authorization Server** | **Fluxo padrão e obrigatório para aplicações públicas** |

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No processo de modernização do **Portal da AGR**, a antiga tela de login desenvolvida em Angular 8 coletava o CPF e a senha do servidor e enviava uma requisição `POST /oauth/token` com `grant_type=password` para o backend `portalservice`. 

Essa arquitetura impedia que os servidores utilizassem a identidade única federal **Gov.br (com selo Prata ou Ouro)**. Com a transição mandatória para o OAuth 2.1, a tela de login do frontend legado foi sumariamente eliminada:
- Ao clicar em "Acessar Sistema", o usuário é redirecionado de forma segura para o Keycloak oficial do Estado de Goiás;
- Na tela oficial do estado, o cidadão ou fiscal pode escolher autenticar-se via Gov.br, certificado digital em nuvem ou biometria;
- Concluída a autenticação, o Keycloak redireciona o navegador de volta para o sistema da AGR com um código temporário de autorização, sem que nenhum frontend tenha tocado na senha do servidor.

---

### 4.2 Authorization Code Flow com PKCE (RFC 7636) para SPAs e Aplicações Móveis

#### Parte 1: O que é o conceito / Analogia Didática
Imagine uma operação de resgate diplomático em território hostil:
- O agente de campo no solo precisa de um código de resgate enviado pelo quartel-general. No entanto, os canais de rádio abertos são escutados por espiões inimigos;
- Antes de pedir o resgate, o agente de campo gera uma senha aleatória ultrassecreta em sua cabeça chamada **Verificador (`code_verifier`)**;
- Ele aplica um cálculo matemático irreversível (hash SHA-256) nessa senha secreta, gerando um enigma público chamado **Desafio (`code_challenge`)**;
- Ele envia o Desafio pelo rádio para o quartel-general. O espião inimigo ouve o Desafio, mas não consegue descobrir a senha original porque o cálculo não pode ser desfeito de trás para frente;
- O quartel-general confere as credenciais do agente e responde pelo rádio: *"Seu código temporário de autorização é 987654"*;
- O espião inimigo intercepta esse código 987654 pelo rádio e corre para o ponto de extração para roubar o resgate! Porém, ao chegar lá, a sentinela do quartel-general exige: *"Apresente a senha original que gerou o enigma do Desafio inicial!"*;
- Como o espião só tem o código interceptado e não conhece a senha secreta que o agente guardou em sua mente, a sentinela atira no impostor. Em seguida, o agente legítimo apresenta o Verificador original, a sentinela confere que `SHA256(Verificador) == Desafio` e entrega o token de resgate com segurança máxima.

Esse é o funcionamento exato do **PKCE (Proof Key for Code Exchange - RFC 7636)**. Ele foi concebido para proteger **Clientes Públicos** (aplicações que rodam no dispositivo do usuário, como SPAs em navegadores web e apps mobile), onde é fisicamente impossível armazenar uma senha secreta de cliente (`client_secret`) sem que ela seja descompilada ou inspecionada no navegador pelo usuário.

#### Parte 2: A Dor Histórica / O Desastre do Legado
Antes da padronização do PKCE, o ecossistema OAuth 2.0 utilizava o malfadado **Implicit Flow (`response_type=token`)**:
1. **O Vazamento de Tokens no Histórico do Navegador:** No fluxo Implicit, o Authorization Server devolvia o token de acesso diretamente no fragmento de hash da URL de redirecionamento (`https://meuapp.agr.go.gov.br/#access_token=eyJhbGci...`). Esse token ficava gravado no histórico de navegação do browser, em logs de proxies de rede intermediários e no cabeçalho `Referer` enviado a sites externos;
2. **O Ataque de Interceptação de Código de Autorização:** No fluxo clássico de código sem PKCE, qualquer aplicativo malicioso instalado no smartphone de um fiscal conseguia registrar o mesmo esquema de URL personalizada (*Custom URL Scheme*, ex: `agr://callback`) e roubar o código de autorização devolvido pelo servidor, trocando-o por tokens legítimos;
3. **O Falso Segredo embutido em SPAs:** Desenvolvedores legados tentavam usar o Authorization Code Flow tradicional em SPAs Angular incluindo o `client_secret` diretamente no arquivo `environment.ts`. Qualquer pessoa que abrisse a aba *Network* das ferramentas de desenvolvedor (F12) conseguia copiar o segredo corporativo e personificar o sistema oficial em ataques externos.

#### Parte 3: A Solução Moderna de Elite
No OAuth 2.1, o fluxo **Authorization Code com PKCE é mandatório para todos os clientes públicos e fortemente recomendado até para clientes confidenciais**. A aplicação cliente não possui nenhum `client_secret`. Toda a segurança criptográfica repousa no par efêmero `code_verifier` e `code_challenge`.

Abaixo está o diagrama de sequência detalhado que ilustra todo o ciclo de vida do fluxo PKCE:

```
NAVEGADOR / SPA ANGULAR                 AUTHORIZATION SERVER               RESOURCE SERVER
       │                                         │                                │
1. Gera code_verifier (aleatório)                │                                │
   Calcula code_challenge = SHA256(verifier)     │                                │
       │                                         │                                │
2. Redireciona para /oauth2/authorize ──────────►│                                │
   (client_id, code_challenge, S256, redirect_uri)│                                │
       │                                         │                                │
       │ 3. Usuário autentica (Gov.br / MFA)     │                                │
       │◄────────────────────────────────────────┘                                │
       │                                                                          │
4. Retorna com ?code=AUTH_CODE_123 ───────────────────────────────────────────────┐
       │                                                                          │
5. POST /oauth2/token ──────────────────────────►│                                │
   (code=AUTH_CODE_123, code_verifier,           │ (Valida se SHA256(verifier)    │
    client_id - ZERO client_secret!)             │  corresponde ao challenge)     │
       │                                         │                                │
6. Retorna Access Token JWT (RS256) ◄────────────┤                                │
       │                                                                          │
7. GET /api/v1/autos-infracao (Header: Bearer <JWT>) ────────────────────────────►│
       │                                                                          │ (Valida JWT via JWKS)
8. Resposta 200 OK com dados protegidos ◄─────────────────────────────────────────┤
```

E no backend do Authorization Server (Spring Authorization Server 1.3+), a exigência de PKCE para o cliente SPA é ativada de forma declarativa:

```java
package br.gov.go.agr.fiscalservice.infrastructure.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.ClientAuthenticationMethod;
import org.springframework.security.oauth2.server.authorization.client.InMemoryRegisteredClientRepository;
import org.springframework.security.oauth2.server.authorization.client.RegisteredClient;
import org.springframework.security.oauth2.server.authorization.client.RegisteredClientRepository;
import org.springframework.security.oauth2.server.authorization.settings.ClientSettings;

import java.util.UUID;

@Configuration
public class OAuth2ClientRegistrationConfig {

    @Bean
    public RegisteredClientRepository registeredClientRepository() {
        RegisteredClient spaClient = RegisteredClient.withId(UUID.randomUUID().toString())
            .clientId("agr-portal-spa")
            // Cliente público: NÃO possui client_secret!
            .clientAuthenticationMethod(ClientAuthenticationMethod.NONE)
            .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
            .authorizationGrantType(AuthorizationGrantType.REFRESH_TOKEN)
            .redirectUri("https://portal.agr.go.gov.br/login/callback")
            .scope("fiscalizacao:read")
            .scope("fiscalizacao:write")
            .scope("cadu:read")
            // EXIGÊNCIA MANDATÓRIA DE PKCE: Rejeita chamadas sem code_challenge
            .clientSettings(ClientSettings.builder()
                .requireProofKeyForCodeExchange(true)
                .requireAuthorizationConsent(false)
                .build())
            .build();

        return new InMemoryRegisteredClientRepository(spaClient);
    }
}
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No laboratório do **Teatro-ABC (`:8090`)**, o portal de venda de ingressos é uma Single Page Application desenvolvida em **Angular 18 com Standalone Components**. Quando o cidadão seleciona seus assentos no mapa interativo e clica em "Finalizar Compra", o serviço de autenticação do Angular (utilizando a biblioteca padrão `angular-oauth2-oidc` em modo estrito PKCE) gera um `code_verifier` de 128 caracteres criptograficamente seguro e redireciona o navegador para o servidor de identidade.

Mesmo que um usuário técnico inspecione todo o tráfego do navegador, ele não encontrará nenhum segredo corporativo estático. Se outro aplicativo malicioso tentar capturar o `code` de redirecionamento, a troca pelo token falhará de forma irrevogável, pois apenas a instância em memória do navegador legítimo do comprador possui o `code_verifier` que gerou o desafio criptográfico inicial.

---

### 4.3 Client Credentials Flow para Comunicação Segura Machine-to-Machine (M2M)

#### Parte 1: O que é o conceito / Analogia Didática
Imagine um canal de inteligência militar entre dois navios de guerra em alto-mar:
- O navio de escolta precisa informar as coordenadas de radar para o porta-aviões principal a cada 5 segundos;
- **Não há capitão humano digitando login e senha no teclado a cada 5 segundos no navio de escolta**. A comunicação ocorre diretamente entre o computador de bordo do navio A e o computador de bordo do navio B;
- Antes de iniciar a missão, o Ministério da Defesa gravou nos sistemas de ambos os navios um par de credenciais diplomáticas seguras e altamente protegidas em hardware criptográfico (**`client_id` e `client_secret` confidenciais**).

Esse é o fluxo **Client Credentials (`grant_type=client_credentials`)**. Ele é projetado especificamente para cenários **Machine-to-Machine (M2M)**, onde dois sistemas computacionais automatizados precisam trocar dados nos bastidores sem a presença, mediação ou contexto de um usuário humano operando a tela.

#### Parte 2: A Dor Histórica / O Desastre do Legado
A carência de um mecanismo padronizado de autenticação M2M gerava soluções catastróficas em arquiteturas legadas:
1. **O Usuário Fantasma no Banco de Dados:** Desenvolvedores criavam uma conta de usuário falsa no banco de dados chamada `"USUARIO_SISTEMA_ROBO"` ou `"admin_batch"`. O microsserviço chamador mantinha o usuário e a senha desse robô em seu arquivo de configuração e usava o Password Grant para gerar tokens simulando uma pessoa física. Se esse usuário fantasma fosse bloqueado pelo RH, dezenas de microsserviços paravam de se comunicar simultaneamente;
2. **A Rede Interna Totalmente Escancarada:** Acreditando na ilusão de que "a rede interna é segura", muitos microsserviços desabilitavam completamente a segurança para chamadas vindas de outros IPs da rede corporativa (`permitAll()` para IPs `10.0.0.0/8`). Se um invasor conseguisse explorar uma vulnerabilidade simples em um serviço satélite externo, ele ganhava acesso irrestrito a todos os bancos de dados financeiros da infraestrutura;
3. **Ausência Total de Rastreabilidade e Auditoria:** Chamadas entre serviços utilizavam autenticação HTTP Basic estática com credenciais idênticas compartilhadas por anos. Era impossível auditar qual microsserviço havia inserido ou alterado um registro fiscal no banco de dados.

#### Parte 3: A Solução Moderna de Elite
No Spring Security 6.3+, a comunicação M2M é orquestrada de forma totalmente transparente e automática utilizando o **`RestClient`** moderno associado ao **`OAuth2AuthorizedClientManager`**. O Spring gerencia o ciclo de vida do token de acesso em segundo plano: ele solicita o token ao Authorization Server via `client_credentials`, armazena-o em cache de memória e o renova automaticamente antes que expire, injetando o cabeçalho `Authorization: Bearer <JWT>` em todas as requisições disparadas pelo cliente HTTP.

Abaixo está a configuração completa de produção para clientes M2M síncronos:

```java
package br.gov.go.agr.fiscalservice.infrastructure.client;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.oauth2.client.AuthorizedClientServiceOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.web.client.RestClient;

@Configuration
public class MicroserviceM2MClientConfig {

    @Bean
    public OAuth2AuthorizedClientManager authorizedClientManager(
            ClientRegistrationRepository clientRegistrationRepository,
            OAuth2AuthorizedClientService authorizedClientService) {
        return new AuthorizedClientServiceOAuth2AuthorizedClientManager(
            clientRegistrationRepository, authorizedClientService
        );
    }

    @Bean
    public RestClient receitaServiceClient(
            RestClient.Builder builder,
            OAuth2AuthorizedClientManager authorizedClientManager) {
        return builder
            .baseUrl("http://receita:8092")
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .requestInterceptor((request, body, execution) -> {
                // Solicita ou recupera do cache o token de acesso M2M para o serviço de arrecadação
                OAuth2AuthorizeRequest authorizeRequest = OAuth2AuthorizeRequest
                    .withClientRegistrationId("agrfiscalservice-m2m")
                    .principal("agrfiscalservice")
                    .build();

                OAuth2AuthorizedClient authorizedClient = authorizedClientManager.authorize(authorizeRequest);
                if (authorizedClient != null && authorizedClient.getAccessToken() != null) {
                    String tokenValue = authorizedClient.getAccessToken().getTokenValue();
                    request.getHeaders().setBearerAuth(tokenValue);
                }

                return execution.execute(request, body);
            })
            .build();
    }
}
```

E no `application.yml`, a declaração das credenciais confidenciais do microsserviço:

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          agrfiscalservice-m2m:
            client-id: agrfiscalservice-m2m-client
            client-secret: ${M2M_SECRET_RECEITA}
            authorization-grant-type: client_credentials
            scope:
              - receita:write
              - receita:read
        provider:
          agrfiscalservice-m2m:
            token-uri: https://identidade.agr.go.gov.br/oauth2/token
```

#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC
No processo sancionatório da AGR, quando um auditor encerra a lavratura de um auto de infração grave por transporte clandestino no **`agrfiscalservice` (`:8083`)**, o sistema precisa acionar instantaneamente o microsserviço financeiro **`receitaservice` (`:8092`)** para calcular o valor da multa com juros da taxa SELIC e emitir a respectiva guia DARE da Secretaria da Economia (SEFAZ-GO).

Essa comunicação ocorre nos bastidores entre os servidores, sem nenhuma intervenção humana. O `agrfiscalservice` utiliza o `receitaServiceClient` configurado acima. O interceptor injeta o token Bearer M2M contendo a claim `sub: "agrfiscalservice-m2m-client"` e o escopo `SCOPE_receita:write`. 

Ao receber a requisição, o `receitaservice` valida a assinatura do token via JWKS, confirma que a chamada parte de um microsserviço oficial da malha com autorização de escrita tributária e gera a guia DARE com rastreabilidade absoluta e conformidade total com as normas de auditoria do Tribunal de Contas do Estado de Goiás (TCE-GO).

---

## Conclusão & Checklist Zero-Trust de Produção

A segurança em arquiteturas corporativas modernas e microsserviços não é um recurso periférico a ser adicionado ao final do projeto; ela é a fundação que determina a viabilidade, escalabilidade e resiliência de todo o ecossistema tecnológico.

### Checklist Definitivo de Verificação de Segurança (Produção)

Antes de promover qualquer microsserviço Spring Boot 3.3+ para o ambiente de produção, certifique-se de que todos os itens abaixo estejam 100% cumpridos:

- [x] **Zero WebSecurityConfigurerAdapter:** Configuração baseada estritamente em `@Bean SecurityFilterChain` utilizando DSL com expressões lambda fluentes;
- [x] **Zero antMatchers:** Todas as rotas mapeadas exclusivamente através de `requestMatchers()` com resolução alinhada ao `MvcRequestMatcher` do Spring MVC;
- [x] **Zero Estado de Sessão HTTP:** Diretiva `SessionCreationPolicy.STATELESS` explícita e `NullSecurityContextRepository` ativo. Nenhuma alocação de `HttpSession`;
- [x] **Zero CSRF para APIs Bearer:** Desativação consciente do `CsrfFilter` em rotas stateless que não utilizam cookies de autenticação;
- [x] **CORS Restritivo e Estrito:** Origens, métodos e cabeçalhos permitidos declarados de forma explícita. Zero uso de curingas permissivos (`*`) em ambientes produtivos;
- [x] **Zero Segredos Simétricos Compartilhados:** Eliminação total de chaves HMAC (`jwt.secret=sw!tch14`). Adoção universal de criptografia assimétrica RSA com distribuição de chaves públicas via JWKS (`/.well-known/jwks.json`);
- [x] **Validação Rígida de Claims:** Inspeção mandatória de emissor (`iss`), expiração curta (`exp`), audiência esperada da API (`aud`) e unicidade de token (`jti`);
- [x] **Separação Semântica RBAC:** Conversor `CustomJwtAuthenticationConverter` isolando `SCOPE_` (delegação de cliente) de `ROLE_` (perfis de usuário) e permissões de domínio;
- [x] **Method Security Declarativo:** Ativação de `@EnableMethodSecurity(prePostEnabled = true)` e imposição de regras granulares via `@PreAuthorize` e SpEL no nível de método;
- [x] **Fim Definitivo do Password Grant:** Banimento do `grant_type=password`. Adoção de Authorization Code com PKCE para Single Page Applications (Angular) e Client Credentials para integrações M2M entre microsserviços.

---

### Tabela Comparativa de Transição: Legado vs Moderno de Elite

| Funcionalidade / Padrão | O Jeito Antigo (Legado AlgaWorks / AGR) | O Jeito Moderno de Elite (Spring Security 6.3+) |
| :--- | :--- | :--- |
| **Classe de Configuração** | `extends WebSecurityConfigurerAdapter` | `@Bean SecurityFilterChain securityFilterChain(HttpSecurity http)` |
| **Encadeamento de Regras** | Procedural infinito com `.and()` | DSL declarativa e funcional baseada em Lambdas |
| **Mapeamento de Rotas** | `.antMatchers("/api/**")` | `.requestMatchers("/api/**")` com `MvcRequestMatcher` |
| **Gestão de Sessão** | `SessionCreationPolicy.IF_REQUIRED` (cookies JSESSIONID) | `SessionCreationPolicy.STATELESS` (Zero Cookies) |
| **Proteção CSRF** | Ativado por padrão ou desligado cegamente sem justificativa | `csrf(AbstractHttpConfigurer::disable)` cirúrgico para Bearer |
| **Topologia OAuth2** | Resource Server e Auth Server acoplados no mesmo projeto | Separação estrita: Keycloak / SAS central vs Resource Server leve |
| **Criptografia de Tokens** | Simétrica HS256 com senha estática compartilhada | Assimétrica RS256 com chave privada segura e JWKS público |
| **Validação de Assinatura** | Compartilhamento do arquivo `.jks` ou segredo texto puro | Resolução dinâmica via endpoint `/.well-known/jwks.json` |
| **Mapeamento de Autoridades** | Leitura crua de `scope` gerando apenas `SCOPE_` | `CustomJwtAuthenticationConverter` separando `SCOPE_` e `ROLE_` |
| **Controle em Métodos** | `@EnableGlobalMethodSecurity` com checagens manuais | `@EnableMethodSecurity` com `@PreAuthorize` e SpEL granular |
| **Login em Frontends SPAs** | `grant_type=password` coletando usuário e senha na tela | **Authorization Code Flow com PKCE (RFC 7636)** |
| **Chamadas entre Serviços** | HTTP Basic estático ou usuário robô com Password Grant | **Client Credentials Flow** com `RestClient` gerenciado |

---

### Guia de Transição para o Módulo 05 (Frontend Enterprise Angular)

Com a fortaleza de segurança do backend estabelecida sobre o Spring Security 6 e o protocolo stateless OAuth 2.1, o próximo passo na jornada de engenharia corporativa é a construção do cliente consumidor de elite:
- No **Módulo 05: Frontend Enterprise Moderno: Arquitetura Limpa com Angular 18+, Signals e Reatividade de Elite**, exploraremos a implementação do cliente público Single Page Application;
- Implementaremos o fluxo de autenticação **Authorization Code com PKCE** no navegador sem expor segredos, utilizando **Standalone Components**, injeção moderna via `inject()` e gerenciamento reativo de estado de autenticação através de **Signals (`signal`, `computed`, `effect`)**;
- Garantiremos que os tokens JWT recebidos do Keycloak sejam armazenados com segurança estrita em memória e propagados de forma automática em requisições HTTP através de interceptores funcionais, consumindo os endpoints protegidos do `agrfiscalservice` e da bilhetagem do `teatro-abc` com zero atrito e conformidade total de padrões corporativos internacionais.

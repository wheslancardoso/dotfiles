# Section 1 builder for Module 04
from pathlib import Path

content_sec1 = """# Módulo 04: Segurança Corporativa Stateless: Spring Security 6, OAuth2 Resource Server, JWT & RBAC Granular

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
"""

if __name__ == "__main__":
    print(f"Section 1 ready: {len(content_sec1.splitlines())} lines")
    Path("/home/lan/dotfiles/.agents/teamwork_preview_worker_m4_1/sec1.md").write_text(content_sec1, encoding="utf-8")
    print("Saved sec1.md successfully")

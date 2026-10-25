
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

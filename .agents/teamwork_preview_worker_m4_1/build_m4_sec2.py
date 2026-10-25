# Section 2 builder for Module 04
from pathlib import Path

content_sec2 = """
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
"""

if __name__ == "__main__":
    print(f"Section 2 ready: {len(content_sec2.splitlines())} lines")
    Path("/home/lan/dotfiles/.agents/teamwork_preview_worker_m4_1/sec2.md").write_text(content_sec2, encoding="utf-8")
    print("Saved sec2.md successfully")

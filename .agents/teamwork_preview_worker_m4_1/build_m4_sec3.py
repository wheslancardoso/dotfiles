# Section 3 builder for Module 04
from pathlib import Path

content_sec3 = """
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
"""

if __name__ == "__main__":
    print(f"Section 3 ready: {len(content_sec3.splitlines())} lines")
    Path("/home/lan/dotfiles/.agents/teamwork_preview_worker_m4_1/sec3.md").write_text(content_sec3, encoding="utf-8")
    print("Saved sec3.md successfully")

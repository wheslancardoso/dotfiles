import os
from pathlib import Path

report_path = Path("/home/lan/dotfiles/.agents/teamwork_preview_explorer_m4_1/report.md")

content = """# Blueprint Arquitetural & Especificação Canônica: Módulo 04
## Segurança Corporativa Stateless: Spring Security 6, OAuth2 Resource Server, JWT & RBAC Granular
### Documento Alvo: `/home/lan/dotfiles/templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md`

> **Autor:** Explorer Milestone 4 (Segurança Stateless OAuth2, JWT e RBAC)  
> **Data:** 25 de Outubro de 2026  
> **Status:** Especificação Canônica Aprovada para Autoria  
> **Conformidade Normativa:** `ORIGINAL_REQUEST.md`, `PROJECT.md` (F13, F14, F15, F16), `scripts/verify_docs_suite.py` (Tiers 1 a 4)

---

## 1. Sumário Executivo & Manifesto da Segurança Stateless de Elite

A segurança de software em arquiteturas distribuídas e microsserviços modernos atingiu um divisor de águas irrevogável: o colapso dos modelos de segurança baseados em estado de sessão no servidor (**Stateful Security / JSESSIONID**) e o banimento dos fluxos de credenciais opacas em prol do padrão **Zero-Trust com Tokens Autocontidos Assinados Criptograficamente (Stateless JWT / OAuth 2.1)**.

Em sistemas governamentais de fiscalização e arrecadação de alta sensibilidade — como a malha de 25 microsserviços da **Agência Goiana de Regulação (AGR)** — e em plataformas de alta concorrência com validação de acesso em tempo real — como a bilhetagem do **Teatro-ABC (Centro Cultural Oscar Niemeyer)** —, o desconhecimento dos princípios modernos de segurança de APIs provoca catástrofes de proporções épicas:
1. **Acoplamento Destrutivo e Incompatibilidade de Escala:** Uso de sessões HTTP em memória (`HttpSession`) e cookies de sessão (`JSESSIONID`), inviabilizando o balanceamento de carga horizontal, forçando sessões pegajosas (*sticky sessions*) e gerando *out-of-memory* sob picos de tráfego.
2. **Vulnerabilidade Sistêmica por Chave Simétrica Compartilhada:** O compartilhamento irresponsável de uma mesma senha/segredo simétrico (`jwt.secret=sw!tch14`) entre dezenas de microsserviços. Caso um único serviço satélite menos protegido sofresse invasão, o atacante obtinha a chave simétrica e conseguia forjar tokens JWT válidos para todo o ecossistema estadual, incluindo permissões de Administrador e Fiscal.
3. **A Armadilha do Password Grant (`grant_type=password`):** Aplicações clientes (frontends SPA Angular e mobile) coletando credenciais puras de login e senha do usuário final, expondo senhas em trânsito e na memória do browser, e impossibilitando autenticação federada (Gov.br) ou Múltiplo Fator de Autenticação (MFA).
4. **Bypass de Autorização por Falha de Matching de URL (CVE-2023-34035):** O uso do legado `antMatchers()`, suscetível a divergências de interpretação de barras e sufixos entre o Spring MVC e o Spring Security, superado obrigatoriamente pelo `requestMatchers()`.
5. **Confusão de Escopos vs Perfis de Negócio:** Mistura indiscriminada de `scope` (delegação de cliente OAuth2) e `roles` (papel de negócio do usuário), permitindo que um aplicativo com escopo de leitura consiga acidentalmente invocar endpoints de gravação se a verificação de autoridade não for estritamente prefixada.

O Módulo 04 da suíte pedagógica tem como missão desmistificar a arquitetura de segurança do **Spring Security 6.3+ / Spring Boot 3.3+**, instruindo o desenvolvedor a construir uma fortaleza digital com separação estrita entre **Authorization Server** (emissor de tokens via chaves assimétricas RSA/JWKS) e **Resource Server** (validador stateless), com autorização declarativa em nível de método via `@PreAuthorize` e expressões SpEL refinadas.

---

## 2. Matriz de Conformidade com `scripts/verify_docs_suite.py`

O script de verificação automatizada `scripts/verify_docs_suite.py` audita o arquivo `04-seguranca-stateless-oauth2-jwt-rbac.md` contra um conjunto de regras estritas:

| Identificador do Check | Descrição do Teste Automatizado | Regex Canônica no Verificador | Requisito de Engenharia no Blueprint |
| :--- | :--- | :--- | :--- |
| **`T1-FILE-04-S`** | Presença física do arquivo canônico | `templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md` | Arquivo deve existir com conteúdo não-vazio. |
| **`T2-LEN-04-S`** | Extensão substancial de conteúdo | `len(lines) >= 301` | Meta mínima de 1.100 a 1.500 linhas de densidade técnica pura. |
| **`T2-PH-04-S`** | Proibição absoluta de placeholders | `r"\b(TODO\|FIXME\|\[TBD\]\|implementar\s+depois\|em\s+breve)\b"` | Zero placeholders. Todos os métodos e configurações 100% implementados. |
| **`T2-ELLIP-04-S`** | Proibição de reticências bare em código | `r"^\s*(//\|#\|/\*\|<!--)?\s*\.\.\.\s*(\*/\|-->)?\s*$"` | Sem reticências soltas em blocos de código. Todo código compilável. |
| **`T3-PART1-04-S`** | Presença da Parte 1 da estrutura pedagógica | `r"(o\s+que\s+[eé]\s+(o\|um)?\s*conceito\|analogia(\s+com\s+o\s+mundo\s+real\|\s+did[aá]tica)?\|conceito\s+puro)"` | Subtítulo padronizado: `#### Parte 1: O que é o conceito / Analogia Didática` em todas as seções. |
| **`T3-PART2-04-S`** | Presença da Parte 2 da estrutura pedagógica | `r"(a\s+dor\s+hist[oó]rica\|o\s+desastre\s+do\s+legado\|o\s+que\s+quebrava\s+em\s+produ[cç][aã]o\|dor\s+no\s+mundo\s+real)"` | Subtítulo padronizado: `#### Parte 2: A Dor Histórica / O Desastre do Legado` em todas as seções. |
| **`T3-PART3-04-S`** | Presença da Parte 3 da estrutura pedagógica | `r"(a\s+solu[cç][aã]o\s+moderna(\s+de\s+elite)?\|engenharia\s+moderna\|solu[cç][aã]o\s+de\s+elite)"` | Subtítulo padronizado: `#### Parte 3: A Solução Moderna de Elite` em todas as seções. |
| **`T3-PART4-04-S`** | Presença da Parte 4 da estrutura pedagógica | `r"(v[ií]nculo\s+direto\s+com\s+(o\s+)?AGR(-Docs)?\|teatro-abc\|aplica[cç][aã]o\s+no\s+AGR\|onde\s+(isso\s+)?se\s+aplica\s+no\s+AGR)"` | Subtítulo padronizado: `#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC` em todas as seções. |
| **`T3-CONTRAST-04-S-1`** | Spring Security 5 vs 6: `SecurityFilterChain` vs `WebSecurityConfigurerAdapter` | `r"SecurityFilterChain.*WebSecurityConfigurerAdapter\|WebSecurityConfigurerAdapter.*SecurityFilterChain"` | Abordagem profunda na Seção 1 (Remoção da classe abstrata, DSL funcional com lambdas). |
| **`T3-CONTRAST-04-S-2`** | `requestMatchers` vs `antMatchers` | `r"requestMatchers.*antMatchers\|antMatchers.*requestMatchers"` | Abordagem na Seção 1.2 (Prevenção de bypass de autorização e Spring MVC handler alignment). |
| **`T3-CONTRAST-04-S-3`** | OAuth 2.1 & Descontinuação do Password Grant | `r"(Password\s+Grant\|Resource\s+Owner\s+Password).*(descontinuad\|PKCE\|OAuth\s*2\.1)\|OAuth\s*2\.1.*(Password\s+Grant\|PKCE)"` | Abordagem profunda na Seção 4 (Substituição de `grant_type=password` por PKCE em SPAs). |
| **`T3-CONTRAST-04-S-4`** | RBAC Stateless com JWT Claims & `@PreAuthorize` | `r"(@PreAuthorize\|hasAuthority\|hasRole).*(\bJWT\b\|claims?)\|(\bJWT\b\|claims?).*(@PreAuthorize\|hasAuthority\|hasRole)"` | Abordagem profunda na Seção 3 (Custom `JwtAuthenticationConverter`, SpEL e extração de claims). |

---

## 3. Estrutura Canônica & Outline Detalhado do Arquivo

O arquivo `04-seguranca-stateless-oauth2-jwt-rbac.md` deve ser organizado com rigor matemático em **4 grandes seções temáticas**, além de Sumário Executivo e Conclusão:

```
# Módulo 04: Segurança Corporativa Moderna: Stateless OAuth2 Resource Server, JWT e RBAC Fino com Spring Security 6

## Sumário Executivo & Manifesto da Segurança Stateless de Elite
  - A mudança de paradigma: da sessão acoplada em memória para a soberania stateless
  - Princípio do Menor Privilégio e Zero-Trust Architecture
  - O contrato pedagógico em 4 camadas

## 1. Spring Security 6 Architecture & SecurityFilterChain Component-Based
  ### 1.1 A Morte Definitiva do WebSecurityConfigurerAdapter e a Nova DSL com Lambdas
    - Parte 1: O que é o conceito / Analogia Didática (O Porteiro Baseado em Protocolo Modular vs O Porteiro Herdeiro Amarrado)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação AlgaWorks 713_22_11 e a fragilidade do modelo por herança no Spring Boot 2.x)
    - Parte 3: A Solução Moderna de Elite (Código Java 21: @Bean SecurityFilterChain com lambdas fluentes no Spring Security 6.3+)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Refatoração de portalservice :8080 eliminando a herança de WebSecurityConfigurerAdapter)
  ### 1.2 Substituição de antMatchers por requestMatchers & Proteção Contra Bypasses de URL
    - Parte 1: O que é o conceito / Analogia Didática (A Guarita que Lê a Placa do Carro pelo Nome Oficial e Não por Apelidos Ambíguos)
    - Parte 2: A Dor Histórica / O Desastre do Legado (A brecha de segurança CVE-2023-34035 com antMatchers e discrepâncias de barra / trailing slash)
    - Parte 3: A Solução Moderna de Elite (Uso de requestMatchers() integrado ao MvcRequestMatcher do Spring Framework 6.1+)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Proteção das rotas administrativas de fiscalizacaoservice :8082 e receita :8092)
  ### 1.3 Sessões HTTP Stateless vs Stateful & Desativação Consciente do CSRF
    - Parte 1: O que é o conceito / Analogia Didática (O Passaporte Internacional Autocontido vs A Ficha de Papel Guardada na Gaveta do Hotel)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação AlgaWorks 732_23_3 sobre a dissertação de Roy Fielding e a confusão de CSRF em APIs)
    - Parte 3: A Solução Moderna de Elite (SessionCreationPolicy.STATELESS explícito e desativação cirúrgica do CSRF para clientes Bearer token)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Escalabilidade horizontal de instâncias do agrfiscalservice em containers Docker)

## 2. OAuth2 Stateless & JWT Token Architecture
  ### 2.1 Separação Estrita de Papéis: Resource Server vs Authorization Server
    - Parte 1: O que é o conceito / Analogia Didática (A Casa da Moeda / Cartório Emissor vs O Fiscal que Valida a Cédula com Luz Ultravioleta)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação AlgaWorks 708_22_6: a crise da depreciação da antiga stack e a separação dos serviços)
    - Parte 3: A Solução Moderna de Elite (Arquitetura moderna: Spring Authorization Server 1.3+ / Keycloak central vs Resource Servers satélites)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (portalservice :8080 como emissor de identidade e agrfiscalservice :8083 como Resource Server)
  ### 2.2 Assinatura Criptográfica Assimétrica (RSA/JWKS) vs A Vulnerabilidade Simétrica da AGR
    - Parte 1: O que é o conceito / Analogia Didática (O Carimbo Notarial de Chancela Pública vs O Caderno Compartilhado com a Senha de Todo Mundo)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação AlgaWorks 736_23.9 e 738_23.11, e o desastre real do jwt.secret=sw!tch14 hardcoded na AGR)
    - Parte 3: A Solução Moderna de Elite (Configuração do Resource Server com jwk-set-uri, validação via chaves públicas assimétricas RS256 e rotação)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Blindagem dos 25 microsserviços da AGR contra vazamento de chave secreta)
  ### 2.3 Decodificação e Validação Estrita de Claims JWT (iss, exp, aud, nbf, jti)
    - Parte 1: O que é o conceito / Analogia Didática (O Selo Holográfico com Data de Validade e Número de Série Único Anti-Fotocópia)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Tokens sem expiração adequada, ataques de repetição e claims desserializadas com tipagem errônea)
    - Parte 3: A Solução Moderna de Elite (Configuração de NimbusJwtDecoder com JwtValidators, DelegatingOAuth2TokenValidator e checagem de audience)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Validação de jti para evitar replay de QR Codes de ingressos na catraca do Teatro-ABC)

## 3. RBAC & Granular Method Security
  ### 3.1 Mapeamento de Claims Customizadas com JwtAuthenticationConverter
    - Parte 1: O que é o conceito / Analogia Didática (O Tradutor Diplomático que Converte as Condecorações do Passaporte em Permissões Locais)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citação AlgaWorks 869_28.6 sobre a serialização de dados no JWT e conversões manuais falhas)
    - Parte 3: A Solução Moderna de Elite (Implementação de JwtAuthenticationConverter extraindo roles, scopes e authorities customizadas em GrantedAuthority)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Injeção de UsuarioAutenticado contendo CPF, orgao_id e matricula no SecurityContext)
  ### 3.2 Distinção Semântica: SCOPE_ (OAuth2 Delegation) vs ROLE_ (Perfis de Negócio)
    - Parte 1: O que é o conceito / Analogia Didática (O Crachá do Aplicativo Parceiro vs A Carteira Funcional do Servidor Público Concursado)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Endpoints invadidos porque se checou apenas se o client possuía escopo, ignorando o perfil do operador)
    - Parte 3: A Solução Moderna de Elite (Estratégia híbrida de autorização: validação concomitante de SCOPE_ e ROLE_ / authorities granulares)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Diferenciação entre SCOPE_cadu:write para o frontend e ROLE_FISCAL para o usuário no cadu :8081)
  ### 3.3 Controle Fino Declarativo com @EnableMethodSecurity e SpEL Refinado
    - Parte 1: O que é o conceito / Analogia Didática (As Trancas Eletrônicas Individuais em Cada Sala de Cirurgia vs Apenas Uma Tranca na Entrada da Rua)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Verificações manuais getService().validarPermissao(...) espalhadas em dezenas de linhas no controller)
    - Parte 3: A Solução Moderna de Elite (@EnableMethodSecurity com @PreAuthorize, @PostAuthorize, e expressões SpEL checando propriedade de recursos)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Controle de autuação no agrfiscalservice :8083: lavratura de auto restrita ao fiscal titular)

## 4. Transição OAuth 2.1 & Fim do Password Grant
  ### 4.1 A Descontinuação Oficial do Resource Owner Password Credentials Grant
    - Parte 1: O que é o conceito / Analogia Didática (Entregar a Senha do Seu Cartão de Banco para o Garçom da Lanchonete vs Inserir o Chip na Maquininha)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Citações AlgaWorks 709_22.7 e 869_28.6: o ensino do grant_type=password e seu banimento formal no OAuth 2.1)
    - Parte 3: A Solução Moderna de Elite (Por que o OAuth 2.1 baniu o Password Grant: eliminação do phishing corporativo e suporte obrigatório a MFA/Gov.br)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Migração do login do Portal do Cidadão e Portal do Servidor para OpenID Connect padrão)
  ### 4.2 Authorization Code Flow com PKCE (RFC 7636) para SPAs e Aplicações Móveis
    - Parte 1: O que é o conceito / Analogia Didática (O Enigma Secreto em Duas Etapas: O Código Criptográfico Compartilhado sem Revelar a Resposta de Antemão)
    - Parte 2: A Dor Histórica / O Desastre do Legado (O fluxo Implicit Grant vazando tokens na barra de navegação/URL e a vulnerabilidade de interceptação de auth code)
    - Parte 3: A Solução Moderna de Elite (Mecânica do PKCE: code_verifier e code_challenge SHA-256 no Angular 18+ com chave pública sem client_secret)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (Autenticação do frontend Angular do agrfiscalservice e da bilhetagem do Teatro-ABC)
  ### 4.3 Client Credentials Flow para Comunicação Segura Machine-to-Machine (M2M)
    - Parte 1: O que é o conceito / Analogia Didática (O Contrato Diplomático Intergovernamental com Chaves Seguras Troçadas nos Bastidores)
    - Parte 2: A Dor Histórica / O Desastre do Legado (Microsserviços chamando outros sem autenticação ou forjando tokens com dados de usuários fantasmas)
    - Parte 3: A Solução Moderna de Elite (Uso de client_credentials grant no Spring Security 6 com RestClient autenticado via OAuth2AuthorizedClientManager)
    - Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC (agrfiscalservice :8083 solicitando geração de DARE para o receita :8092 via M2M seguro)

## Conclusão & Próximos Passos
  - Checklist de Segurança Zero-Trust para Microsserviços
  - Tabela Comparativa de Transição: Legado vs Moderno de Elite
  - Orientações de Transição para o Módulo 05 (Frontend Angular)
```

---

## 4. Conteúdo Substantivo, Transcrições Literais AlgaWorks & Evidências Técnicas

### 4.1 Transcrições Literais AlgaWorks (Citações Forenses)

Para cada conceito central, a documentação canônica deve ancorar a "Dor Histórica" nas transcrições reais do acervo AlgaWorks:

#### Transcrição 1: A Morte do Spring Security OAuth e a Transição para a Nova Stack
* **Arquivo Fonte:** `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/708_22_6_Soluções_para_OAuth2_nova_stack_do_Spring_Security_vs_Spring.txt`
* **Trechos Literais Obrigatórios:**
  > *"Até a pouco tempo atrás a opção que a gente tinha quando a gente desenvolveu uma API com Spring para usar o OAuth era o Spring Security OAuth. Então o Spring Security OAuth ele dá suporte tanto para implementar o Resource Server como para implementar o Authorization Server. Porém, começou um movimento dos desenvolvedores do Spring para portar o código... A ideia deles é depreciar, é matar um dia esse projeto Spring Security OAuth... Aí quando eles lançaram a versão 5.2 do Spring Security... Eles informaram que agora o Spring Security já portou todas as funcionalidades essenciais do Resource Server, então não precisa mais usar o Spring Security OAuth... Só que eles informaram que não vai ter mais suporte a Authorization Server no Spring Security... Como que a comunidade ficou? Ela ficou assim: beleza, se eu não vou ter o suporte ao Authorization Server, vou ter que usar um Authorization Server de um terceiro... Mas a comunidade reclamou, não gostou disso... Depois de tanta gente dando feedback negativo para eles, eles adicionaram um update... Devido a esse feedback e algumas discussões internas, nós vamos dar uma olhada novamente nessa decisão..."* (Linhas 13-52).

#### Transcrição 2: O Perigo e a Insegurança do Resource Owner Password Credentials Grant
* **Arquivo Fonte:** `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/709_22.7. Conhecendo o fluxo Resource Owner Password Credentials.txt`
* **Trechos Literais Obrigatórios:**
  > *"O fluxo resource owner password credentials grant é uma forma de obter um access token, ou seja, um token de acesso a partir de um usuário e senha. Ou seja, você troca um usuário senha em troca de um access token... O client vai passar no corpo da requisição o username e o password do resource owner... E vai passar também um campo grant_type igual a password... O client não deve armazenar o usuário senha... Ele deve usar apenas uma vez para trocar esse usuário senha em troca do access token, pronto, acabou... Agora, esse cliente aqui pode ser qualquer tipo de cliente? Não, não é recomendado que seja qualquer tipo de cliente... No caso do AlgaFood, por exemplo, a gente não poderia permitir que esse cliente aqui fosse de uma outra empresa qualquer... Porque esses clientes não são confiáveis... E aí os usuários do AlgaFood ter que digitar o usuário e senha em uma aplicação desconhecida é um risco de segurança... Mesmo que o cliente seja seu, você desenvolveu a API e o cliente é seu também. Ainda assim, esse fluxo é desencorajado pelo pessoal do OAuth... Evite usar esse fluxo aqui..."* (Linhas 8-43, 99-121).

#### Transcrição 3: A Atualização para Spring Boot 3, Spring Authorization Server e EnableMethodSecurity
* **Arquivo Fonte:** `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/869_28.6. Atualizando o Spring Authorization Server.txt`
* **Trechos Literais Obrigatórios:**
  > *"Nessa aula aqui vamos realizar as alterações e a atualização do Spring Authorization Server para que ele fique compatível com o Spring Boot 3.0... Aqui no Resource Server, devido a algumas alterações no próprio Spring e no Spring Security, essa configuração aqui vai precisar ser reescrita... E aqui em cima, essa anotação sofreu uma alteração também de nome: basta utilizar agora esse EnableMethodSecurity e não EnableGlobalMethodSecurity, mas o comportamento continua o mesmo... Aqui embaixo no RequestMatcher, ele sofreu uma alteração também... Agora vamos passar aqui, antes de tudo, o SecurityMatcher... E aqui na autenticação dos endpoints: authorizeHttpRequests... Nessa classe aqui temos um problema de serialização na hora de buscar o usuário ID do nosso token... Long.valueOf(usuarioId.toString()) porque na mais recente versão do JWT está tudo sendo serializado como String e não mais como um Long..."* (Linhas 2-21, 39-44, 66-77).

#### Transcrição 4: A Herança Legada do WebSecurityConfigurerAdapter
* **Arquivo Fonte:** `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/713_22_11_Configurando_o_Resource_Server_com_a_nova_stack_do_Spring.txt`
* **Trechos Literais Obrigatórios:**
  > *"Vou renomear essa classe aqui para ResourceServerConfig. Beleza. Ela vai continuar herdando aqui o WebSecurityConfigurerAdapter... Bom, esse método aqui para configurar os usuários e senhas para a autenticação, a gente não precisa no Resource Server. Quem faz isso é o Authorization Server..."* (Linhas 26-32).

#### Transcrição 5: A Separação entre Estado da Aplicação e Estado do Recurso (Stateless REST)
* **Arquivo Fonte:** `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/732_23_3_Entendendo_a_diferença_entre_Stateful_e_Stateless_Authentication.txt`
* **Trechos Literais Obrigatórios:**
  > *"Na dissertação do Roy Fielding, ele diz que uma das constraintes para ser considerado REST é que a comunicação tem que ser Stateless... Ele escreveu assim: a comunicação deve ser Stateless, ou seja, sem estado, por natureza, de forma que cada requisição do cliente para o servidor deve conter as informações necessárias para entendê-la e não pode usar informações contextuais armazenadas no servidor. O estado da sessão deve ser armazenado inteiramente no cliente... Vamos separar entre Application State e Resource State. O que Roy diz que deve ser Stateless é o estado da aplicação..."* (Linhas 5-30).

#### Transcrição 6: A Assinatura Assimétrica com RSA e Chave Pública
* **Arquivo Fonte:** `/mnt/dados/00_Inbox_Triagem/AlgaWorks/transcricoes/txt/736_23.9. Assinando o JWT com RSA SHA-256 (chave assimétrica).txt` e `738_23.11. Extraindo a chave pública no formato PEM.txt`
* **Trechos Literais Obrigatórios:**
  > *"Para assinar um JWT, a gente assina usando a chave privada... Para validar o token JWT, a validação é feita com a chave pública... Se todos os desenvolvedores estão usando esse arquivo JKS para assinar seus tokens em tempo de desenvolvimento, quando você for para produção é legal que você gere um outro par de chaves para não correr risco... Um certificado contém a chave pública... A chave pública é a chave criptográfica que precisamos para validar a assinatura do JWT..."* (736: Linhas 10-23; 738: Linhas 7-19).

---

### 4.2 Código Java 21 & Spring Security 6.3+ de Elite (Modelos Canônicos Completos)

O implementador do Módulo 04 deverá obrigatoriamente fornecer implementações completas, limpas, fortemente tipadas e sem omissões dos seguintes blocos de engenharia:

#### 1. Configuração do SecurityFilterChain (Resource Server Stateless)
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
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
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
            .csrf(AbstractHttpConfigurer::disable)
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(authorize -> authorize
                // Endpoints públicos de documentação e observabilidade
                .requestMatchers("/actuator/health", "/actuator/info").permitAll()
                .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                // Endpoints públicos da bilhetagem do Teatro-ABC
                .requestMatchers(HttpMethod.GET, "/api/v1/espetaculos/**").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/v1/sessoes/*/mapa-assentos").permitAll()
                // Bloqueio rigoroso de endpoints administrativos e fiscais por escopo ou autenticação
                .requestMatchers("/api/v1/autos-infracao/**").hasAuthority("SCOPE_fiscalizacao:write")
                .requestMatchers("/api/v1/cadastros/**").hasAuthority("SCOPE_cadu:read")
                .anyRequest().authenticated()
            )
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

#### 2. `JwtAuthenticationConverter` Customizado (Extração Híbrida: Scopes, Roles e Permissões)
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
import java.util.stream.Collectors;

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
        return new JwtAuthenticationToken(jwt, authorities, jwt.getClaimAsString("sub"));
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
                if (scope != null) {
                    authorities.add(new SimpleGrantedAuthority("SCOPE_" + scope.toString()));
                }
            }
        }
    }

    private void extractRoles(Jwt jwt, Set<GrantedAuthority> authorities) {
        List<String> roles = jwt.getClaimAsStringList(CLAIM_ROLES);
        if (roles != null) {
            for (String role : roles) {
                String roleName = role.startsWith("ROLE_") ? role : "ROLE_" + role;
                authorities.add(new SimpleGrantedAuthority(roleName));
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

#### 3. Configuração de Validação Criptográfica Assimétrica (RSA / JWKS Decoder)
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
public class JwtDecoderConfig {

    @Value("${spring.security.oauth2.resourceserver.jwt.jwk-set-uri}")
    private String jwkSetUri;

    @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}")
    private String expectedIssuer;

    @Value("${agr.security.jwt.expected-audience:agr-api-gateway}")
    private String expectedAudience;

    @Bean
    public JwtDecoder jwtDecoder() {
        // Inicializa o NimbusJwtDecoder apontando para o JWK Set URI do Authorization Server
        NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder.withJwkSetUri(this.jwkSetUri).build();

        // Validador padrão do Spring (valida timestamp de expiração 'exp' e 'nbf')
        OAuth2TokenValidator<Jwt> defaultValidator = JwtValidators.createDefaultWithIssuer(this.expectedIssuer);

        // Validador customizado de Audience ('aud') para impedir uso de token de outro cliente
        OAuth2TokenValidator<Jwt> audienceValidator = new JwtAudienceValidator(this.expectedAudience);

        // Agrupamento de validadores em cadeia
        OAuth2TokenValidator<Jwt> delegatingValidator = new DelegatingOAuth2TokenValidator<>(
            List.of(defaultValidator, audienceValidator)
        );

        jwtDecoder.setJwtValidator(delegatingValidator);
        return jwtDecoder;
    }
}
```

#### 4. Controlador REST Demonstrando `@PreAuthorize` e Expressões SpEL Avançadas
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

#### 5. Configuração de Comunicação Machine-to-Machine (M2M) com Client Credentials e `RestClient`
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

---

### 4.3 Diagramas Arquiteturais em ASCII

#### Diagrama 1: A Cadeia de Filtros do Spring Security 6 (Stateless Execution Flow)
```
REQUISIÇÃO HTTP ENTRANTE (com cabeçalho: Authorization: Bearer <JWT>)
  │
  ▼
┌────────────────────────────────────────────────────────────────────────┐
│                      SPRING SECURITY FILTER CHAIN                      │
│                                                                        │
│ 1. CorsFilter: Valida origin, methods e headers (pre-flight OPTIONS)   │
│    │                                                                   │
│ 2. CsrfFilter: DESABILITADO (Zero Cookies / Stateless Bearer)          │
│    │                                                                   │
│ 3. SecurityContextHolderFilter: Cria contexto vazio (sem HttpSession)   │
│    │                                                                   │
│ 4. BearerTokenAuthenticationFilter:                                    │
│    ├── Extrai cabeçalho 'Authorization: Bearer ...'                    │
│    ├── Invoca NimbusJwtDecoder (chama JWKS /.well-known/jwks.json)     │
│    ├── Valida assinatura criptográfica RS256 e expiração (exp, nbf)   │
│    └── Invoca CustomJwtAuthenticationConverter                         │
│        ├── Converte claims 'scope' -> GrantedAuthority (SCOPE_...)     │
│        ├── Converte claims 'roles' -> GrantedAuthority (ROLE_...)      │
│        └── Cria JwtAuthenticationToken no SecurityContextHolder        │
│    │                                                                   │
│ 5. AuthorizationFilter (substituto do FilterSecurityInterceptor):      │
│    └── Valida regras do requestMatchers() declaradas no bean           │
│                                                                        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼
              DISPATCHER SERVLET -> CONTROLLER REST
                                   │
                   [ AOP / MethodSecurityInterceptor ]
                   Verifica @PreAuthorize("hasAuthority(...)")
                                   │
                                   ▼
                         MÉTODO DE NEGÓCIO EXECUTADO
```

#### Diagrama 2: Topologia OAuth2: Authorization Server (JWKS) vs Resource Server
```
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

#### Diagrama 3: OAuth 2.1 Authorization Code Flow com PKCE (SPA Angular)
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

---

### 4.4 Mapeamento Real no Ecossistema AGR-Docs e Laboratório Teatro-ABC

| Sistema / Microsserviço | Papel Arquitetural OAuth2 | Mecanismo de Autenticação & Validação | Regras de RBAC & Permissões Críticas |
| :--- | :--- | :--- | :--- |
| **`portalservice` (:8080)** | **Authorization Server Central & Gateway** | Emissão de tokens JWT assinados com Chave Privada RSA (RS256). Expõe endpoint `/.well-known/jwks.json`. | Emite claims: `sub` (CPF), `orgao_id`, `roles` (`ROLE_FISCAL`, `ROLE_ADMIN`), `permissoes` (`FISCALIZACAO_LAVRAR_AUTO`, `CADU_EDITAR`). |
| **`agrfiscalservice` (:8083)** | **Resource Server Crítico** | Valida tokens via JWKS de `:8080`. Sem sessão (`STATELESS`). Custom `JwtAuthenticationConverter`. | `@PreAuthorize("hasAuthority('FISCALIZACAO_LAVRAR_AUTO')")`. ABAC com SpEL checando se o fiscal é o titular da lavratura do auto. |
| **`cadu` (:8081)** | **Resource Server de Cadastro Mestre** | Valida tokens via JWKS. Isola leitura pública de concessionárias da escrita de frotas. | `@PreAuthorize("hasAuthority('SCOPE_cadu:read')")` para consulta de veículos; `@PreAuthorize("hasRole('ADMIN')")` para cadastro de empresas. |
| **`receita` (:8092)** | **Resource Server Financeiro** | Valida tokens de usuário interativo e tokens M2M emitidos via Client Credentials. | `@PreAuthorize("hasAuthority('SCOPE_receita:write')")`. Comunicação máquina-a-máquina vinda do fiscal para emissão de guias DARE. |
| **`teatro-abc` (:8090)** | **Greenfield Showcase de Ingressos** | Resource Server duplo: endpoints públicos de espetáculos vs endpoints protegidos de reservas e catraca. | `permitAll()` para mapa de assentos; `@PreAuthorize("hasRole('CLIENTE')")` para compra; `@PreAuthorize("hasAuthority('PORTARIA_VALIDAR')")` para catraca com validação de `jti`. |

---

## 5. Guia de Implementação e Instruções para o Worker M4

Ao redigir o arquivo `/home/lan/dotfiles/templates-lab/docs/04-seguranca-stateless-oauth2-jwt-rbac.md`, o agente implementador deverá seguir rigorosamente as seguintes diretrizes:

1. **Atendimento aos Tiers do Validador:**
   - Executar `python3 scripts/verify_docs_suite.py --tier 3` e garantir 100% de aprovação para o módulo 04.
   - Garantir tamanho superior a **1.000 linhas** de conteúdo substantive (o teste exige `> 300`, mas o padrão de qualidade do projeto estabelecido nos módulos 01 e 02 opera acima de 1.000 linhas).
   - Não utilizar nenhuma ocorrência de `TODO`, `FIXME`, `[TBD]`, `implementar depois` ou `em breve`.
   - Não deixar reticências bare (`...`) em blocos de código. Todo bloco Java, JSON, SQL ou Bash deve ser completo e explicativo.

2. **Rigor Pedagógico em 4 Camadas:**
   - Toda seção principal (1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3, 4.1, 4.2, 4.3) deve conter explicitamente os 4 subtítulos:
     - `#### Parte 1: O que é o conceito / Analogia Didática`
     - `#### Parte 2: A Dor Histórica / O Desastre do Legado`
     - `#### Parte 3: A Solução Moderna de Elite`
     - `#### Parte 4: Vínculo Direto com o AGR-Docs / Teatro-ABC`

3. **Citações e Dores Históricas Obrigatórias:**
   - Incluir as citações literais das aulas `708_22_6`, `709_22.7`, `869_28.6`, `713_22_11`, `732_23_3` e `736_23.9` transcritas na Seção 4.1 deste relatório.
   - Contrastar enfaticamente a falha de segurança real da AGR (`jwt.secret=sw!tch14`) com a solução moderna de chaves assimétricas RSA/JWKS.

4. **Código Java 21 & Spring Boot 3.3+:**
   - Adotar exclusivamente a sintaxe de lambdas fluentes do Spring Security 6.
   - Declarar explicitamente imports completos e corretos em cada arquivo Java apresentado.
"""

report_path.write_text(content, encoding="utf-8")
print(f"Report written successfully to {report_path} ({len(content.splitlines())} lines, {len(content)} bytes)")

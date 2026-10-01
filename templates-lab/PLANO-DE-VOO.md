# 🗺️ PLANO DE VOO: RECONSTRUÇÃO ARQUITETURAL AGR & TEATRO-ABC
## *(Roteiro Mestre Sequencial do Laboratório de Prática Deliberada)*

> **PROPÓSITO DESTE DOCUMENTO:**  
> Servir como o mapa de navegação definitivo para o desenvolvedor reconstruir, do zero absoluto, os domínios essenciais da AGR e o projeto Greenfield do Teatro-ABC com as melhores práticas de Engenharia de Software de Elite (Top 5% Global).
> Cada fase é autocontida, com entregáveis claros, testes e critérios de pronto.

---

## 🧭 VISÃO GERAL DAS 6 FASES

```
[FASE 1: Fundação & Auth Central]
       │ (portalservice -> auth, RBAC, JWT, Clean Arch)
       ▼
[FASE 2: Cadastro Mestre Unificado]
       │ (cadu -> PF, PJ, Veículos, Validações, Flyway)
       ▼
[FASE 3: Fiscalização & Cadeia Probatória]
       │ (fiscalizacao -> Vistorias, MinIO/S3, Laudos Jasper)
       ▼
[FASE 4: Gateways & Resiliência Externa]
       │ (seiservice / base-cidadao -> Circuit Breakers, ACL)
       ▼
[FASE 5: Regulação Econômica & Arrecadação]
       │ (receitaservice -> DARE, TRCF, TUT, Baixa Contábil)
       ▼
[FASE 6: Greenfield Puro - Bilhetagem & Lotação]
         (teatro-abc -> Salas, Assentos, Concorrência, QR Code)
```

---

## 🚀 FASE 1: FUNDAÇÃO, AUTENTICAÇÃO E CLEAN ARCHITECTURE
* **Inspiração Real:** `portalservice` (Porta :8080)
* **Objetivo de Negócio:** Permitir login seguro, gestão de perfis regulatórios (Fiscal, Administrador, Regulado) e emissão de tokens JWT.
* **O Que Vamos Eliminar do Legado:** Sessão acoplada, filtros manuais confusos, dependências circulares do Spring.
* **Entregáveis Práticos:**
  1. Setup do projeto Maven/Gradle com Spring Boot 3.x e Java 17+.
  2. Configuração do Docker Compose inicial (PostgreSQL ou MySQL 8 + PgAdmin).
  3. Estrutura de pacotes em **Clean Architecture (Hexagonal)**:
     - `domain`: `Usuario`, `Perfil`, `Permissao`, regras puras.
     - `application`: Casos de uso (`AutenticarUsuarioUseCase`, `CadastrarUsuarioUseCase`).
     - `infrastructure`: Adaptadores Spring Security, JWT (`jjwt`), Spring Data JPA, BCrypt.
     - `interfaces`: REST Controllers com tratamento global de erros (`@RestControllerAdvice`).
  4. Teste de ponta a ponta: Gerar token JWT e acessar endpoint protegido.

---

## 🏛️ FASE 2: CADASTRO MESTRE UNIFICADO (CADU)
* **Inspiração Real:** `cadastrounicoservice` (Porta :8081)
* **Objetivo de Negócio:** Centralizar a base canônica de Pessoas Físicas (Fiscais/Motoristas), Pessoas Jurídicas (Concessionárias/Empresas de Ônibus) e Frotas (Veículos).
* **O Que Vamos Eliminar do Legado:** `GenericDAOIMPL`, falta de validação de CPF/CNPJ, SQL manual misturado com regra de negócio.
* **Entregáveis Práticos:**
  1. Migrations versionadas com **Flyway** (`V1__criar_tabelas_cadu.sql`).
  2. Value Objects ricos: `Cpf`, `Cnpj`, `PlacaVeiculo` com validação no construtor.
  3. Repositórios **Spring Data JPA** tipados com paginação (`Pageable`) e buscas dinâmicas com Specifications.
  4. Mapeamento de DTOs usando **Java Records** e **MapStruct** (zero vazamento de entidades para a web).
  5. Front-end Angular: Tela de listagem e formulário com validações reativas customizadas (`CpfValidator`).

---

## 🔍 FASE 3: FISCALIZAÇÃO, VISTORIAS E CADEIA PROBATÓRIA
* **Inspiração Real:** `fiscalizacaoservice` (:8082) e `bens-desestatizados` (:8097)
* **Objetivo de Negócio:** Fiscais em campo registram infrações/constatações com fotos de evidências e geram autos com QR Code.
* **O Que Vamos Eliminar do Legado:** Armazenamento em storage SMB local de Windows (`10.6.63.2`), perda de imagens, compilação de relatórios sem rastreabilidade.
* **Entregáveis Práticos:**
  1. Módulo de Vistoria: Entidades `Vistoria`, `Constatacao`, `EvidenciaFotografica`.
  2. **Storage de Objetos Moderno:** Integrar com MinIO local (compatível com S3) via SDK, gerando URLs temporárias pré-assinadas para visualização segura.
  3. Motor de Relatórios: Geração de PDF via JasperReports embutido contendo fotos e QR Code de autenticidade (ZXing).
  4. Auditoria Imutável: Tabela de logs com data/hora, autor do auto e hash SHA-256 do documento.

---

## ⚡ FASE 4: GATEWAYS, ACL E RESILIÊNCIA EXTERNA
* **Inspiração Real:** `seiservice` (:8111) e `base-cidadao` (:8102)
* **Objetivo de Negócio:** Isolar chamadas externas para órgãos públicos (Processo Eletrônico SEI e Barramento SGG).
* **O Que Vamos Eliminar do Legado:** Chamadas síncronas que travam a aplicação se o SEI cair, dependência de `IP_BACK_OLD`.
* **Entregáveis Práticos:**
  1. **Camada Anti-Corrupção (ACL):** Isolar os payloads externos através de Adaptadores dedicados.
  2. **Resiliência com Resilience4j:** Implementar *Circuit Breaker*, *Retry com Exponential Backoff* e *Fallback* para chamadas externas.
  3. Consumo de APIs com `WebClient` reativo do Spring.

---

## 💰 FASE 5: REGULAÇÃO ECONÔMICA E ARRECADAÇÃO (DARE)
* **Inspiração Real:** `receitaservice` (:8092)
* **Objetivo de Negócio:** Apurar faturamento regulado (TRCF/TUT), lavrar multas pecuniárias e emitir guia de arrecadação (DARE).
* **O Que Vamos Eliminar do Legado:** Cálculos espalhados em controllers, falta de conciliação bancária.
* **Entregáveis Práticos:**
  1. Motor de Cálculo Tarifário: Regras de negócio puras (Strategy Pattern) para TRCF, TUT e Multas com desconto de pontualidade.
  2. Emissão do DARE: Geração de linha digitável (código de barras Febraban) e Payload PIX Copia-e-Cola com QR Code dinâmico.
  3. Simulação de Retorno Bancário: Endpoint de webhook para processar baixa de pagamento e alterar o status da notificação para "PAGO".

---

## 🎭 FASE 6: GREENFIELD PURO — TEATRO-ABC (BILHETAGEM & LOTAÇÃO)
* **Projeto:** Sistema Completo do Centro Cultural Oscar Niemeyer / Teatro-ABC
* **Objetivo de Negócio:** Gestão de espetáculos, mapas de assentos em tempo real, prevenção de venda duplicada e validação de ingressos na portaria.
* **Entregáveis Práticos:**
  1. **Modelagem de Domínio:** `Espetaculo`, `Sessao`, `Sala`, `SetorPlateia`, `Assento`, `Ingresso`, `Reserva`.
  2. **Controle de Concorrência Crítico:**
     - Bloqueio temporário de assento (lock pessimista ou Redis com TTL de 10 minutos).
     - Garantir que duas pessoas não comprem a mesma poltrona ao mesmo tempo em picos de venda.
  3. **Ingresso Criptográfico:** Emissão de ingresso com JWT assinado no payload do QR Code.
  4. **App/Tela do Validador de Portaria:** Leitor de QR Code que dá baixa no ingresso instantaneamente e detecta tentativas de fraude / segunda entrada.
  5. **Painel de Ocupação:** Dashboard visual com percentual de assentos vendidos por sessão.

---

## 🎓 COMO AVANÇAR
Cada etapa acima será executada no formato **Dojo (Driver & Navigator)**:
- Você sempre saberá em qual Fase e Tarefa estamos consultando o [ESTADO-ATUAL.md](file:///ESTADO-ATUAL.md).
- O agente nunca pulará etapas nem despejará código pronto.

# 🔬 PROTOCOLO DE ENGENHARIA REVERSA, MEGADOCS & SCANNER AUTOMATIZADO

Este protocolo estabelece o fluxo oficial de engenharia reversa dos microsserviços da AGR, integrando o scanner determinístico aos comandos do chat para máxima economia de tokens de IA.

---

## ⚡ COMANDOS RÁPIDOS NO CHAT DO ANTIGRAVITY

| Comando | Escopo do Mapeamento | Destino no `agr-docs` |
| :--- | :--- | :--- |
| `/goal mapear fase 1` | Visão Geral, Arquitetura, Topologia e Stack Tecnológica | `projetos/<slug>/docs/01-visao-geral-e-arquitetura.md` |
| `/goal mapear fase 2` | Modelo de Dados, Entidades JPA, Dicionário e Mermaid ER | `projetos/<slug>/docs/02-modelo-de-dados-e-entidades.md` |
| `/goal mapear fase 3` | Catálogo REST, Endpoints, JasperReports (.jrxml) e Regras | `projetos/<slug>/docs/03-catalogo-de-apis-e-endpoints.md`<br>`05-regras-de-negocio-e-fluxos.md` |
| `/goal mapear fase 4` | Frontend Angular, Rotas, Telas, Grids e Formulários | `projetos/<slug>/docs/04-frontend-rotas-e-componentes.md`<br>`README.md` |
| `/goal mapear queries` | Todas as @Query JPQL/SQL nativas dos DAOs e Repositories | `projetos/<slug>/docs/06-queries-e-consultas-dao.md` |
| `/goal mapear dump` | Schema MySQL real dos dumps SQL (tipos exatos, FKs, índices) | `projetos/<slug>/docs/07-schema-mysql-real.md` |
| `/goal mapear cross` | Cruzamento Front↔Back: endpoints mortos, 404, paridade | `projetos/<slug>/docs/08-cruzamento-front-back.md` |
| `/goal mapear enums` | Enums Java: vocabulário de negócio, constantes e descrições | `projetos/<slug>/docs/09-enums-vocabulario-negocio.md` |
| `/goal mapear dtos` | DTOs / Payloads de transferência: campos e obrigatoriedade | `projetos/<slug>/docs/10-dtos-transferencia-dados.md` |
| `/goal mapear security` | Segurança, perfis, @PreAuthorize, @Secured e roles | `projetos/<slug>/docs/11-seguranca-perfis-acesso.md` |
| `/goal mapear interservice` | Integrações inter-serviço: Feign Clients, RestTemplate, URLs | `projetos/<slug>/docs/12-integracoes-inter-servico.md` |
| `/goal mapear config` | Configurações do sistema: application.properties / YAML | `projetos/<slug>/docs/13-configuracoes-application.md` |
| `/goal mapear validators` | Validações do frontend: Angular Reactive Forms & Validators | `projetos/<slug>/docs/14-validacoes-frontend.md` |
| `/goal mapear scheduled` | Tarefas agendadas: @Scheduled, cron jobs e frequências | `projetos/<slug>/docs/15-tarefas-agendadas.md` |
| `/goal gerar megadoc` | Consolida e hierarquiza todos os 15 módulos para NotebookLM | `projetos/<slug>/docs/MEGADOC-<slug>.md` |
| `/goal mapear tudo` | Executa todos os 15 módulos sequencialmente + Megadoc | Todos os artefatos acima |
| `/goal mapear lote` | Escaneia TODOS os projetos do Portal 1 e 2 de uma vez | `projetos/*/docs/` |

---

## 🚀 FERRAMENTA DETERMINÍSTICA AUTOMATIZADA (AGR SCANNER)

> [!IMPORTANT]
> **REGRA DE OURO PARA A IA / ANTIGRAVITY:**  
> **NUNCA faça varredura manual de dezenas de arquivos Java, XML ou TypeScript gastando tokens do usuário!**  
> Para qualquer um dos comandos acima, a IA DEVE executar imediatamente a ferramenta oficial:
> 
> ```powershell
> # A partir da raiz do agr-docs:
> .\agr.ps1 scanner <fase> <SISTEMA>
> # Fases disponíveis:
> # 1, 2, 3, 4, queries, dump, cross, enums, dtos, security,
> # interservice, config, validators, scheduled, megadoc, tudo
> 
> # Exemplos:
> .\agr.ps1 scanner 3 dare
> .\agr.ps1 scanner tudo fiscalizacao
> .\agr.ps1 scanner queries DARE
> .\agr.ps1 scanner cross fiscalizacao
> .\agr.ps1 scanner enums fiscalizacao
> .\agr.ps1 scanner security fiscalizacao
> 
> # Modo LOTE (todos os projetos de uma vez):
> .\agr.ps1 lote
> .\agr.ps1 scanner lote
> 
> # OU diretamente via Node:
> node scripts/tools/agr-scanner.js --fase <fase> --project <caminho_ou_nome>
> ```

---

## 📋 ARTEFATOS GERADOS PELO SCANNER (15 MÓDULOS)

| # | Arquivo | Conteúdo |
| :---: | :--- | :--- |
| 01 | `01-visao-geral-e-arquitetura.md` | Topologia, stack, dependências, portas |
| 02 | `02-modelo-de-dados-e-entidades.md` | Entidades JPA, campos, @Id, Mermaid ER |
| 03 | `03-catalogo-de-apis-e-endpoints.md` | Controllers REST, endpoints, mapeamentos |
| 04 | `04-frontend-rotas-e-componentes.md` | Rotas Angular, módulos, componentes |
| 05 | `05-regras-de-negocio-e-fluxos.md` | Services, JasperReports, regras |
| 06 | `06-queries-e-consultas-dao.md` | @Query JPQL/SQL, constantes SQL nos DAOs |
| 07 | `07-schema-mysql-real.md` | CREATE TABLE do dump real, tipos MySQL exatos |
| 08 | `08-cruzamento-front-back.md` | Paridade endpoints, código morto, 404 potencial |
| 09 | `09-enums-vocabulario-negocio.md` | Enums Java, constantes, vocabulário do domínio |
| 10 | `10-dtos-transferencia-dados.md` | DTOs, campos de request/response, obrigatoriedades |
| 11 | `11-seguranca-perfis-acesso.md` | Roles, @PreAuthorize, @Secured, regras de URL |
| 12 | `12-integracoes-inter-servico.md` | Feign Clients, RestTemplate, WebClient, URLs externas |
| 13 | `13-configuracoes-application.md` | application.properties/yml categorizados (senhas ofuscadas) |
| 14 | `14-validacoes-frontend.md` | Angular Reactive Forms, Validators por campo |
| 15 | `15-tarefas-agendadas.md` | @Scheduled, cron expressions, frequências |
| MEGA | `MEGADOC-<slug>.md` | Consolidação unificada dos 15 módulos para IA e NotebookLM |

---

## 🎯 FLUXO DE EXECUÇÃO OBRIGATÓRIO: PROTOCOLO HÍBRIDO (SCANNER + IA DRIVER)

A IA **NUNCA** deve apenas rodar o script e entregar o arquivo bruto sem análise. O modelo oficial da AGR é uma parceria de alta performance:

```
┌─────────────────────────────────┐       ┌─────────────────────────────────┐
│     AGR SCANNER (Determinístico) │  ───> │       IA COMO DRIVER FORENSE    │
│  - Extrai 100% da estrutura     │       │  - Analisa casos fora do comum │
│  - 0 tokens gastos em parsing   │       │  - Traduz lógica para regra AGR│
│  - Mapeia 15 módulos sem errar  │       │  - Modela fluxos de negócio    │
└─────────────────────────────────┘       └─────────────────────────────────┘
```

### 📋 Passo a Passo Que a IA DEVE Seguir:

#### 1. Execução do Scanner (Fundação Factual)
Ao receber qualquer comando `/goal mapear ...`, execute imediatamente o `agr-scanner` correspondente. Ele garante que **nenhuma tabela, query, endpoint, enum ou rota seja esquecida**.

#### 2. Diagnóstico de Densidade & Pontos Fora do Comum
A IA inspeciona o Markdown gerado e localiza onde estão as lógicas mais densas e anomalias:
* Services com múltiplos métodos `@Transactional` ou regras de alteração de status.
* Queries nativas complexas com `JOIN`s extensos ou cálculos de penalidades.
* Endpoints marcados como órfãos ou com potencial 404 no módulo 08.
* Relatórios Jasper com consultas embutidas ou lógicas condicionais (`printWhenExpression`).
* Validações no frontend que podem estar faltando no backend.

#### 3. Drill-Down Cirúrgico no Código Fonte
A IA abre **apenas** os arquivos e métodos críticos identificados (usando leitura cirúrgica com `StartLine`/`EndLine` para economizar tokens):
* Decodifica a lógica de negócio por trás do código (o "Por quê").
* Identifica exceções à regra, lógicas legadas, prazos processuais e cálculos regulatórios.
* Detecta dívidas técnicas, gambiarras e comportamentos não óbvios.

#### 4. Enriquecimento Semântico no Documento
A IA adiciona ao documento Markdown gerado seções de alto valor analítico:
* **🧠 Regras de Negócio Decodificadas:** Explicação em português claro de como a regra regulatória da AGR funciona no mundo real.
* **📊 Diagramas de Sequência / Estados (Mermaid):** Mapeamento do ciclo de vida dos processos (ex: `LAVRADO` ➔ `NOTIFICADO` ➔ `DEFESA` ➔ `JULGADO` ➔ `PAGO`).
* **⚠️ Casos Fora do Comum & Dívidas Técnicas:** Documentação de exceções e pontos de atenção para a reescrita em Clean Architecture.

#### 5. Consolidação no MEGADOC
Garante que o `MEGADOC-<slug>.md` contenha tanto os **dados determinísticos exaustivos** do scanner quanto as **análises de negócio da IA**, gerando a base definitiva para o Google NotebookLM e o time de reescrita.


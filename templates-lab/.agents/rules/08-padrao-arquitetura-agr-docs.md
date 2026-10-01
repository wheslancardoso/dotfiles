# 🏛️ ARQUITETURA, PADRÕES E DIRETRIZES DO REPOSITÓRIO AGR-DOCS

> **FINALIDADE:** Esta regra orienta qualquer instância de IA (Antigravity, Claude Code, Gemini) operando dentro do repositório `agr-docs`.
> Define a topologia exata de diretórios, regras de manutenção, criação de tarefas, economia de tokens e comandos operacionais.

---

## 🧭 1. PAPEL E ESCOPO DO AGR-DOCS

O `agr-docs` é o **centro nevrálgico de engenharia de software da AGR**.
Ele **NÃO** contém o código-fonte de produção de cada microsserviço (estes residem em `../Portal-2/` e `../Portal-1/`).
O `agr-docs` centraliza:
1. **Documentações de Arquitetura e Engenharia Reversa** de todos os 25 sistemas do Portal 2 e Portal 1.
2. **Dumps Oficiais SQL** de todos os bancos de dados do MySQL (`10.243.1.27`).
3. **Suíte Mestre de Testes E2E (End-to-End)** rodando Puppeteer-Core + Microsoft Edge sem dependências pesadas.
4. **CLI Mestre (`agr.ps1` / `agr.bat`)** para automação de ambiente, startup, clones, dumps, deploys e testes.
5. **Trilha Pedagógica (Dojo AGR)**, carreira e evidências de homologação.

---

## 📁 2. MAPEAMENTO COMPLETO DE DIRETÓRIOS E SUBDIRETÓRIOS

```text
agr-docs/
├── agr.bat / agr.ps1               # ⚡ CLI Mestre Unificado da AGR
├── cockpit.bat / cockpit/          # 📊 Validador Web de Banco & Zero-Divergência (porta 8888)
│
├── docs/                           # 📚 Visão Global e Arquitetura Cross-Sistemas
│   ├── README.md                   # Índice consolidado com links para todos os projetos
│   ├── 01-visao-geral-arquitetura.md # Topologia, microsserviços e bancos
│   ├── GUIA-PORTAIS-E-AMBIENTES.md # Diferenças Portal 1 (Java 8) vs Portal 2 (Java 17)
│   ├── BLUEPRINT-ARQUITETURA-DO-ZERO.md # Padrões de design de software da AGR
│   ├── 16-roadmap-pratico-do-zero-ao-senior-projetos-agr.md
│   └── 17-esteira-portfolio-internacional-e-metodologia-profunda.md
│
├── projetos/                       # 🏛️ Diretório Central de Projetos (25 sistemas mapeados)
│   ├── README.md                   # Matriz completa de projetos, links e bancos
│   └── <nome-do-projeto>/          # (ex: fiscalizacao, portal, cadu, dare, etc.)
│       ├── docs/                   # Especificações técnicas, regras de negócio e mapeamentos
│       ├── database/               # Dumps MySQL (.sql) e histórico de alterações
│       └── tasks/                  # Tarefas de desenvolvimento do projeto
│           └── <id>-<hu>-<slug>/   # Estrutura modular padrão de cada tarefa
│               ├── docs/           # Requisitos originais (REQUISITOS-<hu>.md) e PDFs
│               ├── specs/          # Planos técnicos de backend, frontend e contratos
│               ├── evidencias/     # Central de comprovação da tarefa
│               │   ├── 01_deploy-teste/   # Prints de homologação e zips 27/30 na rede
│               │   └── 02_merge-producao/ # Os 7 prints oficiais de Merge e War Produção
│               ├── sessoes-ia/     # Histórico de contexto de IA e engenharia de prompts
│               ├── scripts/        # Scripts locais de startup e validação (subir-<id>.bat/.ps1)
│               └── tests/          # README de testes apontando para as specs E2E oficiais
│
├── e2e/                            # 🧪 Suíte de Testes Automatizados E2E (Node 14 + Edge)
│   ├── specs/                      # Suítes de testes organizadas por sistema e tarefa
│   │   ├── fiscalizacao/
│   │   │   ├── 30593/              # Task 30593 (HU001 - Autos por Motorista)
│   │   │   └── 30635/              # Task 30635 (HU002 - Termo de Remoção TRV)
│   │   └── templates/              # Templates padrão para criação de novas specs
│   ├── helpers/                    # Utilitários compartilhados (auth, browser, reporter, index.js)
│   ├── auditoria/                  # Ferramentas forenses de conciliação Banco vs API vs WAR
│   ├── screenshots/                # Evidências e capturas de tela automáticas (em .gitignore)
│   ├── runner.js                   # CLI Runner recursivo com filtro flexível
│   └── package.json                # Scripts npm
│
├── guia-task/                      # 📖 Manuais de Qualidade e Processo de Deploy
│   ├── README.md                   # Índice dos manuais
│   ├── MANUAL-DEFINITIVO-DEPLOY-E-REDMINE.md # Passo a passo de build, empacotamento e Redmine
│   ├── CHECKLIST-ANTI-QA.md        # Critérios rigorosos de aceitação pré-homologação
│   ├── GUIA-REPRODUTIBILIDADE-AMBIENTE.md # Configuração padronizada multi-máquinas
│   ├── gerar-deploy-task.ps1       # Automação de compilação e injeção de relatórios Jasper
│   ├── validar-ambiente.ps1        # Delegador para o validador oficial
│   └── assets/                     # Galeria de evidências e prints de homologação
│
├── scripts/                        # 🛠️ Central de Scripts Especializados
│   ├── README.md                   # Catálogo completo de scripts
│   ├── subir-ambiente.ps1          # Orquestração inteligente de portas, branches e serviços
│   ├── parar-ambiente.ps1          # Encerramento limpo de processos Java e Node
│   ├── validar-ambiente.ps1        # Auditoria de 6 pontos (Java 17/8, Maven, Node, MySQL, Jasper)
│   ├── testar-e2e.ps1              # Execução unificada de testes automatizados E2E
│   ├── clonar-portais.ps1 / .bat   # Clonagem automatizada Portal 1 e Portal 2
│   ├── dump-bancos.ps1 / .bat      # Extração de dumps MySQL (10.243.1.27)
│   ├── nova-task.ps1               # Scaffolding automático de nova task (docs, specs, testes)
│   ├── organizar-deploys.ps1       # Auditoria e empacotamento de releases
│   ├── tools/                      # Ferramentas auxiliares (code-snap, web-snap, abrir-deploys)
│   └── tasks/                      # Wrappers e referências para scripts de tarefas
│
├── aulas/                          # 🥋 Trilha Pedagógica — Dojo AGR (30 Aulas Práticas)
├── carreira/                       # 🎯 Editais de Concursos, Livros e Trilha Profissional
├── gerador-evidencias/             # 📑 Gerador de Relatórios de Evidências (PDF/MD)
├── prompt/                         # 🧠 Módulos conceituais do Dojo
└── .agents/                        # 🤖 Regras e Customizações do Antigravity
    └── rules/                      # Regras ativas de governança e engenharia
```

---

## ⚡ 3. PADRÃO PARA CRIAR UMA NOVA TASK

Sempre utilize o gerador oficial:
```powershell
.\scripts\nova-task.ps1 -Id <REDMINE_ID> -Hu "<HU_CODE>" -Nome "<SLUG_TASK>" -Sistema "<NOME_SISTEMA>"
```
Isso gera automaticamente:
1. `projetos/<sistema>/tasks/<id>-<hu>-<slug>/` com `docs/`, `specs/`, `evidencias/`, `sessoes-ia/`, `scripts/` e `tests/`.
2. Scripts locais `subir-<id>.bat` e `subir-<id>.ps1`.
3. Esqueleto de teste E2E em `e2e/specs/<sistema>/<id>/<id>-<hu>-<slug>.e2e.js`.

---

## 🧪 4. PADRÃO PARA TESTES E2E

1. **Localização:** Todas as novas suítes devem ficar em `e2e/specs/<sistema>/<task_id>/`.
2. **Execução:**
   ```powershell
   .\agr.ps1 testar <task_id>           # Headless (segundo plano)
   .\agr.ps1 testar <task_id> -Headed   # Headed (Edge aberto na tela)
   .\agr.ps1 testar all                 # Roda todas as specs do ecossistema
   ```
3. **Resolução de Helpers:** Sempre importar via `require('../../../helpers/reporter')` ou via proxy em `helpers/`.

---

## 🔒 5. SEGURANÇA E PREVENÇÃO DE VAZAMENTO DE CREDENCIAIS

1. **NUNCA comitar arquivos de segredos:** `gitlab.txt`, `conexaobanco.md`, `envteste.txt` e `*.sql` estão no `.gitignore`.
2. **NUNCA commitar `e2e/screenshots/`:** Evidências locais são mantidas em disco e não sobem ao Git.
3. **NUNCA expor senhas em commits ou documentação pública:** Use placeholders ao criar exemplos.

---

## 💡 6. DIRETRIZES DE ECONOMIA DE TOKENS NO AGR-DOCS

1. **Não leia dumps SQL inteiros:** Os arquivos `.sql` têm dezenas ou centenas de megabytes. Para inspecionar estrutura, use grep filtrado (`grep_search`) buscando `CREATE TABLE` ou colunas específicas.
2. **Use faixas de linhas:** Ao inspecionar documentos longos (ex: históricos, transcrições), utilize `StartLine` e `EndLine` no `view_file`.
3. **Privilegie o CLI `agr.ps1`:** Para checar ambiente, rode `.\agr.ps1 status` em vez de múltiplos comandos avulsos de portas e processos.

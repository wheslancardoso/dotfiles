# 📦 PROTOCOLO DE DEPLOY AGR — 07: PADRÃO DE ORGANIZAÇÃO & BLINDAGEM DE ARTEFATOS
## *(Regras Rígidas para Distribuição de Builds, Isolamento de Histórico e Envio Sob Demanda)*

---

### 🛡️ 1. PRINCÍPIO DA SOBERANIA: ENVIO PARA A REDE É 100% SOB DEMANDA
1. **Envio NUNCA é Automático:** Scripts de build e deploy **JAMAIS** devem copiar arquivos para o servidor de rede (`\\10.6.63.18\...`) de forma silenciosa ou automática sem autorização explícita do desenvolvedor.
2. **Controle Manual Total:** Os artefatos são gerados e salvos localmente. O envio para a rede é disparado **apenas** quando o desenvolvedor decidir:
   - Ou executando explicitamente o script manual de 1 clique: `COPIAR_PARA_REDE_AGR.bat` dentro da pasta `00_VERSAO_ATUAL_PARA_DEPLOY/`.
   - Ou passando a flag intencional `-CopiarParaRede` no gerador de deploy.

---

### 📁 2. PROIBIÇÃO ABSOLUTA DE ARQUIVOS SOLTOS NA RAIZ DA TASK
**A Causa Raiz de Erros:** Quando arquivos `.zip` ou `.war` de builds antigos e novos ficam soltos na raiz da task (`Deploy\Testes\<Projeto>\<Task>\`), o desenvolvedor pode clicar ou selecionar pacotes desatualizados por engano.

**A REGRA DE OURO:**
> **Na raiz da pasta de qualquer Task (`...\Deploy\Testes\<Projeto>\<TaskId>\`), é terminantemente proibido manter arquivos soltos de código, `.zip` ou `.war`.**
> A raiz deve conter **APENAS** as pastas estruturadas e o aviso `00_LEIA-ME_PRIMEIRO.txt`.

---

### 🏗️ 3. ESTRUTURA PADRÃO OBRIGATÓRIA DA PASTA DE DEPLOY
Toda task gerada ou organizada deve respeitar estritamente a árvore:

```text
Deploy\Testes\<Projeto>\<TaskId>\
│
├── 📁 00_VERSAO_ATUAL_PARA_DEPLOY\          <-- ⭐ ÚNICA PASTA OFICIAL PARA O TESTE
│   ├── <TaskId> - 27 - Dev - <Nome>.zip     (Pacote oficial atualizado do Frontend)
│   ├── <TaskId> - 30 - Dev - <Nome>.zip     (Pacote oficial atualizado do Backend)
│   ├── agrfiscalservice.war                 (WAR padrão)
│   ├── COPIAR_PARA_REDE_AGR.bat             (Script manual para envio à rede sob demanda)
│   ├── TEXTO_REDMINE.txt                    (Descrição oficial formatada para o chamado)
│   ├── manifesto-deploy.json                (Metadados, commits Git e auditoria Jasper)
│   └── LEIA-ME_ENVIAR_ESTES_ARQUIVOS.txt
│
├── 📁 _HISTORICO_VERSOES_ANTERIORES\        <-- 📦 TODAS AS VERSÕES PASSADAS ISOLADAS
│   ├── YYYY-MM-DD_V1-Deploy-Inicial\
│   ├── YYYY-MM-DD_V2-Correcao-Report\
│   └── ...
│
└── 📄 00_LEIA-ME_PRIMEIRO.txt               <-- Orientação direta para abrir a pasta 00_
```

---

### ⚡ 4. ATALHOS & FERRAMENTAS DO ECOSSISTEMA
- **Abrir Deploys:** O script `abrir-deploys.bat` na raiz de `agr-docs` abre diretamente a pasta `00_VERSAO_ATUAL_PARA_DEPLOY` da task desejada no Windows Explorer.
- **Higienização Automatizada:** O script `scripts/organizar-deploys.ps1` pode ser executado a qualquer momento para varrer e garantir que nenhum arquivo fique fora do padrão.

---

### 📸 5. CENTRALIZAÇÃO DE EVIDÊNCIAS POR TASK (SEM POLUIR GUIA-TASK)
A pasta `guia-task/` destina-se **apenas a manuais e scripts**. As evidências de cada tarefa residem na pasta da própria task:

```text
projetos/<sistema>/tasks/<ID>-<HU>-<SLUG>/evidencias/
├── 📁 01_deploy-teste/              # Prints de testes no browser e pacotes 27/30 na rede
└── 📁 02_merge-producao/            # As 7 evidências oficiais de Merge e War Produção
```

---

### 🏷️ 6. AS 7 EVIDÊNCIAS OFICIAIS & AUTO-RENOMEAÇÃO (SUPORTE FLAMESHOT)
Ao tirar prints no **Flameshot** ou capturador, o desenvolvedor pode salvar os arquivos simplesmente com os números de **1 a 7**:
1. `1.png` -> `01_merge_back_terminal_<TASK>.png` (Merge Base -> Produção no Backend)
2. `2.png` -> `02_merge_front_terminal_<TASK>.png` (Merge Base -> Produção no Frontend + Apontamento)
3. `3.png` -> `03_build_front_terminal_<TASK>.png` (Build `npm run-script build` Angular em Produção)
4. `4.png` -> `04_merge_gitlab_historico_<TASK>.png` (GitLab Web: commits da branch Produção)
5. `5.png` -> `05_prod_springtools_banco_<TASK>.png` (Spring Tools: application.properties de Produção)
6. `6.png` -> `06_prod_rede_war_243_<TASK>.png` (Rede Produção: Explorer na pasta `243\` com `.war`)
7. `7.png` -> `07_prod_rede_front_242_<TASK>.png` (Rede Produção: Explorer na pasta `242\Front\` com `.zip`)

Ao executar `.\agr.ps1 prod <TASK>`, o script **auto-renomeia todos os prints numéricos automaticamente**, gera o `CHECKLIST.md` e abre a pasta no Windows Explorer.


# 🚀 Guia Mestre: Workflows de Desenvolvimento Fullstack (Top 1% Suite)

> **Manual prático de execução para todas as principais stacks de desenvolvimento:**  
> Java (Spring Boot), TypeScript (React/Next.js/React Native), Python (FastAPI/Django), Go, Rust, Flutter, Docker, Bancos SQL e Inteligência Artificial.

---

## 🏛️ Visão Geral dos Workflows

```
+-------------------------------------------------------------------------------+
|                       WORKFLOWS FULLSTACK INTEGRADOS                          |
+---------------------+-----------------------+---------------------------------+
| BACKEND & ENTERPRISE| FRONTEND & WEB        | MOBILE & MULTIPLATAFORMA        |
| - Java / Spring Boot| - React / Next.js     | - React Native / Expo           |
| - Go Microservices  | - Vue / Svelte        | - Flutter / Dart                |
| - Python / FastAPI  | - TailwindCSS         | - scrcpy (Zero-lag Mirroring)   |
| - Rust APIs         | - TypeScript / Node   | - Android SDK (Zero-Studio)     |
+---------------------+-----------------------+---------------------------------+
| DADOS & APIS        | INFRA & CONTAINERS    | INTELIGÊNCIA ARTIFICIAL         |
| - Dadbod (Postgres) | - Docker & Compose    | - Antigravity CLI (agy)         |
| - Kulala (.http API)| - Lazydocker (ld)     | - Split Vibe Coding             |
| - SQL In-Buffer     | - GNU Stow & Dotfiles | - LazyGit Diff Verification     |
+---------------------+-----------------------+---------------------------------+
```

---

## ☕ 1. Workflow: Java & Spring Boot Enterprise

### 🛠️ Configuração Automática
- **LSP**: Eclipse JDTLS instalado automaticamente via Mason.
- **Lombok**: Detecção e injeção automática de `-javaagent:lombok.jar`.
- **Compiladores/Build**: Suporte automático a `pom.xml` (Maven) e `build.gradle` (Gradle).

### ⚡ Passo a Passo no Dia a Dia:
1. **Abrir Projeto**:
   ```bash
   cd ~/projetos/minha-api-spring
   zellij --layout fullstack
   ```
2. **Navegação & Criação de Classes**:
   - Abra a árvore com `<leader>e` e crie arquivos `User.java`, `UserController.java`, `UserService.java`.
3. **Geração de Código & Refatoração (Sem digitar boilerplate)**:
   - Crie atributos privados (ex: `private String name;`).
   - Pressione **`<leader>ca`** (Code Actions) para:
     - *Generate Getters and Setters*
     - *Generate Constructor using Fields*
     - *Generate toString(), hashCode() and equals()*
4. **Organização de Imports**:
   - Ao salvar (`<C-s>`), imports não utilizados são limpos automaticamente.
   - Pressione **`<leader>co`** para disparar organização manual de imports.
5. **Execução & Debugging (DAP)**:
   - Adicione um breakpoint na linha desejada com **`<leader>db`**.
   - Inicie a sessão de depuração com **`<leader>dc`**.
   - Pressione **`<leader>du`** para abrir o painel de variáveis locais, chamadas de stack e watch expressions.
   - Navegue pelo código: `<leader>di` (Step Into), `<leader>do` (Step Over).
6. **Execução de Testes JUnit**:
   - Pressione **`<leader>tt`** para rodar o teste unitário sob o cursor.
   - Pressione **`<leader>tr`** para ver o relatório completo de testes no Neotest.

---

## 🌐 2. Workflow: TypeScript, React, Next.js & TailwindCSS

### 🛠️ Configuração Automática
- **LSP**: `vtsls` (Language Server de alto desempenho para TS/JS).
- **Formatador**: Prettier acionado automaticamente ao salvar.
- **Estilo**: TailwindCSS Language Server + `nvim-colorizer` para preview de cores.

### ⚡ Passo a Passo no Dia a Dia:
1. **Abrir Projeto Web**:
   ```bash
   cd ~/projetos/meu-app-react
   vibe
   ```
2. **Manipulação de Tags JSX/TSX (Zero Atrito)**:
   - **Auto-rename**: Mude `<button>` para `<motion.button>` e a tag de fechamento `</button>` se atualiza sozinha.
   - **Auto-tag**: Digite `<div>` e o editor fecha `</div>` imediatamente.
   - **Surround JSX**: Selecione um elemento e aperte `ysit<section className="container">` para encapsular tudo.
3. **TailwindCSS Colorizer**:
   - Classes como `bg-rose-500`, `text-[#89b4fa]`, `border-emerald-400` exibem imediatamente um marcador com a cor real ao lado do texto.
4. **Dividir/Agrupar Props (`gS`)**:
   - Componentes com muitas props em uma linha só: coloque o cursor e aperte **`gS`** para transformar em múltiplas linhas perfeitamente identadas.

---

## 📱 3. Workflow: Mobile (React Native & Flutter) sem Android Studio

### 🛠️ Filosofia "Headless Mobile"
Você não precisa dos 4GB de consumo de RAM do Android Studio para desenvolver mobile.

### ⚡ Passo a Passo:
1. **Conectar Celular Físico via USB**:
   - Certifique-se de que a *Depuração USB* está ativa no seu celular.
   - No terminal do Arch Linux, execute:
     ```bash
     scrcpy-dev
     ```
   - A tela do seu celular abre em uma janela flutuante no Hyprland, respondendo aos seus cliques de mouse e teclado físico a 60fps+!
2. **Iniciar o Ambiente Mobile**:
   ```bash
   cd ~/projetos/meu-app-mobile
   mobile
   ```
3. **Se for React Native / Expo**:
   - O painel inferior roda o `npx expo start` ou `npm run android`.
   - Modifique o código no LazyVim e salve (`<C-s>`). O Fast Refresh atualiza o celular instantaneamente.
4. **Se for Flutter**:
   - Pressione **`<leader>Fr`** para disparar Hot Reload instantâneo.
   - Pressione **`<leader>FR`** para Hot Restart completo.
   - Pressione **`<leader>Fd`** para listar dispositivos conectados.

---

## 🐍 4. Workflow: Python (FastAPI, Django & Automações)

### 🛠️ Configuração Automática
- **LSP & Linter**: `pyright` (tipagem) + `ruff` (linter/formatter mais rápido do mundo) + `black`.
- **Ambientes Virtuais**: `venv-selector.nvim` descobre automaticamente `.venv`, `poetry`, `conda` e `mise`.

### ⚡ Passo a Passo:
1. **Selecionar o Ambiente Virtual**:
   - Abra qualquer arquivo `.py` e aperte **`<leader>cv`**.
   - O Telescope listará seus ambientes virtuais disponíveis no projeto. Selecione com `<CR>`.
2. **Formatação & Tipagem**:
   - Salve com `<C-s>`: O Ruff organiza imports e formata o código segundo a PEP 8 em menos de 10ms.
3. **Depuração com Debugpy**:
   - Coloque breakpoints com `<leader>db` e inicie a execução com `<leader>dc`.

---

## 🦀 5. Workflow: Rust & Go Microservices

### 🦀 Rust:
1. **Cargo.toml Inteligente**: Ao abrir o `Cargo.toml`, o plugin **`crates.nvim`** mostra as versões mais recentes das dependências inline, avisando sobre atualizações disponíveis.
2. **Rust-Analyzer**: Inferência de tipos avançada, inlay hints e documentação de traits ao passar o cursor (`K`).
3. **Build & Testes**: Pressione `<leader>tt` para rodar `cargo test` no arquivo atual.

### 🐹 Go:
1. **Gopls & Struct Tags**:
   - Gere tags JSON/DB em structs instantaneamente.
2. **Imports Automáticos**: O `goimports` adiciona pacotes do GitHub automaticamente ao salvar.
3. **Delve Debugger**: Depuração nativa de goroutines e canais com `<leader>dc`.

---

## 🗄️ 6. Workflow: Banco de Dados SQL Nativo (Dadbod UI)

Substitui o DBeaver e DataGrip para 99% das tarefas diárias:

```sql
-- Exemplo de arquivo queries.sql
SELECT 
    u.id, 
    u.name, 
    u.email, 
    COUNT(o.id) as total_orders
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.active = true
GROUP BY u.id
ORDER BY total_orders DESC
LIMIT 50;
```

### ⚡ Como Operar:
1. Abra a barra de bancos com **`<leader>D`**.
2. Adicione uma conexão com **`<leader>Da`** (ex: `postgres://postgres:senha@localhost:5432/app_db`).
3. Abra um arquivo `.sql` e escreva sua query.
4. **Autocomplete**: Ao digitar `SELECT * FROM `, o Neovim autocompleta nomes de tabelas e colunas do seu banco real!
5. **Execução**: Selecione a query e aperte `<C-Enter>` (ou `<leader>S`). O resultado aparece em uma tabela formatada em split lateral.

---

## 🌐 7. Workflow: Testes de API REST (Kulala)

Substitui o Postman e Bruno para desenvolvimento diário:

```http
# Arquivo: api.http

@baseUrl = http://localhost:8080/api/v1
@authToken = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

### 1. Autenticação
POST {{baseUrl}}/auth/login
Content-Type: application/json

{
  "email": "dev@wfix.com",
  "password": "senhaSuperSegura123"
}

### 2. Listar Clientes Protegidos
GET {{baseUrl}}/clients
Authorization: Bearer {{authToken}}
Accept: application/json
```

### ⚡ Como Operar:
1. Coloque o cursor dentro do bloco da requisição desejada.
2. Pressione **`<leader>Rr`** ➔ A requisição é disparada e o JSON de retorno aparece formatado à direita.
3. Pressione **`<leader>Rt`** para alternar entre ver os Headers HTTP e o Body.
4. Pressione **`<leader>Rc`** para copiar a requisição como um comando `curl` para colar no terminal.

---

## 🤖 8. Workflow: Vibe Coding com IA (Antigravity CLI `agy`)

### ⚡ O Ciclo Perfeito de Desenvolvimento com Agente:
1. **Abrir a Sessão**:
   ```bash
   vibe
   ```
2. **Comando em Linguagem Natural na CLI (`agy`)**:
   - Digite no painel da direita:
     > *"Crie uma rota POST /orders com validação de payload, integrando com o repositório de banco de dados e adicionando testes unitários."*
3. **O Agente Trabalha**:
   - A IA inspeciona os arquivos do projeto, cria as classes necessárias, adiciona dependências e roda os testes.
4. **Inspeção Instantânea no Neovim**:
   - Como o LazyVim lê as alterações do disco em tempo real, você vê os arquivos surgirem e se atualizarem na sua tela sem nenhum delay.
5. **Revisão e Commit com LazyGit**:
   - Pressione **`<leader>gg`** para abrir o LazyGit.
   - Navegue pelos arquivos modificados com `j`/`k`, veja o diff colorido com precisão cirúrgica, dê stage com `Space` e commite com `c`.

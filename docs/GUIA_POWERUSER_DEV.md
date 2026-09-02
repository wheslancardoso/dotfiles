# ⚡ Guia Mestre: Power User Developer Suite (LazyVim + Terminal God Mode)

> **O guia definitivo para eliminar todo e qualquer microatrito no desenvolvimento diário.**  
> Este ambiente substitui por completo o VS Code, DBeaver, Postman e ferramentas pesadas de Git, mantendo o controle 100% no teclado com velocidade instantânea.

---

## 🏛️ Tabela Comparativa: Neovim vs IDEs Tradicionais

| Necessidade | Na IDE Convencional | No Seu Setup Power User | Ganho Real |
|---|---|---|---|
| **Edição e Navegação** | Mouse + dezenas de cliques | **Flash (`s` + 2 letras)** + **Harpoon (`<leader>1-4`)** | 10x mais rápido |
| **Banco de Dados (SQL)** | Abrir DBeaver / DataGrip (800MB RAM) | **Dadbod UI (`<leader>D`)** direto no buffer | Autocomplete nativo + 0s de espera |
| **Testar APIs / REST** | Abrir Postman / Insomnia (1GB RAM) | **Kulala (`<leader>Rr` em arquivos `.http`)** | JSON formatado na hora |
| **Gerenciamento de Git** | Aba lenta do VS Code / GitLens pago | **LazyGit (`<leader>gg`)** + **Diffview (`<leader>gd`)** | Stage de linhas e merge 3-way instantâneo |
| **Emulador Mobile** | Emulador pesado do Android Studio | **scrcpy (`scrcpy-dev`)** em janela Hyprland | 60fps+, 0 lag, < 50MB RAM |
| **IA / Copiloto** | Extensão com abas lentas | **Antigravity CLI (`<leader>ai` ou `zellij --layout vibe`)** | Agente autônomo com terminal real |

---

## 🎯 1. Eliminação Total de Microatritos de Edição

### 🔲 A. Surround (Envolver código com aspas, parênteses e tags)
Esqueça ter que mover o cursor até o início e fim da palavra para colocar aspas:
- `ysiw"` : Envolve a palavra sob o cursor com `"aspas"`
- `ysiw)` : Envolve a palavra com `(parênteses)`
- `cs"'` : Troca aspas duplas por aspas simples
- `ds"` : Deleta as aspas ao redor
- `ysit<div>` : Envolve todo o bloco com a tag HTML `<div>...</div>`

### 🔄 B. Auto-tag (HTML / JSX / TSX / XML)
Ao renomear uma tag de abertura (ex: `<div>` para `<section>`), a tag de fechamento `</div>` correspondente **é renomeada automaticamente em tempo real**.

### 🔀 C. Split & Join (`gS`)
Transforme argumentos ou objetos de linha única em formato multi-linha (e vice-versa):
- Coloque o cursor dentro de `{ a: 1, b: 2 }` e aperte **`gS`** ➔ transforma em:
  ```ts
  {
    a: 1,
    b: 2,
  }
  ```

### 📏 D. Align (`ga`)
Alinhe blocos de código com facilidade:
- Selecione as linhas e aperte **`ga=`** para alinhar todas as atribuições pelo sinal de igual `=`.

### 🛠️ E. Refactoring Suite
- `<leader>re` : Extrair função da seleção visual
- `<leader>rv` : Extrair variável
- `<leader>ri` : Fazer inline de variável
- `<leader>rf` : Extrair função para um novo arquivo

---

## 🗄️ 2. Banco de Dados Nativo (Dadbod UI)

Esqueça o DBeaver! Pressione **`<leader>D`** para abrir a barra lateral de conexões de banco de dados.

### Como Usar:
1. Abra o Neovim e aperte `<leader>Da` para adicionar uma nova conexão (ex: `postgresql://user:pass@localhost:5432/mydb`).
2. Navegue pelas tabelas com `j`/`k` e aperte `<CR>` para inspecionar schema e registros.
3. Escreva queries SQL em qualquer arquivo `.sql` e execute a linha/seleção com `<C-Enter>` ou `<leader>S`.
4. Autocomplete completo de tabelas e colunas direto pelo editor.

---

## 🌐 3. Cliente REST API Embutido (Kulala)

Crie um arquivo `requests.http` na raiz do seu projeto:

```http
### Listar Usuários
GET https://jsonplaceholder.typicode.com/users
Content-Type: application/json

### Criar Novo Post
POST https://jsonplaceholder.typicode.com/posts
Content-Type: application/json

{
  "title": "Vibe Coding no Neovim",
  "body": "Setup de elite no Arch Linux",
  "userId": 1
}
```

### Comandos:
- `<leader>Rr` : Executa a requisição sob o cursor e abre a resposta formatada na lateral.
- `<leader>Rt` : Alterna a visualização entre Body e Headers.
- `<leader>Rc` : Copia a requisição atual como comando `curl`.

---

## 🌿 4. Git Avançado & Resolução de Conflitos

- **`<leader>gg`** : Abre o **LazyGit** completo em popup flutuante.
- **`<leader>gd`** : Abre o **Diffview** para ver todos os arquivos modificados em split comparativo.
- **`<leader>gh`** : Abre o histórico de commits específico do arquivo atual.
- **Merge Conflicts**: No Diffview, os conflitos aparecem em 3 colunas (Seu branch | Resultado final | Branch mesclado), permitindo aceitar mudanças com 1 tecla.

---

## ☕ 5. Java Enterprise & Lombok

O suporte a Java no seu setup inclui:
- **Lombok**: Detecção automática da `lombok.jar` instalada via Mason.
- **Maven & Gradle**: Detecção automática de projetos e dependências.
- **Atalhos Java**:
  - `<leader>co` : Organizar imports (remove não utilizados e ordena)
  - `<leader>ca` : Gerar Getters/Setters, Construtor e `toString()`
  - `<leader>db` : Toggle Breakpoint
  - `<leader>dc` : Iniciar Depuração (DAP)

---

## 📱 6. Mobile & Android sem Emulador Pesado

Em vez de abrir o emulador do Android Studio:
1. Conecte seu aparelho via cabo USB (ou Wi-Fi ADB).
2. Execute no terminal:
   ```bash
   scrcpy-dev
   ```
3. A tela do seu celular real abrirá como uma janela flutuante no Hyprland com taxa de 60fps+, áudio redirecionado e latência zero!

---

## 🚀 7. Layouts de Multiplexação no Zellij

| Comando | Layout Aberto |
|---|---|
| `vibe` | **LazyVim (70%)** + **Antigravity CLI (30% topo)** + **Terminal Runner** |
| `fullstack` | **LazyVim (65%)** + **Antigravity CLI** + **Docker/Database Runner** |
| `mobile` | **LazyVim Mobile** + **Antigravity CLI** + **Metro/Flutter Logs** |

---

## ⌨️ Tabela Resumo de Teclas Mestras

| Tecla | Descrição |
|---|---|
| `<Space>` | **Leader Key** |
| `s` + `2 letras` | **Flash Navigation** (salto instantâneo para qualquer palavra) |
| `<leader>1` a `4` | Alternar entre arquivos fixados no **Harpoon** |
| `<leader>ha` | Adicionar arquivo atual ao **Harpoon** |
| `<leader>gg` | Abrir **LazyGit** |
| `<leader>ai` | Abrir **Antigravity CLI (`agy`)** no terminal flutuante |
| `<leader>D` | Abrir gerenciador de **Banco de Dados (Dadbod)** |
| `<leader>Rr` | Executar **Requisição HTTP (Kulala)** |
| `<leader>gd` | Abrir **Diffview** (Diff do projeto) |
| `<leader>xx` | Diagnósticos de erros (**Trouble**) |
| `<leader>st` | Buscar todos os **TODOs** no projeto |
| `<leader>qs` | Restaurar sessão de trabalho anterior (**Persistence**) |
| `<leader>re` | Extrair função (**Refactoring**) |
| `<C-s>` | Salvar arquivo |
| `<leader>qq` | Sair de tudo |

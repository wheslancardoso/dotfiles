# 🚀 Guia Definitivo: LazyVim + Antigravity CLI + Zellij (Vibe Coding Suite)

> **O ambiente definitivo para desenvolvimento de alta performance no Arch Linux + Hyprland.**  
> Combina a velocidade do Neovim (LazyVim), o poder autônomo da **Antigravity CLI (`agy`)**, e a organização fluida do multiplexador **Zellij**.

---

## 🏛️ Filosofia do Setup: "Vibe Coding no Terminal"

Em vez de depender de interfaces pesadas e lentas de IDEs gráficas, este ecossistema adota a abordagem **Headless & Modal**:

```
+-------------------------------------------------------------+
|                     HYPRLAND WORKSPACE                      |
| +--------------------------------+------------------------+ |
| |                                |      ANTIGRAVITY CLI   | |
| |                                |           (agy)        | |
| |          LAZYVIM               |   Agente de IA autônomo| |
| |    (Edição, LSP, Syntax)       |   lendo e alterando    | |
| |                                |   arquivos em disco    | |
| |           [ 70% ]              +------------------------+ |
| |                                |    TERMINAL RUNNER     | |
| |                                |   Build / Testes / Dev | |
| |                                |          [ 30% ]       | |
| +--------------------------------+------------------------+ |
+-------------------------------------------------------------+
```

1. **LazyVim (Esquerda - 70%)**: Visualização instantânea de código, navegação modal pura via teclado, LSP ultrarrápido (Java, TS, Python, Go, Rust), Git diffs e busca fuzzy.
2. **Antigravity CLI (Direita Superior - 30%)**: O agente de IA com permissão para ler seu repositório, executar modificações e propor soluções sem você sair do fluxo do teclado.
3. **Terminal Runner (Direita Inferior - 30%)**: Execução de servidores locais, compilações, testes unitários ou comandos de sistema.

---

## ⚡ Como Iniciar uma Sessão de Vibe Coding

No terminal, dentro de qualquer projeto, basta rodar:

```bash
# Inicia a sessão Zellij com o layout dedicado de Vibe Coding
zellij --layout vibe
```

*(Ou simplesmente use o alias `vibe` configurado no seu shell).*

---

## ☕ 1. Suporte Completo a Java (Enterprise Ready)

O LazyVim inclui o módulo oficial `lang.java` baseado no **`nvim-jdtls`** (o mesmo motor Eclipse JDTLS que move o VS Code e Eclipse).

### Recursos Disponíveis Out-of-the-Box:
- **Projetos Maven & Gradle**: Reconhecimento automático da raiz do projeto e download de dependências.
- **Auto-Imports**: Organização automática de imports ao salvar (`<leader>co` para clean imports).
- **Geração de Código**: Geração de Getters, Setters, Construtores e `toString()` através de Code Actions (`<leader>ca`).
- **Debugging Nativo (DAP)**:
  - `<leader>db`: Alternar Breakpoint
  - `<leader>dc`: Iniciar / Continuar Depuração
  - `<leader>di`: Step Into
  - `<leader>do`: Step Over
  - `<leader>du`: Alternar UI do Debugger (inspeção de variáveis, stack trace, watch).

---

## 📱 2. Desenvolvimento Mobile (React Native, Flutter & Nativo)

### React Native / Expo:
- Totalmente integrado via TypeScript LSP (`tsserver`/`vtsls`), TailwindCSS e ESLint/Prettier formatters.
- Hot Reload instantâneo refletido no terminal.

### Flutter:
- Suporte a `flutter-tools.nvim` com comandos rápidos de hot reload e device selection.

### Dica de Ouro: Mobile sem IDE pesada via `scrcpy`
Para testar e rodar o app no Android sem o peso do emulador do Android Studio:
1. Conecte seu smartphone Android via USB com a *Depuração USB* ativada.
2. No terminal, execute:
   ```bash
   scrcpy
   ```
3. A tela do seu celular real abrirá como uma janela flutuante no Hyprland com taxa de atualização de 60fps+ e latência zero, consumindo menos de 50MB de RAM.

---

## ⌨️ Atalhos Mestres do LazyVim

| Atalho | Ação |
|---|---|
| `<Space>` | **Tecla Leader** principal |
| `<leader>e` | Abrir/Fechar a árvore de arquivos (**Neo-tree**) |
| `<leader>ff` | Buscar arquivos por nome (**Telescope** / Fuzzy Finder) |
| `<leader>sg` | Buscar texto em todos os arquivos do projeto (Live Grep) |
| `<leader>gg` | Abrir interface visual do **LazyGit** |
| `s` + `2 letras` | **Flash Navigation**: Salta o cursor para qualquer palavra na tela instantaneamente |
| `gd` | Ir para a Definição da função/classe |
| `gr` | Listar todas as Referências |
| `K` | Ver documentação/Hover do elemento |
| `<leader>ca` | Code Actions (Correções rápidas, geração de código) |
| `<leader>cr` | Renomear símbolo em todo o projeto |
| `<leader>xx` | Diagnósticos de erros e avisos (**Trouble**) |
| `<leader>bd` | Fechar buffer atual |
| `<leader>qq` | Sair do Neovim |

---

## 🤖 Comandos Úteis do Antigravity CLI (`agy`)

- `agy`: Inicia o agente interativo na pasta atual.
- `/settings`: Abre o painel de configurações para definir o modo de edição (incluindo Vim mode).
- `/clear`: Limpa o contexto da conversa atual.
- `agy "instrução direta"`: Executa uma tarefa em one-liner diretamente no terminal.

---

## 🛠️ Manutenção & Gerenciamento de Plugins

- `:Lazy`: Gerenciador de plugins (atualizar, checar status).
- `:LazyExtras`: Ativar/desativar módulos oficiais (Java, Rust, Go, TypeScript, Docker, etc.).
- `:Mason`: Gerenciador de LSPs, linters, formatadores e debuggers instalados.
- `:checkhealth`: Diagnóstico completo de saúde do Neovim.

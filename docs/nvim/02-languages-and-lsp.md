# Linguagens, LSP, Formatadores, Linters e DAP

Documentação técnica das configurações de linguagens, servidores LSP, formatadores, linters, debuggers (DAP) e injeções Tree-sitter do Neovim.

Fontes consultadas:
- `home/dot_config/nvim/lua/plugins/lsp.lua`
- `home/dot_config/nvim/lua/plugins/java.lua`
- `home/dot_config/nvim/lua/plugins/python.lua`
- `home/dot_config/nvim/lua/plugins/rust.lua`
- `home/dot_config/nvim/lua/plugins/web.lua`
- `home/dot_config/nvim/queries/{typescript,javascript}/injections.scm`
- `home/dot_config/nvim/after/queries/{typescript,javascript,ecma}/injections.scm`

---

## 1. Mason (`mason-org/mason.nvim`)

O `mason.nvim` garante a instalação automática (com deduplicação) dos binários abaixo e dispara o evento `FileType` no buffer atual assim que um pacote termina de instalar (`package:install:success`).

### Pacotes em `ensure_installed`

| Categoria | Pacotes |
| :--- | :--- |
| **Java** | `jdtls`, `java-debug-adapter`, `java-test` |
| **Web / TS / JS / Angular** | `vtsls`, `angular-language-server`, `html-lsp`, `emmet-language-server`, `tailwindcss-language-server`, `prettier` |
| **Python** | `pyright`, `ruff`, `black`, `debugpy` |
| **Rust** | `rust-analyzer` |
| **Go** | `gopls`, `delve` |
| **Docker** | `dockerfile-language-server`, `docker-compose-language-service` |
| **Shell / Lua** | `shfmt`, `stylua` |

### Servidores configurados em `neovim/nvim-lspconfig`

- `angularls = {}`
- `html = {}`
- `emmet_language_server`: ativo para `html`, `htmlangular`, `javascript`, `typescript`, `javascriptreact`, `typescriptreact`, `vue`, `svelte`, `css`, `sass`, `scss`, `less`.

---

## 2. Java (`mfussenegger/nvim-jdtls`)

### Runtime e Configuração do JDTLS
- **Executável do servidor**: procura Java 21+ em `~/.local/share/mise/installs/java/21*/bin/java` e injeta `--java-executable <path>` no comando do `jdtls`.
- **Runtimes de compilação**:
  - `JavaSE-17`: `~/.local/share/mise/installs/java/openjdk-17.0.2` (se existir)
  - `JavaSE-21`: `~/.local/share/mise/installs/java/21.0.2` (`default = true`, se existir)
- **Recursos habilitados**:
  - `signatureHelp.enabled = true`
  - `contentProvider.preferred = "fernflower"`
  - `sources.organizeImports`: `starThreshold = 9999`, `staticStarThreshold = 9999`
  - `codeGeneration`: `useBlocks = true`, template `toString` customizado
  - `completion.favoriteStaticMembers`: `MatcherAssert.assertThat`, `Matchers.*`, `CoreMatchers.*`, `Assertions.*` (JUnit 5), `Objects.requireNonNull`, `Objects.requireNonNullElse`, `Mockito.*`
  - `completion.filteredTypes`: `com.sun.*`, `io.micrometer.shaded.*`, `java.awt.*`, `jdk.*`, `sun.*`

### Auto-Scaffolding (`*.java`)
Nos eventos `BufNewFile` e `BufReadPost`, se o buffer `.java` estiver completamente vazio:
1. Detecta o pacote a partir de `src/main/java/(.+)`, `src/test/java/(.+)` ou `src/(.+)`, inserindo `package <pkg>;`.
2. Se o nome do arquivo terminar com `Repository.java`, cria `public interface <Nome> { ... }`; caso contrário, `public class <Nome> { ... }`.
3. Posiciona o cursor dentro do bloco.

### Keymaps Java (`FileType = "java"`, buffer-local)

| Atalho | Modo | Ação |
| :--- | :--- | :--- |
| `<leader>jo` | `n` | Organizar imports (`java/organizeImports` via cliente `jdtls`, com fallback `jdtls.organize_imports()`) |
| `<leader>ca` | `n` | Code Actions / Quick Fix (`vim.lsp.buf.code_action`) |
| `<leader>jg` | `n` | Menu de geração (`source.generate`) |
| `<leader>jga` | `n` | Gerar Getters & Setters (`source.generate.accessors`) |
| `<leader>jgc` | `n` | Gerar Construtor (`source.generate.constructors`) |
| `<leader>jgs` | `n` | Gerar `toString()` (`source.generate.toString`) |
| `<leader>jge` | `n` | Gerar `hashCode()` & `equals()` (`source.generate.hashCodeEquals`) |
| `<leader>jmr` | `n` | Rodar Spring Boot (`./mvnw` ou `mvn` `spring-boot:run`) |
| `<leader>jmc` | `n` | Maven Compile (`compile`) |
| `<leader>jmt` | `n` | Maven Test (`test`) |
| `<leader>jmb` | `n` | Maven Package (`clean package -DskipTests`) |
| `<leader>jC` | `n` | Recompilar workspace JDTLS (`jdtls.compile("full")`) |
| `<leader>ju` | `n` | Atualizar configuração do `pom.xml` (`jdtls.update_project_config()`) |
| `<leader>jrv` | `n`, `v` | Extrair Variável (`jdtls.extract_variable`) |
| `<leader>jrc` | `n`, `v` | Extrair Constante (`jdtls.extract_constant`) |
| `<leader>jrm` | `v` | Extrair Método (`jdtls.extract_method(true)`) |
| `<leader>jtc` | `n` | Rodar testes da classe (`jdtls.test_class()`) |
| `<leader>jtm` | `n` | Rodar teste do método mais próximo (`jdtls.test_nearest_method()`) |

*Nota: os comandos Maven usam `Snacks.terminal` (quando disponível) ou `split | terminal`, buscando a raiz por `pom.xml` ou `mvnw`.*

---

## 3. Python (`linux-cultist/venv-selector.nvim`)

- **LSP / Linter / Formatter / DAP (via Mason)**: `pyright`, `ruff`, `black`, `debugpy`.
- **Seletor de Venv**:
  - Comando: `:VenvSelect`
  - Keymap: `<leader>cv` (`ft = "python"`) — Selecionar Python Venv
  - Quando `telescope.nvim` está disponível, prioriza diretórios `venv`, `.venv`, `env`, `.env`.

---

## 4. Rust (`saecki/crates.nvim`)

- **LSP (via Mason)**: `rust-analyzer`.
- **Gerenciamento de `Cargo.toml`**: `saecki/crates.nvim` carregado no evento `BufRead Cargo.toml`, com autocompletar habilitado via `cmp` (`completion.cmp.enabled = true`).

---

## 5. Web, Cores e Flutter/Dart (`lua/plugins/web.lua`)

### `NvChad/nvim-colorizer.lua`
- Carregado em `BufReadPre` / `BufNewFile` para `filetypes = { "*" }`.
- Renderiza cores inline com `mode = "background"`, `virtualtext = "■"`, `tailwind = true`, `sass = { enable = true, parsers = { "css" } }`.
- Formatos habilitados: `RGB`, `RRGGBB`, `RRGGBBAA`, `AARRGGBB`, `rgb_fn`, `hsl_fn`, `css`, `css_fn` (`names = false`).

### `nvim-flutter/flutter-tools.nvim`
- Carregado sob demanda para `ft = { "dart" }`.
- Recursos: bordas `rounded`, `widget_guides.enabled = true`, `lsp.color.enabled = true`, e `statusline` com `app_version` e `device`.
- **Keymaps (`ft = "dart"`)**:
  - `<leader>Fr`: `:FlutterReload` (Hot Reload)
  - `<leader>FR`: `:FlutterRestart` (Hot Restart)
  - `<leader>Fd`: `:FlutterDevices` (Dispositivos)
  - `<leader>Fe`: `:FlutterEmulators` (Emuladores)
  - `<leader>Fq`: `:FlutterQuit` (Encerrar Flutter App)

---

## 6. Injeções Tree-sitter (`queries/` e `after/queries/`)

Os arquivos de query configuram **injeção de sintaxe HTML** (e **não** SQL) dentro de `template_string` em JavaScript/TypeScript quando o conteúdo começa com `<`:

- `queries/typescript/injections.scm` e `queries/javascript/injections.scm`
- `after/queries/typescript/injections.scm` e `after/queries/javascript/injections.scm`
  - Usam `#match? @injection.content "^`\\s*<"` com `#offset! @injection.content 0 1 0 -1` e `#set! injection.language "html"`.
- `after/queries/ecma/injections.scm`
  - Usa `#lua-match? @injection.content "^`%s*<"` com `#offset! @injection.content 0 1 0 -1` e `#set! injection.language "html"`.

---

## 7. Fluxos Rápidos para Agente de IA

1. **Diagnosticar ferramenta ausente**: conferir se o binário está na lista `ensure_installed` de `lua/plugins/lsp.lua` e verificar instalação no Mason (`:Mason`).
2. **Projeto Java não resolve dependências ou JDK**:
   - Confirmar Java 21+ em `~/.local/share/mise/installs/java/21*/bin/java`.
   - Usar `<leader>ju` (`jdtls.update_project_config()`) após editar `pom.xml` ou `<leader>jC` (`jdtls.compile("full")`) para rebuild completo.
3. **Executar/testar Spring Boot ou Maven**: usar `<leader>jmr` (run), `<leader>jmt` (test) ou `<leader>jtc`/`<leader>jtm` para testes JUnit via `jdtls`.
4. **Ambiente Python não reconhecido pelo Pyright**: executar `<leader>cv` (`:VenvSelect`) para selecionar `.venv`/`venv`.

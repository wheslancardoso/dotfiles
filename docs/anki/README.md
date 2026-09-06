# 🗂️ Deck Anki: LazyVim & Hyprland Poweruser Mastery

Este diretório contém o deck oficial de flashcards formatado e pronto para importar no **Anki Desktop**, **AnkiDroid (Android)** ou **AnkiWeb**.

---

## 📥 Como Importar no Anki (Passo a Passo)

1. Abra o **Anki**.
2. Clique no menu superior em **Arquivo** (`File`) -> **Importar...** (`Import...`) ou aperte `Ctrl + Shift + I`.
3. Selecione o arquivo:
   ```
   ~/dotfiles/docs/anki/LazyVim_Hyprland_Mastery.txt
   ```
4. Na tela de importação:
   - **Tipo de Nota**: `Básico` (Basic).
   - **Separador de Campos**: `Tabulação` (Tab) *(já detectado automaticamente)*.
   - **Permitir HTML nos campos**: `Marcado` (Checked).
5. Clique em **Importar**.

Pronto! Todos os cards serão organizados com tags por categoria (`lazyvim::basico`, `lazyvim::navegacao`, `lazyvim::lsp_code`, `hyprland::atalhos`, `yazi::filemanager`).

---

## 🧠 Categorias dos Flashcards

- **`lazyvim::basico`**: Modos do Vim (Normal vs Insert), Undo/Redo, Salvar (`<Space> w`), Sair (`<Space> q`).
- **`lazyvim::navegacao`**: Busca rápida de arquivos (`<Space><Space>`), Live Grep (`<Space>/`), Árvore de arquivos Neo-tree (`<Space>e`), Pulo instantâneo com Flash (`s + 2 letras`), Navegação de Buffers (`]b`, `[b`).
- **`lazyvim::lsp_code`**: Ir para Definição (`gd`), Code Actions (`<Space>ca`), Renomear símbolo (`<Space>cr`), Diagnóstico de Erros (`<Space>xx`).
- **`lazyvim::git`**: Interface completa do LazyGit (`<Space>gg`).
- **`hyprland::atalhos`**: Layouts de Teclado (`Super + Espaço`), Janela Flutuante (`Super + Shift + Espaço`), Spotify Scratchpad (`Super + M`), FSearch (`Super + Shift + F`), CopyQ (`Alt + V`).
- **`yazi::filemanager`**: Movimentação `hjkl`, criação (`a`), deleção (`d`), cópia (`y`) e recorte (`x`).
- **`audio::easyeffects`**: Comandos rápidos de graves (`bass`, `bass-max`, `dolby`) e recuperação de som (`fix-audio`).

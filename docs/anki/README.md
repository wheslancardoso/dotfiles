# 🗂️ Decks Anki: LazyVim & Hyprland Zero to Hero

Decks oficiais de flashcards formatados para importação imediata no **Anki Desktop**, **AnkiDroid (Android)** ou **AnkiWeb**.

---

## 📦 Decks Disponíveis

1. **`LazyVim_Zero_to_Hero.txt` (Recomendado)**:
   - **52 Flashcards Progressivos**: Desenvolvido pressupondo **ZERO conhecimento prévio** de terminal ou Vim.
   - Pega na mão desde a entrada no editor (`i`, `Esc`, modos), passa por movimentação (`hjkl`, `w`, `b`, `0`, `$`, `gg`, `G`), edição cirúrgica (`ciw`, `ci"`, `dd`, `p`), busca de arquivos (`<Espaço><Espaço>`, `Ctrl+n`, `Ctrl+p`), árvore de arquivos (`<Espaço>e`), splits de tela, LSP sênior (`gd`, `K`, `gr`, `<Espaço>cr`, `<Espaço>ca`), Git com LazyGit e atalhos do Hyprland.

2. **`LazyVim_Hyprland_Mastery.txt`**:
   - Versão condensada focada em atalhos rápidos do ecossistema.

---

## 📥 Como Importar no Anki (Passo a Passo)

1. Abra o **Anki**.
2. Clique no menu superior em **Arquivo** (`File`) ➔ **Importar...** (`Import...`) ou aperte `Ctrl + Shift + I`.
3. Selecione o arquivo:
   ```
   ~/dotfiles/docs/anki/LazyVim_Zero_to_Hero.txt
   ```
4. Na tela de importação:
   - **Tipo de Nota**: `Básico` (Basic).
   - **Separador de Campos**: `Tabulação` (Tab) *(detectado automaticamente)*.
   - **Permitir HTML nos campos**: `Marcado` (Checked).
5. Clique em **Importar**.

---

## 🧠 Estrutura Pedagógica das Tags

- **`lazyvim::01_fundamentos`**: Modos (Normal vs Insert), `i`, `a`, `o`, `O`, salvar (`<Espaço>w`), sair (`:q!`, `<Espaço>q`), undo (`u`) e redo (`Ctrl+r`).
- **`lazyvim::02_movimentacao`**: `hjkl`, palavras (`w`, `b`, `e`), linhas (`0`, `^`, `$`), topo e rodapé (`gg`, `G`), rolagem (`Ctrl+d`, `Ctrl+u`), centralização (`zz`).
- **`lazyvim::03_edicao_cirurgica`**: Cortar e colar (`dd`, `p`), copiar (`yy`), `ciw` (trocar palavra), `ci"` (trocar string), `ci(` (trocar parâmetros), `D`, `C`.
- **`lazyvim::04_selecao_visual`**: Modo visual (`v`, `V`, `Ctrl+v`), indentação (`>`, `<`).
- **`lazyvim::05_arquivos_projetos`**: Tecla Leader (`<Espaço>`), busca de arquivos (`<Espaço><Espaço>`, `Ctrl+n`, `Ctrl+p`, `Ctrl+v`, `Ctrl+s`), Live Grep (`<Espaço>/`), Neo-tree (`<Espaço>e`), Buffers/Abas (`Shift+l`, `Shift+h`, `<Espaço>bd`), Flash jump (`s + 2 letras`).
- **`lazyvim::06_lsp_programacao`**: Definição (`gd`, `Ctrl+o`), Documentação Hover (`K`), Referências (`gr`), Rename em massa (`<Espaço>cr`), Code Actions (`<Espaço>ca`), Erros/Trouble (`<Espaço>xx`, `]d`, `[d`), Formatar (`<Espaço>cf`).
- **`lazyvim::07_git_janelas`**: LazyGit (`<Espaço>gg`), Git Blame (`<Espaço>gb`), divisão de janelas/splits (`<Espaço>|`, `<Espaço>-`, `Ctrl+hjkl`).
- **`hyprland::atalhos`**: Layouts de Teclado (`Super+Espaço`), Floating (`Super+Shift+Espaço`), Spotify Scratchpad (`Super+M`), FSearch (`Super+Shift+F`), CopyQ (`Alt+V`), Key Hints (`Super+H`).
- **`audio::easyeffects`**: Comandos de som (`bass`, `bass-max`, `dolby`, `fix-audio`).

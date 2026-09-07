# 🗂️ Suíte de Decks Anki: Ecossistema Cockpit Dev (Arch + Hyprland + LazyVim)

Coleção oficial de flashcards de alto rendimento formatados e otimizados para memorização rápida e desenvolvimento de memória muscular no **Anki Desktop**, **AnkiDroid (Android)** ou **AnkiWeb**.

Desenvolvido para transformar você em um **Power-User Ninja ("Blazingly Fast")**, cobrindo cada detalhe de cada ferramenta do ecossistema: do zero absoluto até técnicas avançadas de engenharia de software e IA autônoma.

---

## 🌳 Estrutura Automática de Baralhos (`Cockpit Dev`)

Ao importar qualquer um dos arquivos, o Anki **cria automaticamente a árvore hierárquica de baralhos** graças às diretivas nativas `#deck:` incorporadas no topo de cada módulo:

```text
Cockpit Dev
├── 01 - LazyVim (69 cards)
├── 02 - Hyprland (30 cards)
├── 03 - Yazi File Manager (27 cards)
├── 04 - Zellij Multiplexer (16 cards)
├── 05 - Terminal & Modern CLI (16 cards)
├── 06 - Git & LazyGit (13 cards)
├── 07 - Audio & Media Workflow (10 cards)
└── 08 - Antigravity AI (agy) (12 cards)
```
> **Total: 193 Flashcards de Elite**

---

## 📦 Como Escolher o Arquivo para Importar

### Opção A: Tudo em 1 Clique (Recomendado)
Importe o arquivo mestre contendo todos os **193 flashcards**:
📁 **`ECOSSISTEMA_COMPLETO_MESTRE.txt`**

O Anki criará a pasta-mãe `Cockpit Dev` e distribuirá cada um dos 193 cards diretamente para os seus respectivos 8 sub-baralhos em uma única importação.

---

### Opção B: Módulo por Módulo (Estudo Focado)
Você também pode importar apenas o módulo específico que estiver treinando hoje:

- **`01_LazyVim_Zero_to_Hero.txt` (69 cards)**:
  - Modos (`Normal`, `Insert`, `Visual`), `i`, `a`, `I`, `A`, `o`, `O`, `<Esc>`, salvar, sair forçado (`:q!`), undo (`u`), redo (`Ctrl+r`), repetir (`.`).
  - Navegação pura: `hjkl`, palavras (`w`, `b`, `e`, `W`, `B`, `E`), linhas (`0`, `^`, `$`), topo/rodapé (`gg`, `G`), rolagem (`Ctrl+d`, `Ctrl+u`), centralização (`zz`), correspondência de parênteses (`%`), busca de palavras (`*`, `#`).
  - Edição cirúrgica: `ciw`, `diw`, `daw`, `ci"`, `ci'`, `ci(`, `ci{`, `dit`, `dat`, `D`, `C`, arrastar linhas (`Alt+j`, `Alt+k`), manipulação de aspas e parênteses com **Surround** (`gsa"`, `gsc"'`, `gsd"`), alternar arrays/objetos de 1 linha para multiline (**Split & Join** `gS`).
  - Projetos & Arquivos: Tecla Leader (`<Espaço>`), busca de arquivos (`<Espaço><Espaço>`, `Ctrl+n`, `Ctrl+p`, splits com `Ctrl+v`/`Ctrl+s`), substituição em massa (**Grug-far** `<Espaço>sr`), árvore Neo-tree (`<Espaço>e`), abas/buffers (`Shift+l`, `Shift+h`, `<Espaço>bd`), **Harpoon** (`<Espaço>1` a `4`, `<Espaço>ha`, `<Espaço>hh`), salto instantâneo com **Flash** (`s + 2 letras`).
  - LSP Sênior & IDE: Definição (`gd`, `Ctrl+o`), Hover documentação (`K`), referências (`gr`), renomear símbolo no projeto (`<Espaço>cr`), Code Actions (`<Espaço>ca`), erros (**Trouble** `<Espaço>xx`, `]d`, `[d`), formatar (`<Espaço>cf`), e automação com **Macros** (`qa`, `q`, `@a`, `20@a`).
  - Git & Splits: **LazyGit** (`<Espaço>gg`), Git blame (`<Espaço>gb`), divisão de janelas (`<Espaço>|`, `<Espaço>-`, `Ctrl+hjkl`).

- **`02_Hyprland_Mastery.txt` (30 cards)**:
  - Tecla Super, fechar (`Super+Q`), mira mata-processo (`Super+Backspace`).
  - Layout de teclado US-Intl com acentos vs ABNT2 (`Super+Espaço`).
  - Janela flutuante (`Super+Shift+Espaço`), tela cheia (`Super+F`) vs maximizar (`Super+Shift+F`).
  - Fixar janela em todas as telas (**Pin** `Super+P`).
  - Agrupar janelas em **Abas no Hyprland** (`Super+G`, alternar abas com `Super+Alt+H/L`).
  - Redimensionamento fino via teclado (**Submap Resize** `Super+R`, `HJKL`).
  - Arrastar/redimensionar livre com mouse (`Super+Click Esquerdo`, `Super+Click Direito`).
  - Navegação entre janelas (`Super+HJKL`) e reposicionamento (`Super+Shift+HJKL`).
  - Workspaces 1 a 10 (`Super+1..0`), mover janelas (`Super+Shift+1..9`), rolagem de workspace no mouse (`Super+Scroll`).
  - Alt+Tab instantâneo vs seletor visual Rofi (`Super+Tab`).
  - Dropdown scratchpad do Spotify (`Super+M`), terminal Quake (`Super+'` / `Super+U`).
  - Busca instantânea FSearch (`Super+Shift+F`), histórico CopyQ (`Alt+V`), capturas Flameshot (`Super+Shift+S`).
  - Extração de texto de imagens via OCR (`Super+Shift+T`), conta-gotas de cor HEX (`Super+Shift+P`).
  - Monitor Btop (`Ctrl+Shift+Esc`), Night Light (`Super+N`) e efeito Shake do mouse.

- **`03_Yazi_FileManager_Mastery.txt` (27 cards)**:
  - Abrir no terminal (`Super+E`) e flutuante (`Super+Shift+E`).
  - Navegação Vim (`j/k`, `l/Enter`, `h`).
  - Filtro em tempo real de arquivos (`f`).
  - Busca inteligente Zoxide dentro do Yazi (`Z`).
  - Operações: criar (`a`), deletar lixeira/definitivo (`d/D`), copiar/recortar/colar (`y/x/p`), renomear (`r`), bulk rename com Neovim (`R`).
  - Seleção contínua (`v`) e individual (`Espaço`).
  - Abas internas no Yazi (`t` nova, `w` fechar, `1..9` trocar).
  - Linemode: tamanho (`ms`), modificação (`mm`), permissões (`mp`), limpo (`mn`).
  - Compressão rápida: `.ZIP` (`c z`), `.7Z` (`c 7`), `.TAR.GZ` (`c t`).
  - Extração em 1 toque: para subpasta (`X` ou `Enter`), extrair aqui (`e x`).
  - Saltos rápidos GOTO: `g i`, `g v`, `g p`, `g e`, `g j`, `g m`, `g D`, `g .`, `g h`.
  - Ações Master (`Shift+M`): organizar (`M o`), diagnóstico (`M d`), backup de saves (`M s`), LazyGit (`M g`), terminal (`M t`).
  - Copiar metadados: caminho completo (`c p`), nome (`c f`), pasta pai (`c d`).
  - Ajuda visual instantânea (`~`).

- **`04_Zellij_Multiplexer_Mastery.txt` (16 cards)**:
  - Sessões persistentes (`zellij -s`, `zellij ls`, `zellij attach`), layout `vibe`.
  - Navegação entre painéis sem prefixo (`Alt + hjkl`).
  - Alternância de layouts pré-configurados (`Alt + [` e `Alt + ]`).
  - Redimensionamento rápido (`Alt + =`, `Alt + -`).
  - Gestão de Panes (`Ctrl+p`): novo (`n`), abaixo (`d`), direita (`r`), fechar (`x`), fullscreen (`f`), flutuante (`w`), bordas (`z`).
  - Arrastar painéis de lugar (**Move Mode** `Ctrl+h`, `hjkl`).
  - Gestão de Abas (`Ctrl+t`): nova (`n`), fechar (`x`), renomear (`r`), sincronizar digitação em todas (`s`).
  - Desconexão de sessão em background (`Ctrl+o d` - Detach).
  - Gerenciador visual de sessões (`Ctrl+o w`).
  - Scroll e busca de texto (`Ctrl+s`).
  - Trava de atalhos para programas aninhados (`Ctrl+g` - Locked Mode).

- **`05_Terminal_ModernCLI_Mastery.txt` (16 cards)**:
  - `zoxide` (pulo inteligente de pastas com `z`).
  - `fzf`: histórico interativo (`Ctrl+R`), colar caminho de arquivo (`Ctrl+T`), cd interativo (`Alt+C`).
  - Atalhos vitais de linha de comando (Readline): apagar linha até início (`Ctrl+u`), apagar palavra anterior (`Ctrl+w`), apagar até o fim (`Ctrl+k`), início/fim de linha (`Ctrl+a`, `Ctrl+e`), reaproveitar último argumento (`Alt+.`), rodar com permissão esquecida (`sudo !!`), limpar tela mantendo comando (`Ctrl+l`).
  - `eza` (`ls`, `ll`, `la`, `lt`), `bat` (`cat` colorido), `ripgrep` (`rg`), `fd`.
  - Aliases do sistema: `update`, `clean`, `organizar`, `fastfetch`.

- **`06_LazyGit_Git_Mastery.txt` (13 cards)**:
  - As 3 formas de abrir (`lazygit`, `<Espaço>gg`, `Shift+M g`).
  - Navegação nos 4 painéis (`1` a `4`, `h/l`).
  - Staging de arquivos (`Espaço`, `a`) e staging linha a linha / hunk (`Enter` no arquivo -> `Espaço` na linha).
  - Commit (`c`), push (`Shift+P`), pull (`p`).
  - Branches: criar (`n`), checkout (`Espaço`), deletar (`d`).
  - Descartar alterações (`d` no painel de arquivos).
  - Stash rápido (`z`) e pop (`Espaço` no painel de stash).
  - Rebase interativo: squash (`s`), editar commit (`e`), deletar commit (`d`).
  - Cherry-pick (`Shift+C`, `Shift+V`) e Revert seguro (`t`).

- **`07_Audio_Media_Workflow_Mastery.txt` (10 cards)**:
  - Controles de mídia globais sem teclas Fn (`Super+Ctrl+Espaço`, `]`, `[`).
  - Presets de som EasyEffects no terminal (`bass`, `bass-max`, `dolby`, `audio-flat`).
  - Seletor visual de áudio (`Super+Alt+A`).
  - Por que a arquitetura PipeWire Audiophile soa superior ao Windows (192kHz dinâmico, resampling SoX sinc 10, Convolver IRS).
  - Supressão de ruído por IA no microfone (RNNoise, anti-rumble, compressor, limiter).
  - Proteção anti-vazamento (Headphone Auto-Pause ao desconectar fone/Bluetooth).
  - Recuperação em 1 toque: `fix-audio`.
  - Download de músicas com metadados e capas: `spotdl`.
  - Espelhamento de tela Android sem emulador pesado: `scrcpy`.
  - Google Drive 5TB virtual on-demand: `Super+Alt+G`.

- **`08_Antigravity_AI_Mastery.txt` (12 cards)**:
  - O que é o `agy` (pair-programmer autônomo do DeepMind para terminal).
  - Autonomia total sem travar pedindo confirmações (`agy --dangerously-skip-permissions`).
  - Ambiente Vibe Coding lado a lado (`vibe` no terminal: 70% LazyVim + 30% `agy`).
  - Sincronização em tempo real entre edições do `agy` no disco e buffers do Neovim (`autoread`).
  - Modo one-shot não-interativo via terminal (`agy -p "prompt"`).
  - Retomada de sessões anteriores (`agy -c` / `agy --continue`).
  - Listagem e seleção de modelos LLM (`agy models`, `--model claude-sonnet-4-6`, `gemini-3.8-flash`).
  - Slash commands internos (`/exit`, `/clear`, `/status`, `/help`).
  - Interrupção e atalhos de saída (`Ctrl+C`, `Ctrl+D Ctrl+D`).
  - Respeito a `.gitignore` e proteção de variáveis sensíveis.
  - Diferença entre Antigravity GUI (desktop) e `agy` CLI (terminal ultraleve).
  - Estrutura de memória e logs em `~/.gemini/antigravity/`.

---

## 📥 Como Importar no Anki (Passo a Passo em 3 Segundos)

1. Abra o **Anki**.
2. Clique no menu superior em **Arquivo (`File`)** ➔ **Importar... (`Import...`)** *(ou atalho `Ctrl + Shift + I`)*.
3. Escolha o arquivo `ECOSSISTEMA_COMPLETO_MESTRE.txt` (ou qualquer módulo individual `01_...` a `08_...`).
4. Na tela de importação do Anki:
   - **Tipo de Nota**: `Básico` (Basic).
   - **Separador de Campos**: `Tabulação` (Tab) *(detectado automaticamente)*.
   - **Permitir HTML nos campos**: `Marcado` (Checked).
5. Clique no botão **Importar**.
6. Pronto! A árvore `Cockpit Dev` e todos os sub-baralhos aparecerão perfeitamente organizados e prontos para estudo diário.

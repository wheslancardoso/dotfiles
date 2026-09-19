# 󰞅 Guia Mestre & Necropsia Forense: Apex Emoji Engine (Rofi + Wayland)

> **Manual Definitivo de Arquitetura, Necropsia de Bugs (O Pesadelo dos `DDD`) e Provisionamento Automático no Arch Hyprland.**

---

## ⚡ 1. Visão Geral & Atalhos Rápidos

O **Apex Emoji Engine** é o subsistema de emojis e símbolos rápidos integrado ao Hyprland, acessível via:
* **`SUPER + .`** ou **`SUPER + ;`**

### 🎮 Atalhos de Navegação Vim (100% Teclado, Zero Mouse)
| Tecla | Função | Detalhe |
|---|---|---|
| `Ctrl + j` ou `Tab` | Descer 1 linha | Move a seleção para baixo |
| `Ctrl + k` ou `Shift + Tab` | Subir 1 linha | Move a seleção para cima |
| `Ctrl + d` | Pular meia página para baixo | Rolagem rápida no estilo Vim |
| `Ctrl + u` | Pular meia página para cima | Rolagem rápida no estilo Vim |
| `Ctrl + y` | **Vim Yank** | Copia o emoji para o clipboard e fecha (com notificação SwayNC) |
| `Enter` | **Auto-Type & Copy** | Copia para o clipboard e **digita instantaneamente** no app em foco via `wtype` |
| `Esc` ou `Ctrl + [` | Sair | Cancela e fecha a janela limpa |

### 🏷️ Abas de Categorias Instantâneas (`Alt + Número`)
Inspirado na experiência de navegação por abas do WhatsApp e Windows, com filtragem instantânea sem precisar digitar tags:
* `Alt + 1`: ⭐ **Recentes / Favoritos** (armazena histórico em `~/.local/share/rofi-emoji-history.json`)
* `Alt + 2`: 😀 **Rostos & Emoções**
* `Alt + 3`: 👋 **Pessoas & Gestos**
* `Alt + 4`: 🐶 **Animais & Natureza**
* `Alt + 5`: 🍕 **Comidas & Bebidas**
* `Alt + 6`: ✈️ **Viagens & Lugares**
* `Alt + 7`: ⚽ **Esportes & Atividades**
* `Alt + 8`: 💡 **Objetos**
* `Alt + 9`: 🔣 **Símbolos**
* `Alt + 0`: 🇧🇷 **Bandeiras**
* `Alt + BackSpace` (ou pressionar o mesmo número novamente): **Reset / Ver Todos**

---

## 🔬 2. Necropsia Forense: O Pesadelo dos `DDD` e Armadilhas do Rofi/Pango

Durante o desenvolvimento do motor de busca, um bug crítico gerou uma tela cheia de `DDD` em vez dos emojis e legendas. Abaixo está a documentação técnica para nunca mais cair nessa armadilha.

### 🐛 Causa-Raiz 1: O Bug do `size="0"` no Pango Markup (Origem dos `DDD`)
* **O que tentamos fazer:** Para tornar palavras-chave, sinônimos em PT-BR e gírias pesquisáveis no Rofi dmenu sem poluir a interface visual, tentou-se colocar as tags ocultas usando `<span size="0">tags aqui</span>`.
* **O que o Pango fez:** A engine gráfica do **Pango** (responsável pela renderização de texto e fontes no GTK/Rofi) **não aceita `size="0"`**. A especificação considera tamanho 0 como um atributo de fonte inválido/inconsistente.
* **O Efeito Colateral:** Ao encontrar uma tag inválida ou inconsistente durante a formatação em lote, o parser do Pango quebra a tabela de glifos da fonte naquela linha ou renderiza o caractere de fallback/erro da fonte (no caso, os glifos de controle corrompidos que aparecem como **`DDD`** repetidos no buffer do Rofi).
* **A Solução Definitiva:** 
  1. Ocultar metadados através de formatação visual limpa e contrastada (ex: `alpha="25%"` ou cores atenuadas) OU manter apenas as tags essenciais em uma linha única e legível com escape HTML estrito (`html.escape`).
  2. **Nunca** utilizar atributos com valores zerados ou não documentados no Pango (`size="0"`, `scale="0"`, tags de estilo inválidas).

### 🐛 Causa-Raiz 2: Conflito de Keybindings Readline nativos do Rofi
* **O problema:** Por padrão, o Rofi vem de fábrica com atalhos de readline do Emacs embutidos:
  * `Ctrl + k`: Executa `kb-remove-to-eol` (apaga o texto até o final da linha).
  * `Ctrl + u`: Executa `kb-remove-to-sol` (apaga o texto até o início da linha).
  * `Ctrl + d`: Executa `kb-remove-char-forward` (deleta o caractere à direita).
* **O sintoma:** Quando tentávamos usar `Ctrl+k` para subir ou `Ctrl+d` / `Ctrl+u` para scroll meia página estilo Vim, o Rofi engolia os atalhos e deletava o texto da busca ao invés de navegar.
* **A Solução Definitiva:** No arquivo `config-emoji.rasi`, desvincular explicitamente os atalhos conflitantes antes de registrar os de navegação:
  ```rasi
  configuration {
      kb-remove-to-eol:       "";
      kb-remove-to-sol:       "";
      kb-remove-char-forward: "Delete";
      kb-row-up:              "Up,Control+k,Control+p,ISO_Left_Tab,BackTab";
      kb-row-down:            "Down,Control+j,Control+n,Tab";
      kb-page-prev:           "Page_Up,Control+u";
      kb-page-next:           "Page_Down,Control+d";
      kb-accept-entry:        "Return,KP_Enter";
      kb-cancel:              "Escape,Control+bracketleft";
  }
  ```

### 🐛 Causa-Raiz 3: Interação de Return Codes do Rofi Dmenu
* O Rofi Dmenu possui códigos de saída específicos:
  * `0`: Entrada aceita com `Enter`.
  * `1`: Cancelado (`Esc`).
  * `10` a `19`: `kb-custom-1` a `kb-custom-10` (`Alt+1` a `Alt+0`).
  * `20`: `kb-custom-11` (`Ctrl+y`).
  * `21`: `kb-custom-12` (`Alt+BackSpace`).
* O motor em Python faz um loop de controle (`while True`) que intercepta os códigos `10..19` e `21`, atualiza o filtro (`-filter "#categoria "`) e relança o Rofi instantaneamente sem fechar a sessão do usuário.

### 🐛 Causa-Raiz 4: O Bug do Truncamento de 16-bit do `wtype` (Glifos CJK Estranhos como `鸞`)
* **O sintoma:** Ao tentar digitar emojis modernos do plano suplementar Unicode (ex: Rosto com Chapéu de Caubói 🤠 `U+1F920`), o `wtype` cuspia um caractere chinês/coreano estranho (`鸞` `U+F920`).
* **A necropsia:** O `wtype` internamente compila keycodes usando tipos de 16 bits (`uint16_t`) ao simular `xkb_keysym`. Emojis além do plano básico (`U+10000` até `U+10FFFF`) sofrem overflow e têm os bits superiores decepados: `0x1F920 & 0xFFFF = 0xF920` (que é o caractere CJK Compatibility Ideograph `鸞`).
* **A Solução Definitiva (Injeção Inteligente via Clipboard / Auto-Paste):**
  1. O motor copia o caractere UTF-8 íntegro com `wl-copy`.
  2. Identifica a classe da janela que estava em foco antes do Rofi abrir (`hyprctl activewindow -j`).
  3. Se for terminal (`kitty`, `ghostty`, etc.), simula `Ctrl + Shift + V`.
  4. Se for aplicativo gráfico comum (`brave`, `chrome`, `code`, `discord`, etc.), simula `Ctrl + V`.
  5. Resultado: **100% de precisão para qualquer emoji**, sem risco de truncamento e sem depender de rotinas de xkb bugadas.

---

## 📦 3. Dependências e Provisionamento Automático

Para que o seletor de emojis funcione em qualquer máquina recém-formatada sem nenhuma intervenção manual, os seguintes pacotes são obrigatórios:

| Pacote | Função | Repositório |
|---|---|---|
| `rofi-wayland` | Seletor e menu flutuante Wayland | Arch Extra / CachyOS |
| `wtype` | Emulador de digitação direta no Wayland (digita o emoji no app em foco) | Arch Extra / CachyOS |
| `wl-clipboard` | Fornece `wl-copy` para colocar o emoji na área de transferência | Arch Extra |
| `noto-fonts-emoji` | Glifos coloridos e completos de emojis Unicode | Arch Extra |
| `python` | Execução do script do motor (`rofi_emoji_engine.py`) | Arch Core |
| `libnotify` / `swaync` | Notificações do sistema (`notify-send`) no modo Yank (`Ctrl+y`) | Arch Extra |

### 🛠️ Configuração Já Integrada nos Scripts de Instalação:
1. **`packages/pacman-native.txt`**: Contém `wtype`, `wl-clipboard`, `noto-fonts-emoji`, `rofi-wayland`.
2. **`Arch-Hyprland-main/install-scripts/01-hypr-pkgs.sh`**: Contém `wtype` garantido no lote principal de instalação rápida.
3. **`Arch-Hyprland-main/install-scripts/fonts.sh`**: Instalação expressa de `noto-fonts-emoji`.
4. **`setup.sh`**: Executa a instalação de todos os pacotes nativos e configura os dotfiles de forma autônoma.

---

## 📁 4. Mapa dos Arquivos de Código do Motor

* 🐍 **Motor Python Principal:**  
  [`home/dot_config/hypr/scripts/rofi_emoji_engine.py`](file:///home/lan/dotfiles/home/dot_config/hypr/scripts/rofi_emoji_engine.py)
* 🎨 **Tema e Keybinds do Rofi:**  
  [`home/dot_config/rofi/config-emoji.rasi`](file:///home/lan/dotfiles/home/dot_config/rofi/config-emoji.rasi)
* 🗄️ **Base de Dados Semântica PT-BR:**  
  [`home/dot_config/rofi/emoji_pt_br.json`](file:///home/lan/dotfiles/home/dot_config/rofi/emoji_pt_br.json)
* 📜 **Launcher Shell (com Toggle de Processo):**  
  [`home/dot_config/hypr/scripts/RofiEmoji.sh`](file:///home/lan/dotfiles/home/dot_config/hypr/scripts/RofiEmoji.sh)
* 📦 **Script de Construção do Banco de Emojis:**  
  [`scripts/build_emoji_db.py`](file:///home/lan/dotfiles/scripts/build_emoji_db.py)

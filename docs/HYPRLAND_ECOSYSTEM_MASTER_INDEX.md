# 🏛️ ÍNDICE MESTRE: ECOSSISTEMA HYPRLAND & ATALHOS DO COCKPIT

> **Documento SSOT (Single Source of Truth) para o ecossistema Hyprland no CachyOS.**  
> Este arquivo é referenciado diretamente pelas regras de contexto do agente (`RULES.md` / `AGENTS.md`) para garantir que qualquer IA sempre saiba exatamente todos os atalhos, scripts e janelas configurados.

---

## ⚡ 1. Dropdown Scratchpads sob Demanda (Quake / Stealth Mode)

Janelas especiais de dimensão oculta (`special:workspace`). Não aparecem na barra de tarefas, preservam o estado, não reiniciam e surgem/desaparecem com um único toque.

| Atalho | Destino / Aplicação | Script / Comando | Comportamento / Estética |
|---|---|---|---|
| `SUPER + W` | 💬 **WhatsApp Web** | `~/.config/hypr/scripts/whatsapp-toggle.sh` | Centralizado (78% x 84%), bordas arredondadas, foco automático |
| `SUPER + I` | 🤖 **Oráculo de IA** (Google AI / Chatbot) | `~/.config/hypr/scripts/ai-toggle.sh` | Centralizado (74% x 82%), link dedicado com busca avançada |
| `SUPER + M` | 🎵 **Spotify / Spicetify** | `~/.config/hypr/scripts/spotify-toggle.sh` | Flutuante com blur Catppuccin e cantos suaves (66% x 72%) |
| `SUPER + T` | 🎯 **TecConcursos** | `~/.config/hypr/scripts/tecconcursos-toggle.sh` | Treinamento de questões 60s centralizado (74% x 80%) |
| `SUPER + '` (grave) / `SUPER + U` | 💻 **Terminal Quake** | `~/.config/hypr/scripts/scratchpad-term.sh` | Terminal suspenso imediato para comandos rápidos (74% x 70%) |

---

## 🧮 2. Produtividade, Utilitários & Ferramentas Rápidas

| Atalho | Ação | Aplicativo / Script |
|---|---|---|
| `SUPER + C` | 🧮 Calculadora Rápida (Moedas e Unidades) | `gnome-calculator` (Flutuante centralizado) |
| `SUPER + ALT + C` | 📐 Calculadora Científica & Financeira | `qalculate-gtk` |
| `SUPER + V` | 📋 Histórico da Área de Transferência (2ms) | `Cliphist + Rofi` |
| `ALT + V` / `SUPER + ALT + V` | 📑 Clipboard Manager Avançado com Abas | `CopyQ` |
| `SUPER + .` ou `SUPER + ;` | 😀 Apex Emoji Engine (Busca PT-BR) | `RofiEmoji.sh` com suporte a wtype |
| `SUPER + D` | 🚀 Menu de Aplicativos | `RofiLauncher.sh drun` |
| `SUPER + Return` | 🖥️ Terminal Padrão Tiling | `Ghostty / Kitty` |
| `SUPER + E` | 📂 Explorador de Arquivos no Grid Tiling | `open-yazi-tiled.sh` (Yazi) |
| `SUPER + SHIFT + E` | 📁 Explorador de Arquivos Flutuante Compacto | `open-yazi.sh` (Yazi) |
| `SUPER + SHIFT + D` | 🪪 Upload Rápido de Documentos | `open-acesso-rapido.sh` (RG, CNH, Comprovantes) |
| `SUPER + O` | 🔑 Ghost OTP (2FA do Gmail) | `gmail-otp.py` (Copia código de verificação) |

---

## 📸 3. Mídia, Capturas & Gravação

| Atalho | Ação | Script / Ferramenta |
|---|---|---|
| `SUPER + SHIFT + S` ou `Print` | 📸 Captura de Tela Avançada com Anotações | `ScreenShot.sh --flameshot` |
| `SUPER + SHIFT + R` ou `SUPER + ALT + R` | 🎥 Gravação de Tela MP4/GIF | `screen-record.sh` (`wf-recorder`) |
| `SUPER + SHIFT + T` | 🔍 OCR de Tela (Copiar texto da imagem) | `ocr-screen.sh` (`tesseract + zbarimg`) |
| `SUPER + ALT + T` | 🌐 OCR com Tradução Instantânea para PT-BR | `ocr-screen.sh --translate` |
| `SUPER + SHIFT + P` | 🎨 Conta-Gotas / Color Picker HEX | `hyprpicker -a -f hex` |
| `SUPER + SHIFT + L` | 🎤 Letras Sincronizadas em Tempo Real (Karaokê) | `lyrics-toggle.sh` (`sptlrx`) |
| `SUPER + CTRL + Space` | ⏯️ Play / Pause de Mídia | `MediaControl.sh --play-pause` |
| `SUPER + CTRL + ]` / `[` | ⏭️ Próxima Faixa / Faixa Anterior | `MediaControl.sh --next` / `--prev` |

---

## 🎧 4. Áudio & Hardware de Estúdio

| Atalho / Recurso | Ação | Detalhes Técnicos |
|---|---|---|
| `SUPER + SHIFT + A` | 🔀 Alternador de Saída de Som | Caixa de Som ⇄ Fone de Ouvido (`audio-switch.sh`) |
| `SUPER + ALT + A` | 🎧 Seletor Visual de Presets de Áudio | Menu Rofi (`audio-preset-switch.sh`) |
| `SUPER + ALT + M` | 🎙️ Mute / Desmute do Microfone | `Volume.sh --toggle-mic` |
| **Microfone Studio** | 🧠 **DeepFilterNet + Compressor + EQ** | Preset `Podcast_Studio_Mic` ativo via EasyEffects/PipeWire |
| **Webcam C270** | 📷 **30 FPS Cravados + Anti-Glare Sol** | Regra udev `99-logitech-c270.rules` + `webcam-c270-tune.sh` |

---

## 🪟 5. Gerenciamento de Janelas & Workspaces

| Atalho | Ação |
|---|---|
| `SUPER + Q` | Fechar Janela Ativa (**Kill**) |
| `SUPER + Backspace` | Mata-Processo de Emergência (Mira assassina para apps travados) |
| `SUPER + F` | Alternar Tela Cheia (**Fullscreen Toggle**) |
| `SUPER + SHIFT + Space` | Alternar Janela Flutuante (**Floating Toggle**) |
| `ALT + Tab` / `ALT + SHIFT + Tab` | **Bate-e-Volta de Workspaces** (Alterna entre o atual e o anterior instantaneamente) |
| `SUPER + Tab` | Seletor Visual de Janelas no Rofi |
| `SUPER + H / J / K / L` ou Setas | Mover foco de navegação entre janelas |
| `SUPER + 1..9` | Navegar para o Workspace correspondente |
| `SUPER + SHIFT + 1..9` | Mover janela ativa para o Workspace correspondente |
| `CTRL + SHIFT + Esc` ou `SUPER + Esc` | Gerenciador de Tarefas `btop` em janela flutuante rápida |

---

## 📂 6. Mapa de Arquivos de Configuração do Hyprland

* **Atalhos do Usuário:** `~/dotfiles/home/dot_config/hypr/UserConfigs/UserKeybinds.conf`
* **Regras de Janelas & Dropdowns:** `~/dotfiles/home/dot_config/hypr/UserConfigs/WindowRules.conf`
* **Inicialização de Apps:** `~/dotfiles/home/dot_config/hypr/UserConfigs/Startup_Apps.conf`
* **Scripts do Hyprland:** `~/dotfiles/home/dot_config/hypr/scripts/` e `~/.config/hypr/scripts/`
* **Scripts Gerais do Sistema:** `~/dotfiles/scripts/`
* **Guias e Manuais:** `~/dotfiles/docs/`

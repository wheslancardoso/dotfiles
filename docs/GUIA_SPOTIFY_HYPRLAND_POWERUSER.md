# 🎵 GUIA DEFINITIVO DO SPOTIFY POWER-USER NO HYPRLAND
### Experiência Audiovisual de Alta Fidelidade, Dropdown Scratchpad & Spicetify

> **O Efeito "Karalho"**: Esqueça o cliente Spotify feio, genérico e com propagandas. No Arch Linux com Hyprland e dotfiles, o Spotify se transforma em uma suíte flutuante com blur translúcido, tema Catppuccin Mocha, letras estilo Apple Music Karaoke, bloqueio de anúncios e controles instantâneos no teclado!

---

## ⚡ 1. Os 5 Pilares da Experiência Superior

1. **🪟 Dropdown Scratchpad (`SUPER + M`)**: O Spotify não ocupa seu espaço de trabalho. Ele vive no `special:spotify` e desce suavemente flutuando no centro da tela ao apertar `SUPER + M`. Aperte de novo e ele some sem parar a reprodução.
2. **🎨 Spicetify + Catppuccin Mocha**: Interface personalizada com cantos arredondados, paleta moderna e harmonizada com seu sistema.
3. **🚫 Adblock Nativo**: Bloqueio total de anúncios de áudio e banners no aplicativo oficial do Linux via extensão do Spicetify.
4. **🎤 Letras Estilo Karaoke (Lyrics-Plus)**: Letras sincronizadas linha por linha com gradientes dinâmicos que mudam de cor conforme a capa do álbum.
5. **🖼️ Notificações com Capa em Alta Resolução**: Mudou de música? Uma notificação estética surge com a capa do álbum real, artista e nome da faixa.
6. **⚡ Spotify Terminal (`spotify-player`)**: Para quem quer ouvir música enquanto programa no Neovim sem consumir 800MB de RAM de Electron.

---

## 🪟 2. O Dropdown Scratchpad (`SUPER + M`)

*O jeito mais rápido do mundo de controlar suas músicas:*

| Atalho | Ação | Comportamento |
|---|---|---|
| `SUPER + M` | **Abrir/Ocultar Spotify** | Desce uma janela flutuante elegante (72% de largura, centralizada, com blur e cantos arredondados). Aperte de novo para ocultar! |
| `SUPER + CTRL + Espaço` | **Play / Pause** | Pausa ou retoma a reprodução sem abrir o Spotify. |
| `SUPER + CTRL + ]` | **Próxima Faixa** | Pula para a próxima música. |
| `SUPER + CTRL + [` | **Faixa Anterior** | Volta para a música anterior. |
| Teclas Multimídia | **Play / Pause / Next / Prev** | Teclas de hardware do teclado (`XF86Audio...`) 100% integradas. |

---

## 🎨 3. Spicetify: Transformando o Spotify em Arte

O aplicativo padrão do Spotify no Linux é fechado e visualmente genérico. O **Spicetify** injeta CSS, JavaScript e extensões para torná-lo extraordinário.

### 🚀 Instalação e Ativação em 1 Comando:
Criamos um script que automatiza tudo (permissões do Linux, backup, tema e extensões):

```bash
bash ~/dotfiles/scripts/setup-spicetify.sh
```

### ✨ O que o Script Ativa Automaticamente:
1. **Tema Catppuccin Mocha**: Visual moderno com azul, lilás e fundo dark sofisticado.
2. **Adblock (`adblock.js`)**: Elimina todos os anúncios de áudio e banners intrusivos.
3. **Lyrics-Plus**: Letras ao vivo sincronizadas com efeito karaoke e tradução.
4. **FullAppDisplay**: Pressione `F11` dentro do Spotify para um modo cinematográfico de estúdio com capa em blur pulsante no fundo.
5. **Shuffle+**: Randomização de verdade para não ouvir sempre as mesmas faixas.
6. **Trashbin**: Botão direto na barra para banir músicas que você não gosta das rádios automáticas.

---

## ⚡ 4. Spotify no Terminal: `spotify-player` (Rust TUI)

Para quem está programando no **LazyVim** + **Zellij** e quer consumo de memória quase zero:

```bash
# Executa o cliente TUI super leve (consome <30MB de RAM)
spotify-player
```

- **Navegação Vim**: Use `h`, `j`, `k`, `l` para navegar por playlists e álbuns.
- **Espectro de Áudio**: Visualizador gráfico de frequências integrado dentro do terminal.
- **Letras no Terminal**: Pressione `l` para ver a letra da música atual sincronizada.
- **Zero Distração**: Não abre navegadores nem janelas pesadas.

---

## 🖼️ 5. Notificações Ricas com Capa do Álbum (`MusicNotification.sh`)

O Hyprland já inicia em segundo plano o daemon [`MusicNotification.sh`](file:///home/lan/dotfiles/home/dot_config/hypr/UserScripts/MusicNotification.sh):
- Monitora os eventos do Spotify via protocolo MPRIS (`playerctl`).
- Ao mudar de faixa, baixa a imagem oficial da capa do álbum e emite uma notificação elegante no **SwayNC** com:
  - Capa do disco em alta definição.
  - Nome da faixa em negrito.
  - Artista e nome do álbum.

---

## 🧩 6. Arquivos e Configurações no Dotfiles

- [`scripts/setup-spicetify.sh`](file:///home/lan/dotfiles/scripts/setup-spicetify.sh): Instalador e configurador automático do Spicetify.
- [`home/dot_config/hypr/scripts/spotify-toggle.sh`](file:///home/lan/dotfiles/home/dot_config/hypr/scripts/spotify-toggle.sh): Runner do scratchpad flutuante para `SUPER + M`.
- [`home/dot_config/hypr/UserConfigs/WindowRules.conf`](file:///home/lan/dotfiles/home/dot_config/hypr/UserConfigs/WindowRules.conf): Regras de janela para o Spotify (float, center, blur, 72% de tamanho, workspace especial).
- [`home/dot_config/hypr/UserConfigs/UserKeybinds.conf`](file:///home/lan/dotfiles/home/dot_config/hypr/UserConfigs/UserKeybinds.conf): Mapeamento de `SUPER + M` e controles multimídia globais.
- [`packages/pacman-aur.txt`](file:///home/lan/dotfiles/packages/pacman-aur.txt): Pacotes `spotify`, `spicetify-cli` e `spotify-player` incluídos.

# 🧘 GUIA DEFINITIVO DO SETUP COMFORT SENIOR (ZERO ATRITO)
### O Guia Mestre de Produtividade, Ergonomia e Fluidez no Arch Linux + Hyprland

> **A Filosofia Senior**: Um setup verdadeiramente sênior não é sobre ter centenas de atalhos difíceis de lembrar, mas sim sobre **eliminar qualquer microatrito que tire você do estado de hiperfoco (Flow State)**. Tudo responde em microssegundos, o áudio toca com um toque, arquivos se organizam sozinhos e você nunca é interrompido por janelas desnecessárias.

---

## ⚡ 1. Mapa dos Atalhos de Puro Conforto

| Atalho | Categoria | O que faz no Sistema? |
|---|---|---|
| `Super + M` | 🎵 **Spotify** | Desce o **Spotify Flutuante** do topo com efeito glass/blur Catppuccin. Aperte de novo para ocultar. |
| `Super + Ctrl + Espaço` | ⏯️ **Mídia** | Play / Pause da música de qualquer lugar (jogo, editor, terminal). |
| `Super + Ctrl + ]` / `[` | ⏭️ **Mídia** | Pular para a próxima faixa / Voltar faixa anterior. |
| `Super + Alt + B` | 🔵 **Bluetooth** | Menu rápido no Rofi para ligar, desligar e conectar fones/controles com 1 clique. |
| `Super + Alt + W` | 📶 **Wi-Fi** | Menu rápido no Rofi com intensidade do sinal e conexão a redes sem abrir janelas. |
| `Super + Alt + A` | 🔀 **Áudio** | Alternar na hora entre Caixa de Som e Fone de Ouvido / Headset. |
| `Super + Alt + M` | 🎙️ **Microfone** | Silenciar / Ativar o Microfone globalmente (**Mic Mute Toggle**) com OSD. |
| `Super + Alt + S` | 🎮 **Jogos** | Sincroniza e faz backup na nuvem de todos os seus saves de jogos via Ludusavi. |
| `Super + Alt + R` | 🎥 **Gravação** | Inicia/para gravação da tela em MP4 de alta qualidade ou GIF animado. |
| `Super + Alt + D` | 📥 **Download** | Baixa vídeo ou áudio da URL copiada (aceleração multi-conexão aria2c ou comando `dl`). |
| `Super + Shift + S` ou `Print` | ✂️ **Screenshot** | Captura de região com anotações, setas e blur via **Flameshot** (com fallback). |
| `Super + Shift + T` | 🔍 **OCR** | Seleciona qualquer área da tela e copia o texto de imagens/vídeos para o clipboard. |
| `Super + Shift + P` | 🎨 **Cor** | Conta-gotas (Color Picker): clica em qualquer pixel da tela e copia o código HEX. |
| `Super + Shift + N` | 🔔 **Notificações**| Central SwayNC com histórico, controle de volume e botão **Não Perturbe (DND)**. |
| `Super + N` | 🌙 **Luz Noturna** | Ativa/desativa filtro de luz azul quente (Hyprsunset) para conforto visual noturno. |
| `Super + E` | 📂 **Arquivos** | Yazi File Manager em tela dividida (Tiling). |
| `Super + Shift + E` | 📂 **Arquivos** | Yazi File Manager em janela flutuante no centro da tela. |
| `Super + Shift + D` | 🪪 **Documentos** | Acesso Rápido flutuante com seus documentos essenciais (CNH, RG, comprovantes). |
| `Super + V` | 📋 **Clipboard Rápido** | Abre o Cliphist no Rofi com busca instantânea (fuzzy search 2ms) para colar rápido. |
| `Super + D` | 🚀 **Launcher** | Rofi App Launcher oficial (busca instantânea de aplicativos). |
| `Super + H` ou `Super + /`| ❓ **Ajuda** | Cheat Sheet gráfico interativo com todos os atalhos mapeados e busca. |

---

## 🧠 O Modelo Mental Anti-Confusão (A Regra dos 3 Andares)

Para você **nunca se perder nem precisar decorar dezenas de teclas isoladas**, todos os atalhos foram arquitetados em uma hierarquia mnemônica estrita de 3 andares:

```
Andar 1: SUPER puro               ──> O Dia a Dia de Janelas e Apps Vitais
Andar 2: SUPER + ALT + [Letra]    ──> Painel de Hardware & Conexões (Mnemônico)
Andar 3: SUPER + SHIFT + [Letra]  ──> Utilitários Especiais de Tela & Captura
```

### 🏢 Andar 1 — `SUPER` Puro (Janelas & Apps do Dia a Dia)
Apenas a tecla Super + a letra principal do app:
- `Super + Return` = Terminal
- `Super + E` = Explorador de arquivos (Yazi)
- `Super + M` = Spotify Dropdown
- `Super + V` = Clipboard
- `Super + C` = Calculadora
- `Super + Q` = Fechar Janela

### ⚙️ Andar 2 — `SUPER + ALT + [Letra]` (Hardware & Conexões)
Tudo que mexe com conexão de hardware usa **`Super + Alt`** + **a primeira letra do componente**:
- `Super + Alt + B` = **B**luetooth (Ligar/desligar, bateria e fones)
- `Super + Alt + W` = **W**i-Fi (Redes e conexão rápida)
- `Super + Alt + A` = **A**udio Output (Alternar Caixa <-> Fone)
- `Super + Alt + M` = **M**icrophone Mute (Silenciar mic de qualquer lugar)
- `Super + Alt + S` = **S**aves de Jogos (Backup em nuvem com Ludusavi)
- `Super + Alt + R` = **R**ecord (Gravação de tela)
- `Super + Alt + D` = **D**ownload de vídeo/áudio da URL (yt-dlp acelerado com 16 conexões)

> **💡 Regra de Ouro**: Precisa mexer em qualquer hardware ou conexão? É sempre `Super + Alt` + Primeira Letra! Zero confusão mental.

### 📸 Andar 3 — `SUPER + SHIFT + [Letra]` (Captura & Utilitários Visuais)
Ações avançadas de tela e ferramentas auxiliares:
- `Super + Shift + S` ou `Print` = **S**creenshot com corte, setas, desfoque e anotações (**Flameshot**)
- `Super + Shift + P` = Color **P**icker (Conta-gotas de cor)
- `Super + Shift + T` = **T**ext OCR (Copiar texto de qualquer imagem/vídeo)
- `Super + Shift + N` = **N**otificações & Central de Controle (SwayNC)
- `Super + Shift + G` = **G**ame Mode (Desativa animações para ganho absurdo de FPS)
- `Super + Shift + D` = **D**ocumentos de Acesso Rápido

---

## 🎵 2. Suíte de Áudio & Spotify de Alta Fidelidade

- **Dropdown Scratchpad**: O Spotify fica rodando no workspace especial `special:spotify`. Dar `Super + M` faz a interface descer flutuando suavemente na tela.
- **Spicetify Automator**: Rode `bash ~/dotfiles/scripts/setup-spicetify.sh` para transformar o Spotify oficial com:
  - **Tema Catppuccin Mocha** nativo.
  - **Zero anúncios** (bloqueador embutido no app).
  - **Letras sincronizadas** estilo Apple Music Karaoke (`Lyrics-Plus`).
  - **Tela cheia cinematográfica** com álbum em blur pulsante (`F11`).
- **Terminal Spotify (`spotify-player`)**: Cliente em Rust que consome menos de 30MB de RAM e roda no terminal com visualizador de áudio e letras.

---

## 🌐 3. Conectividade Instantânea (Bluetooth & Wi-Fi)

Chega de abrir telas pesadas de configurações do sistema:
- **`Super + Alt + B` (Bluetooth)**: Lista se o Bluetooth está ligado, lista seus fones (JBL, AirPods, etc.), controles (Xbox/PS5) e mouses, exibindo a porcentagem de bateria e permitindo conectar/desconectar instantaneamente.
- **`Super + Alt + W` (Wi-Fi)**: Lista redes próximas com barras de sinal (`▂▄▆█`), identifica a rede atual e pede a senha se for nova conexão.

---

## 🗂️ 4. Fluxo Web e Arquivos Sem Fricção

- **Downloads sem Janelas**: No navegador, deixe ativado para baixar direto em `~/Downloads`. Como ele é um link simbólico para `/mnt/dados/00_Inbox`, você clica em download e ele baixa em 0 segundos, sem janelas.
- **File Chooser Flutuante com Yazi**: Quando um site exige escolher arquivo para upload ou "Salvar Como", o Hyprland abre o **Yazi Flutuante** no centro da tela (`yazi-picker.sh`), permitindo navegar, renomear (`r`) e confirmar (`Enter`) em microssegundos.
- **Drag & Drop do Terminal (`<Ctrl + y>`)**: No Yazi, aperte `<Ctrl + y>` para abrir a caixinha do `ripdrag` e arrastar arquivos direto para o Discord, Telegram ou navegador.
- **AirDrop Universal com LocalSend (`M l` no Yazi)**: Selecione qualquer arquivo no Yazi, tecle `M l` e o LocalSend abre na hora para transferir para o seu celular (Android/iOS) ou outro PC via Wi-Fi em velocidade máxima.
- **Visualizadores Ultrarrápidos no Yazi (`<Enter>`)**:
  - **Imagens**: Abre no **`imv`** em 0.01s (Wayland puro, atalhos de setas e zoom no scroll).
  - **Markdown (`.md`)**: Abre no **`glow -p`** (terminal estilizado com paginação e cores Catppuccin).
  - **PDFs**: Abre no **`zathura`** (navegação Vim `j/k`, inversão de cores com `Ctrl+r` e zero travamento).
- **Auto-CD no Terminal (`y`)**: No Zsh, Bash ou Fish, digite `y`, navegue até a pasta desejada e ao sair com `q`, seu terminal já estará dentro dela!

---

## 🧹 5. Automação e Manutenção do Sistema

### 🤖 Triagem Automática em Background
Você pode deixar o **Organizador Master** rodando silenciosamente como serviço de usuário:
```bash
systemctl --user enable --now organizador-watcher.service
```
Qualquer arquivo baixado no `00_Inbox` será automaticamente categorizado e renomeado sem você mover um dedo.

### 🧹 Comandos de Manutenção no Terminal
- **`cleanup`** : Faxina geral no Arch Linux:
  - Remove pacotes órfãos sem uso (`pacman -Qtdq`).
  - Limpa cache de pacotes antigos do pacman.
  - Trunca logs do systemd para os últimos 7 dias.
  - Limpa miniaturas e cache de usuário.
  - Verifica se há algum serviço do sistema em falha.
- **`sys-update`** : Atualização segura completa:
  - Sincroniza pacotes oficiais e AUR.
  - Atualiza Flatpaks.
  - Roda o auditor de saúde do Organizador Master (`organizar --doctor`).

---

## 🧩 6. Conclusão: O Estado da Arte

Com essa arquitetura:
1. Seu disco está dividido e protegido na partição `/mnt/dados` com symlinks limpos.
2. Seu terminal tem auto-cd, histórico inteligente com setas, e o Yazi mais rápido do mundo.
3. Seu áudio e mídias respondem instantaneamente por teclas globais.
4. Seu ambiente gráfico Hyprland tem animações fluidas, cantos arredondados, blur Catppuccin e zero atrito com arquivos.
5. Todos os scripts são versionados no Git com sincronização contínua via dotfiles.

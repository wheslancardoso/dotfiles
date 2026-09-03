# 🚀 Guia de Setup e Instalação Automatizada (PC Master & Dev Suite)

> **Instalação em lote de todos os programas essenciais para um usuário avançado e desenvolvedor de alto nível.**

---

## 🌌 Como Executar no Arch Linux (Setup One-Shot Hyprland + Vibe Coding)

### Método 1: Clonar o Dotfiles e Rodar o Setup (Recomendado)
Caso já tenha o Arch Linux básico instalado:
```bash
git clone https://github.com/wheslancardoso/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```
> O `setup.sh` detecta automaticamente se o Hyprland e seus componentes já estão presentes. Se não estiverem, oferece a inicialização imediata do instalador base com o **Preset Mestre**.

---

### Método 2: Instalação One-Shot do Arch-Hyprland (Máquina Recém-Formatada)
Se você acabou de instalar o Arch Linux mínimo e quer subir todo o ecossistema com **NVIDIA RTX**, **SDDM**, **Hyprland** e **Dotfiles** sem responder a dezenas de caixas de diálogo:

```bash
git clone https://github.com/wheslancardoso/dotfiles.git ~/dotfiles
cd ~/dotfiles/Arch-Hyprland-main
chmod +x install-master.sh
./install-master.sh
```

#### O que o instalador mestre faz de forma 100% automatizada?
1. 🚀 **Pacman com Multilib & Aceleração**: Ativa o repositório `[multilib]` (indispensável para **Steam**, **Wine**, **Proton-GE** e **FitGirl Repacks**), downloads paralelos e visual `ILoveCandy`.
2. 📦 **AUR Helper (Yay)**: Instala e configura o `yay` sem interrupções manuais.
3. 🎮 **Drivers NVIDIA RTX & 32-bit**: Instala `nvidia-dkms`, `nvidia-settings`, `nvidia-utils`, `lib32-nvidia-utils`, `lib32-libva-nvidia-driver` e `egl-wayland`, configurando `modeset=1 fbdev=1` no GRUB/systemd-boot e gerando o initramfs com `mkinitcpio`.
4. 🔊 **PipeWire de Baixa Latência**: Instala e ativa `pipewire`, `pipewire-pulse` e `wireplumber` (com correção de escopo de loop do instalador upstream).
5. 🪟 **Hyprland & Ecossistema Wayland**: Instala Hyprland, Waybar, SDDM com tema animado, SwayNC, Wallust, Awww (sucessor oficial do `swww`), Rofi e XDPH.
6. 🔗 **Integração Nativa via Chezmoi (Modo Symlink & Bitwarden)**: Conecta diretamente o seu repositório `~/dotfiles`, provisionando instantaneamente LazyVim, Zellij (layout vibe), Yazi, EasyEffects e regras de janela.

---

## ⚡ Como Executar no Windows

### Método 1: Pelo Script Incluso no Projeto (Recomendado)
1. Abra a pasta `scripts/` do projeto.
2. Clique duas vezes em **[`Instalar-Programas-PC.bat`](./scripts/Instalar-Programas-PC.bat)**.
3. Escolha a opção `[1]` para instalar o stack completo silenciosamente.

---

### Método 2: One-Liner Direto no Terminal (PowerShell Administrador)

Caso tenha acabado de formatar o computador e ainda não baixou o repositório, abra o **PowerShell como Administrador** e cole:

```powershell
winget install --id Google.Chrome -e; winget install --id Brave.Brave -e; winget install --id voidtools.Everything -e; winget install --id Flow-Launcher.Flow-Launcher -e; winget install --id M2Team.NanaZip -e; winget install --id RARLab.WinRAR -e; winget install --id Hluk.CopyQ -e; winget install --id Skillbrains.Lightshot -e; winget install --id Flameshot.Flameshot -e; winget install --id FluxSoftware.Flux -e; winget install --id AnyDeskSoftwareGmbH.AnyDesk -e; winget install --id ABDownloadManager.ABDownloadManager -e; winget install --id Obsidian.Obsidian -e; winget install --id Anki.Anki -e; winget install --id Foxit.FoxitReader -e; winget install --id DuongDieuPhap.ImageGlass -e; winget install --id Daum.PotPlayer -e; winget install --id VideoLAN.VLC -e; winget install --id shinchiro.mpv -e; winget install --id SmartCode.Stremio -e; winget install --id Spotify.Spotify -e; winget install --id qBittorrent.qBittorrent -e; winget install --id Discord.Discord -e; winget install --id Telegram.TelegramDesktop -e; winget install --id Microsoft.WindowsTerminal -e; winget install --id Git.Git -e; winget install --id Python.Python.3.12 -e; winget install --id OpenJS.NodeJS.LTS -e; winget install --id Microsoft.VisualStudioCode -e; winget install --id dbeaver.dbeaver -e; winget install --id Usebruno.Bruno -e; winget install --id Oracle.VirtualBox -e; winget install --id VMware.WorkstationPro -e; winget install --id AdvancedMicroDevices.AMDSoftwareAdrenalinEdition -e --accept-package-agreements --accept-source-agreements
```

---

## 🧹 Otimização & Ativação Oficial

### 1. Debloat & Limpeza do Windows (Chris Titus WinUtil)
Remove telemetria invasiva, bloatwares da Microsoft e desativa serviços desnecessários:
```powershell
irm https://christitus.com/win | iex
```

### 2. Ativação Permanente do Windows & Office (MAS)
Método oficial seguro (HWID / KMS38):
```powershell
irm https://massgrave.dev/get | iex
```

---

## 📦 Grade Mestre de Softwares de Elite

| Categoria | Softwares Incluídos | Por que é padrão ouro? |
|---|---|---|
| **Navegação** | Google Chrome, Brave Browser | Compatibilidade universal e bloqueio nativo de anúncios |
| **Busca & Launcher** | Everything, Flow Launcher | Localiza qualquer arquivo do PC em menos de 1 segundo |
| **Compactadores** | NanaZip, WinRAR | NanaZip integra no menu do Windows 11 com alta compressão |
| **Clipboard & Print** | CopyQ, Lightshot, Flameshot | Histórico infinito de CTRL+C e anotações rápidas em prints |
| **Downloads & Remoto** | AB Download Manager, AnyDesk | Acelerador de download moderno estilo IDM e acesso remoto ágil |
| **Produtividade & Notas** | Obsidian, Anki, Foxit, ImageGlass | Second Brain em Markdown local + repetição espaçada |
| **Mídia & Streaming** | PotPlayer, mpv, VLC, Stremio, Spotify | Os players mais leves e com melhor renderização do mercado |
| **Comunicação** | Discord, Kotatogram / Telegram | Clientes rápidos e customizáveis |
| **Desenvolvimento & DB** | Windows Terminal, VS Code, Git, Python 3.12, Node.js, DBeaver, Bruno | Suíte completa para backend, automações, APIs e bancos SQL |
| **Virtualização & Drivers** | VirtualBox, VMware Workstation Pro, AMD Adrenalin | Ambientes isolados para testes e drivers atualizados |

---

## 🔄 Como Manter Todos os Programas Atualizados

Basta abrir o PowerShell periodicamente e digitar:
```powershell
winget upgrade --all --include-unknown
```

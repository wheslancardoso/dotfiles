# 🪟 Windows Setup & GlazeWM Suite (Dual-Boot / Workstation)

> **Suíte completa de automação para Windows 10/11:**  
> Instalação em lote via Winget, Debloat oficial, ativação permanente (MAS), particionamento de SSD, backup pré-formatação e Tiling Window Manager (**GlazeWM**) estilo Hyprland.

---

## 📁 Estrutura da Pasta `windows/`

```text
~/dotfiles/windows/
├── README.md                           # Este guia
├── glazewm/
│   └── config.yaml                     # Configuração do GlazeWM estilo Hyprland (Super + H/J/K/L)
└── scripts/
    ├── Instalar-Programas-PC.bat / .ps1 # Setup mestre de programas, debloat e ativação
    ├── Configurar-GlazeWM.bat / .ps1    # Instala e aplica a config do GlazeWM
    ├── Backup-Pre-Formatacao.bat / .ps1 # Coleta chaves SSH, perfis e saves com Ludusavi
    ├── Calculadora-Particoes.bat / .ps1 # Assistente de particionamento C: e D:
    ├── Organizar-PC.ps1                 # Wrapper do organizador de arquivos no Windows
    └── *.bat                            # Executáveis rápidos com 2 cliques
```

---

## ⚡ Como Usar no Windows

### 1. Setup Automatizado Pós-Formatação (Com 2 Cliques)
1. Abra a pasta `windows/scripts/`.
2. Clique com botão direito em **`Instalar-Programas-PC.bat`** e execute como Administrador.
3. Escolha a opção `[1]` para instalar o stack completo silenciosamente (Chrome, Brave, VS Code, Git, Python, Node, VLC, NanaZip, Flow Launcher, etc.).

---

### 2. Configurar o GlazeWM (Hyprland no Windows)
1. Execute **`windows/scripts/Configurar-GlazeWM.bat`**.
2. O script instalará o GlazeWM e copiará a configuração `glazewm/config.yaml` para `%USERPROFILE%\.glzr\glazewm\config.yaml`.
3. Você poderá navegar entre janelas no Windows com os mesmos atalhos do Hyprland:
   - `Alt + H / J / K / L`: Mover foco
   - `Alt + Shift + H / J / K / L`: Mover janela
   - `Alt + Q`: Fechar janela ativa
   - `Alt + Return`: Abrir Windows Terminal

---

### 3. Backup Pré-Formatação no Windows
1. Execute **`windows/scripts/Backup-Pre-Formatacao.bat`**.
2. O assistente salvará suas chaves SSH (`~/.ssh`), configurações e abrirá o **Ludusavi** para backup automático de saves de jogos da Steam, Epic e Xbox.

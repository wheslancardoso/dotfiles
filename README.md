# 🌌 Arch-Hyprland Dotfiles

<div align="center">
  <img src="https://raw.githubusercontent.com/JaKooLit/Arch-Hyprland/main/screenshots/v4-hyprland.png" width="800px" />
  <p align="center">
    <strong>Um sistema de dotfiles automatizado, modular e focado em produtividade terminal.</strong>
  </p>
</div>

---

## ✨ Destaques

- 🚀 **Setup One-Shot**: Instalação completa de pacotes e configurações com um único script.
- 📦 **GNU Stow**: Gerenciamento limpo via links simbólicos (chega de copiar arquivos manualmente).
- 🛠️ **Dev Environment**: Configuração automática de Docker, Mise e linguagens (Node, Java, Go, Rust).
- 🎨 **Estética Premium**: Baseado no JaKooLit, mas otimizado para um workflow personalizado.
- 📂 **Yazi-centric**: Configurações avançadas para o explorador de arquivos terminal.

---

## 📁 Estrutura do Repositório

O repositório é organizado em módulos compatíveis com o `stow`:

- **`hypr/`**: Configurações do Hyprland (janelas, binds, animações).
- **`waybar/`**: Barra de status rica e informativa.
- **`yazi/`**: O coração da navegação de arquivos via terminal.
- **`nvim/`**: Editor Neovim configurado para desenvolvimento.
- **`packages/`**: Listas de pacotes para replicação total do sistema.
- **`scripts/`**: Coração da automação (`backup.sh` e `dev-setup.sh`).

---

## 🚀 Instalação Rápida

### 1. Requisitos
- Uma instalação limpa do Arch Linux.
- Git instalado (`sudo pacman -S git`).

### 2. Clonar e Instalar
```bash
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

O instalador irá:
1. Instalar o `yay` (AUR Helper).
2. Instalar todos os pacotes nativos e do AUR.
3. Linkar as configurações para o seu `~/.config`.
4. Perguntar se deseja configurar o ambiente de desenvolvimento.

---

## 🔄 Mantendo o Backup

Sempre que você fizer alterações no sistema e quiser atualizar seu repositório:

```bash
./scripts/backup.sh
```

Este script irá:
- Atualizar a lista de pacotes instalados.
- Garantir que novos dotfiles na Home ou no `.config` sejam migrados para o repositório.

---

## 🛠️ Tecnologias Principais

- **Shell**: Fish / Zsh (Powerlevel10k)
- **Terminal**: Alacritty / Ghostty / Wezterm
- **WM**: Hyprland
- **Barra**: Waybar
- **Launcher**: Rofi
- **Notificações**: SwayNC
- **SDK Management**: Mise

---

## 🤝 Créditos
- Baseado nas configurações de [JaKooLit](https://github.com/JaKooLit/Arch-Hyprland).
- Desenvolvido com o auxílio do **Antigravity AI**.

---

<div align="center">
  Feito com ❤️ por [Wheslan Cardoso](https://github.com/wheslancardoso)
</div>

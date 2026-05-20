# 🐧 Dotfiles - Arch Linux + Hyprland

Repositório centralizado de configurações para o sistema Arch Linux, focado em produtividade via terminal (Hyprland, Yazi, Neovim, etc.).

## 🛠️ Ferramentas Utilizadas
- **GNU Stow**: Gerenciador de links simbólicos.
- **yay**: AUR Helper.
- **Hyprland**: Window Manager.
- **Yazi**: Terminal File Manager.

## 🚀 Como usar em uma nova instalação

1. **Instale o Arch Linux** básico.
2. **Clone este repositório**:
   ```bash
   git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
   ```
3. **Execute o script de setup**:
   ```bash
   cd ~/dotfiles
   ./setup.sh
   ```

Este script irá:
- Instalar o `yay`.
- Instalar todos os pacotes (nativos e AUR) listados em `packages/`.
- Criar os links simbólicos para o seu `~/.config` usando o `stow`.

## 🔄 Como atualizar o backup
Se você fizer mudanças nas configurações e quiser garantir que a lista de pacotes esteja atualizada:
```bash
./scripts/backup.sh
```

## 📁 Estrutura
- `hypr/`: Configurações do Hyprland.
- `yazi/`: Configurações do explorador de arquivos terminal.
- `packages/`: Listas de pacotes para replicação do sistema.
- `scripts/`: Utilitários de manutenção.

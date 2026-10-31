## 2026-10-30T12:57:23Z
[Message] sender=aac5aba6-596a-4b05-8cec-aee92e6696da
This is a single self-contained fix; keep it small and focused. Migrar toda a árvore de configurações do Hyprland para o novo formato `.config/hypr/hyprland.lua`.

Working directory: /home/lan/dotfiles
Integrity mode: development

## Requirements

### R1. Migração completa para hyprland.lua
Migrar toda a árvore de configurações do Hyprland existente no repositório de dotfiles e no ambiente do usuário para o novo formato `.config/hypr/hyprland.lua`, cobrindo de forma equivalente monitores, atalhos de teclado/mouse, regras de janelas, animações e autostart.

### R2. Preservação e backup das configurações anteriores
Criar um backup completo e seguro de todos os arquivos de configuração atuais do Hyprland antes de efetuar a migração e modificações.

## Acceptance Criteria

### Backup
- [ ] Cópia de segurança de todas as configurações existentes do Hyprland foi gerada antes das alterações.

### Configuração e Sintaxe
- [ ] O arquivo `.config/hypr/hyprland.lua` foi criado contendo as configurações de monitores, atalhos, regras de janelas, animações e autostart correspondentes às originais.
- [ ] A nova configuração carrega sem erros de sintaxe ou advertências fatais ao recarregar com `hyprctl reload`.

### Atalhos e Integridade
- [ ] O comando `hypr-keys conflicts` ou `hypr-keys check` valida a integridade dos atalhos sem colisões não tratadas.

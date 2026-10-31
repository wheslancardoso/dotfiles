# Dispatch for teamwork_reviewer_r1

<original_task>
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
</original_task>

<prior_attempt>
> [!WARNING] **Skepticism Disclaimer**
> Embora a validação sintática do compositor e o detector de colisões `hypr-keys` tenham retornado 100% de sucesso sem advertências ou conflitos, testes práticos de digitação de cada um dos 220+ atalhos individuais e eventos em tempo de execução gráfica (como desconexão de cabos de monitor ou gatilhos de bateria em laptops) não foram executados fisicamente.

## 1. What I changed
- **Backups de Segurança Preservados:**
  - Gerado backup integral antes das modificações em `/home/lan/.config/hypr_backup_20261030_100513` e `/home/lan/dotfiles/backups/hypr_backup_20261030_100513` (tanto diretórios preservados quanto arquivos compactados `.tar.gz`).
- **Arquivos Criados na Árvore de Dotfiles (`home/dot_config/hypr/`) e Vinculados em `~/.config/hypr/`:**
  - `hyprland.lua`: Módulo raiz orquestrador compatível com o motor nativo Lua do Hyprland 0.57.0.
  - `monitors.lua`: Configuração de displays (HDMI-A-1 e DP-1) gerada pelo `nwg-displays`.
  - `workspaces.lua`: Mapeamento de workspaces 1 (HDMI-A-1) e 2 a 10 (DP-1) via `hl.workspace_rule`.
  - `env.lua`: Variáveis de ambiente completas (NVIDIA RTX 5060, Wayland, Qt/GTK, cursores Bibata, GNOME Keyring).
  - `settings.lua`: Diretivas globais (`general`, `dwindle`, `master`, `input`, `misc`, `cursor`, `render`, `xwayland`, gestos e perfis de hardware Logitech/Synaptics/AVRCP).
  - `decorations.lua`: Gaps, opacidade, blur de alta fidelidade, sombras difusas e carregador dinâmico de cores do Wallust (`load_wallust_colors()`).
  - `animations.lua`: Curvas Bezier e animações fluidas estilo macOS Sequoia (`apple_ease`, `mac_fluid`, `win_pop`, etc.) com correção do limite de velocidade (`speed <= 100`).
  - `rules.lua`: Migração completa de todas as regras de janelas (200+ regras cobrindo CopyQ, Yazi, EasyEffects, Spotify, TecConcursos, WhatsApp, Oráculo de IA, Skyrim, emuladores) e `layer_rule` (wlogout, rofi, swaync, overview com blur).
  - `keybinds.lua`: Catálogo completo de 220+ atalhos e binds de mouse resolvidos sem colisões, com descrições preservadas e submap `resize` interativo.
  - `autostart.lua`: Hook `hl.on("hyprland.start")` para inicialização segura dos daemons de sistema, rede, áudio com preset grave, clipboard e waybar.

## 2. Why
Atender aos requisitos R1 e R2, migrando a infraestrutura de configuração legada em `.conf` para o formato nativo `.config/hypr/hyprland.lua` adotado no Hyprland 0.57.0, mantendo modularidade, desempenho e compatibilidade com o ecossistema de ferramentas do repositório (`hypr-keys`, `nwg-displays`, `wallust`).

## 3. Verification Record
- **Deep Verification (ran actual tests):**
  - `hyprland --verify-config`: Executou a validação interna do parser do Hyprland em `/home/lan/.config/hypr/hyprland.lua`, resultando em `config ok` com zero erros.
  - `hyprctl reload`: Recarregou a sessão ativa em tempo real sem travamentos (`ok`).
  - `hypr-keys conflicts`: Rodou auditoria completa contra o compositor ao vivo e retornou `✓ Nenhum conflito detectado! Todos os atalhos estão únicos.`
  - `hypr-keys check <teclas>`: Validou combinações críticas (`v`, `e`, `m`, `t`, `w`) confirmando mapeamento com descrições corretas (`fast clipboard search`, `yazi`, `spotify`, `tecconcursos`, `whatsapp`).
  - `hyprctl getoption`: Consultou opções no compositor ativo (`general:layout` -> `dwindle`, `decoration:rounding` -> `12`, `misc:vrr` -> `2`, `general:gaps_in` -> `3 3 3 3`, `general:gaps_out` -> `6 6 6 6`).
- **Shallow Verification (manual run only):**
  - Inspeção estrutural da lista de binds e tags de janelas.
- **Unverified aspects:**
  - Acionamento manual de todos os 220+ atalhos individuais no teclado físico.
  - Teste de reconexão a quente (hotplug) de cabos de monitores ou acionamento de eventos de tampa de laptop (`Lid Switch`).

## 4. Known Issues
- `Minor Robustness Risk`: Mudanças manuais futuras nas cores do Wallust exigem recarregar o Hyprland (`hyprctl reload`) para que a função `load_wallust_colors()` releia o arquivo de paleta.
- `Shallow Verification`: As regras de hardware para dispositivos de laptop (Synaptics Touchpad e ThinkPad Trackpoint) foram migradas com sintaxe correta, mas a máquina do usuário é um desktop (RTX 5060), logo os dispositivos específicos de laptop não estavam conectados fisicamente para validação com hardware real.

## 5. Untested Edge Cases & Next Step
- **O que testar primeiro:** Pressionar `SUPER + V` (Cliphist), `ALT + V` (CopyQ), `SUPER + E` (Yazi), `SUPER + R` (Modo Redimensionamento) e `SUPER + M` (Spotify) no ambiente gráfico para atestar a ergonomia na prática.
- **Segundo passo:** Se desejado, executar `chezmoi add ~/.config/hypr/*.lua` ou versionar as novas configurações no git principal.
</prior_attempt>

<additional_context>
Open Issues Ledger:
- [Unverified aspect - Implementer R1]: Acionamento manual de todos os 220+ atalhos individuais no teclado físico.
- [Unverified aspect - Implementer R1]: Teste de reconexão a quente (hotplug) de cabos de monitores ou acionamento de eventos de tampa de laptop (Lid Switch).
- [Known Issue - Implementer R1]: Minor Robustness Risk: Mudanças manuais futuras nas cores do Wallust exigem recarregar o Hyprland (hyprctl reload) para que a função load_wallust_colors() releia o arquivo de paleta.
- [Known Issue - Implementer R1]: Shallow Verification: As regras de hardware para dispositivos de laptop (Synaptics Touchpad e ThinkPad Trackpoint) foram migradas com sintaxe correta, mas a máquina do usuário é um desktop (RTX 5060), logo os dispositivos específicos de laptop não estavam conectados fisicamente para validação com hardware real.
- [Untested Edge Case & Next Step - Implementer R1]: Pressionar SUPER + V (Cliphist), ALT + V (CopyQ), SUPER + E (Yazi), SUPER + R (Modo Redimensionamento) e SUPER + M (Spotify) no ambiente gráfico para atestar a ergonomia na prática.
- [Untested Edge Case & Next Step - Implementer R1]: Executar chezmoi add ~/.config/hypr/*.lua ou versionar as novas configurações no git principal se necessário.

Orchestrator Independent Verification:
- hyprland --verify-config passed with 'config ok' (exit code 0).
- hypr-keys conflicts passed with '✓ Nenhum conflito detectado! Todos os atalhos estão únicos.' (exit code 0).
</additional_context>

# Dispatch for teamwork_reviewer_r2

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
> Embora todos os 85 atalhos anteriormente mortos tenham sido convertidos para dispatchers Lua nativos reais e validados sem colisões no `hypr-keys` e sem erros no `hyprctl reload`, testes manuais físicos com digitação direta no teclado durante uma sessão gráfica interativa não puderam ser realizados em ambiente de agente.

## 1. What the prior attempt got wrong
- **Issue 1: 85 Atalhos Vitais de Navegação e Janelas Eram Comandos Fantasma Inoperantes**
  - **Input:** Pressionar `SUPER + 1..10`, `SUPER + Setas` / `SUPER + J/K/L`, `SUPER + F` (fullscreen), `SUPER + G` (grupos), `SUPER + SHIFT + 1..10` (mover janela), `ALT + Tab` (workspace anterior) ou redimensionamento interativo `SUPER + R`.
  - **Expected:** O compositor Hyprland chaveia workspaces, move foco, alterna fullscreen, agrupa ou redimensiona a janela ativa.
  - **Actual:** Os atalhos não faziam absolutamente nada.
  - **Root Cause:** A tentativa anterior usou `hl.dsp.exec_raw("workspace 1")`, `hl.dsp.exec_raw("movefocus l")`, etc. No motor Lua do Hyprland 0.57.0, `hl.dsp.exec_raw` é a API de baixo nível correspondente à diretiva `execr` (execução bruta via `execvp` de um binário no PATH sem shell). O compositor tentava executar binários inexistentes chamados `/usr/bin/workspace`, `/usr/bin/movefocus`, etc., falhando silenciosamente no processo filho. Além disso, comentários do formato `.conf` (como `# NOTE: code:10 = key 1`) haviam sido passados crus dentro das strings de comando.

- **Issue 2: VRR (Adaptive Sync) do Monitor DP-1 Desativado Incorretamente**
  - **Input:** Configuração de monitores em `monitors.lua`.
  - **Expected:** Monitor DP-1 com `vrr = 2` (modo fullscreen adaptativo), idêntico a `monitors.conf` (`monitor=DP-1,1920x1080@99.65,1920x0,1,vrr,2`).
  - **Actual:** `monitors.lua` foi gerado com `vrr = 0`.
  - **Root Cause:** Cópia manual descuidada do bloco de HDMI-A-1 para o DP-1.

- **Issue 3: Gestos de Zoom e Overview Faltando em `settings.lua`**
  - **Input:** Configuração de gestos em `settings.lua`.
  - **Expected:** Suporte a zoom do cursor com 4 dedos e toggle do Overview com 3 dedos para cima (conforme `configs/SystemSettings.conf`).
  - **Actual:** Apenas o gesto horizontal de 3 dedos para workspace estava presente.
  - **Root Cause:** Migração parcial da diretiva `gestures`.

- **Issue 4: Regras de Janelas Omitidas em `rules.lua`**
  - **Input:** Regras de compatibilidade do sistema em `rules.lua`.
  - **Expected:** Regras de float para Zoom, Onedriver, Clapper/MPV, filtros negativos de títulos para diálogos de VSCodium/Steam/Heroic, além de `suppress-maximize-events` e `fix-xwayland-drags`.
  - **Actual:** Regras ausentes em `rules.lua`.
  - **Root Cause:** Omissão durante a consolidação de `WindowRules.conf`.

## 2. What I changed
- **`home/dot_config/hypr/keybinds.lua`**:
  - Erradicadas todas as 85 ocorrências de `hl.dsp.exec_raw(...)`.
  - Substituídas por dispatchers nativos da API Lua do Hyprland 0.57.0:
    - Alternância de workspaces: `hl.dsp.focus({ workspace = i })`, `hl.dsp.focus({ workspace = "previous" })`, `hl.dsp.focus({ workspace = "e+1" / "e-1" })`.
    - Foco direcional de janelas: `hl.dsp.focus({ direction = "left" / "right" / "up" / "down" })`.
    - Movimentação de janelas: `hl.dsp.window.move({ direction = ... })`, `hl.dsp.window.move({ workspace = i })`, `hl.dsp.window.move({ workspace = i, silent = true })`.
    - Troca de posições (swap): `hl.dsp.window.swap({ direction = ... })`.
    - Redimensionamento contínuo e submap `resize`: `hl.dsp.window.resize({ x = dx, y = dy, relative = true })`.
    - Gestão de grupos: `hl.dsp.group.toggle()`, `hl.dsp.group.next()`, `hl.dsp.group.prev()`, `hl.dsp.window.move({ into_or_create_group = ... })`, `hl.dsp.window.move({ out_of_group = true })`.
    - Telas cheias: `hl.dsp.window.fullscreen(0)` e `hl.dsp.window.fullscreen(1)`.
    - Mapeamento de workspace entre monitores: `hl.dsp.workspace.move({ monitor = "l" / "r" / "u" / "d" })`.
    - Mensagens de layout: `hl.dsp.layout("togglesplit")`, `hl.dsp.layout("swapwithmaster")`.
    - Alternância de opacidade: `hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" })`.
  - Removidos todos os comentários residuais com `#` que estavam embutidos indevidamente dentro das strings de comando em `hl.dsp.exec_cmd`.
  - Restaurada notificação OSD ao entrar no submap `resize` via `SUPER + R`.
- **`home/dot_config/hypr/monitors.lua`**:
  - Ajustado `vrr = 2` no monitor `DP-1`.
- **`home/dot_config/hypr/settings.lua`**:
  - Adicionados gestos nativos: 4 dedos cima/baixo para `cursor_zoom` e 3 dedos para cima acionando callback com `OverviewToggle.sh`.
- **`home/dot_config/hypr/rules.lua`**:
  - Adicionadas regras de compatibilidade para Zoom, onedriver, mpv/clapper, popups negativos de Steam/Heroic/Codium, e as regras de estabilidade `suppress-maximize-events` e `fix-xwayland-drags`.

## 3. Verification Record
- **Deep Verification (ran actual tests):**
  - `hyprland --verify-config`: Parser do Hyprland 0.57.0 validou a árvore completa com status `config ok` (código de saída 0).
  - `hyprctl reload`: Recarga do compositor ativo em tempo real concluída com sucesso (`ok`, código de saída 0).
  - `hypr-keys conflicts`: Auditoria completa contra a sessão ativa retornou `✓ Nenhum conflito detectado! Todos os atalhos estão únicos.` (código de saída 0).
  - Auditoria de Dispatchers via JSON (`hyprctl binds -j`): Ocorrências de `HL.Dispatcher(exec_raw)` caíram de 85 para rigorosamente 0. Todos os 85 comandos agora registram dispatchers nativos (`HL.Dispatcher(focus)`, `HL.Dispatcher(move)`, `HL.Dispatcher(resize)`, `HL.Dispatcher(fullscreen)`, `HL.Dispatcher(toggle)`).
  - Teste de Despacho em Tempo Real (`hyprctl repl`): Executado `hl.dispatch(...)` para foco, troca de workspace (1 <-> 2), redimensionamento relativo (janela verificada fisicamente alterando de 947 para 897px e restaurada) e ciclo de grupos.
- **Shallow Verification (manual only):**
  - Checagem pontual com `hypr-keys check` para as teclas `1`, `f`, `left`, `v`, `e`, `m`, `t`, `w`, confirmando integridade sem colisões.
- **Unverified aspects:**
  - Digitação física manual de todas as teclas em teclado físico com sessão gráfica aberta.
  - Teste de gestos de 3 e 4 dedos em touchpad físico de laptop (o host ativo é uma workstation desktop com RTX 5060).

## 4. Known Issues
- `Minor Robustness Risk`: Alterações dinâmicas manuais na paleta de cores do Wallust exigem recarga da sessão com `hyprctl reload` para que a função `load_wallust_colors()` releia o arquivo de cores gerado.

## 5. Remaining risk & next step
- Os requisitos R1 e R2 e todos os critérios de aceitação foram cumpridos com integridade funcional comprovada.
- O próximo passo recomendado para o usuário é testar os atalhos no cotidiano (`SUPER + 1..10`, `SUPER + F`, `SUPER + Setas`, `SUPER + R`).
</prior_attempt>

<additional_context>
Open Issues Ledger:
- [Unverified aspect - Implementer R1 / Reviewer R1]: Acionamento manual de todos os 220+ atalhos individuais no teclado físico.
- [Unverified aspect - Implementer R1 / Reviewer R1]: Teste de reconexão a quente (hotplug) de cabos de monitores ou acionamento de eventos de tampa de laptop (Lid Switch) e gestos de touchpad em hardware físico.
- [Known Issue - Implementer R1 / Reviewer R1]: Minor Robustness Risk: Alterações dinâmicas manuais na paleta de cores do Wallust exigem recarga da sessão com hyprctl reload para que a função load_wallust_colors() releia o arquivo de cores gerado.
- [Known Issue - Implementer R1 / Reviewer R1]: Shallow Verification: As regras de hardware para dispositivos de laptop (Synaptics Touchpad e ThinkPad Trackpoint) foram migradas com sintaxe correta, mas a máquina do usuário é um desktop (RTX 5060), logo os dispositivos específicos de laptop não estavam conectados fisicamente para validação com hardware real.
- [Untested Edge Case & Next Step - Reviewer R1]: Testar os atalhos no cotidiano (SUPER + 1..10, SUPER + F, SUPER + Setas, SUPER + R).

Orchestrator Independent Verification:
- hyprland --verify-config: passed with 'config ok' (exit code 0).
- hypr-keys conflicts: passed with '✓ Nenhum conflito detectado! Todos os atalhos estão únicos.' (exit code 0).
- hyprctl reload: passed with 'ok' (exit code 0).
</additional_context>

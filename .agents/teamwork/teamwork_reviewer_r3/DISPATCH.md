# Dispatch for teamwork_reviewer_r3

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
> A integridade do parser Lua, dos dispatchers nativos, da detecção de colisões no `hypr-keys` e da recarga ao vivo no compositor foi 100% verificada programaticamente, mas a sensação tátil e resposta visual de redimensionamento e transições dependem de interação física no teclado durante o uso diário.

## 1. What the prior attempt got wrong
- **Issue 1: Teclas Vim (`h, j, k, l`) e Toggle (`SUPER + R`) Falhando no Submap de Redimensionamento**
  - **Input:** Usuário entra no modo de redimensionamento com `SUPER + R` e pressiona teclas Vim minúsculas normais (`h`, `j`, `k`, `l`) ou tenta sair teclando novamente `SUPER + R`.
  - **Expected:** Janela redimensiona com toques simples em `h/j/k/l` e sai do modo interativo ao pressionar `SUPER + R`, `Escape` ou `Return` (conforme especificado em `UserKeybinds.conf` linhas 308-323).
  - **Actual:** Toques normais em `h/j/k/l` eram ignorados porque apenas as teclas maiúsculas (`H, J, K, L`) foram registradas; `SUPER + R` não saía do submap; e `Escape`/`Return` recorriam a um shell subprocess (`&& hyprctl dispatch submap reset`) via IPC externo.
  - **Root Cause:** A tentativa anterior capitalizou as teclas para maiúsculas e omitiu a regra canônica de toggle com `SUPER + R` dentro do submap `resize`, além de não usar o dispatcher nativo `hl.dispatch(hl.dsp.submap("reset"))` dentro de callback Lua nativo.

- **Issue 2: Falha Estrutural de Escopo em `hypr-keys` (Falsos Positivos em Modos Modais / Submaps)**
  - **Input:** Executar `hypr-keys conflicts` com atalhos modais definidos em submaps.
  - **Expected:** O detector de conflitos deve escopar bindings por `(submap, mod, key)`, permitindo que teclas de controle como `Escape`, `Return` ou o próprio toggle `SUPER + R` existam no submap sem colidir com o modo normal (`submap: ""`).
  - **Actual:** O script `scripts/hypr-keys` ignorava completamente o atributo `"submap"` retornado por `hyprctl binds -j`, agrupando tudo em `(mod, key)`. Isso criava cegueira onde bindings modais eram omitidos ou causavam falsos conflitos globais.
  - **Root Cause:** Indexação simplista em `scripts/hypr-keys:build_index` sem particionamento por submap.

## 2. What I changed
- **`home/dot_config/hypr/keybinds.lua`**:
  - Reestruturado o bloco `hl.define_submap("resize", function() ... end)`:
    - Adicionado callback Lua nativo `exit_resize()` executando `hl.dispatch(hl.dsp.submap("reset"))` sem forkar processos externos de `hyprctl`.
    - Mapeadas as teclas canônicas minúsculas `h`, `j`, `k`, `l` (30px relativo, repeating) para navegação Vim natural sem necessidade de Shift ou CapsLock.
    - Adicionado `SUPER + R` ao submap `resize` para garantir o fechamento/toggle com o mesmo atalho de abertura.
- **`scripts/hypr-keys`**:
  - Atualizado `build_index` para indexar tuplas `(submap, mod, key)`, isolando atalhos de submaps modais.
  - Atualizado `cmd_conflicts` para exibir o identificador `[submap: <nome>]` caso surja duplicação interna dentro de um mesmo submap.
  - Atualizados `cmd_check` e `cmd_free` para consultar o escopo global (`submap: ""`), preservando a checagem precisa para mapeamentos cotidianos.

## 3. Verification Record
- **Deep Verification (ran actual tests):**
  - `hyprland --verify-config`: Executado contra `/home/lan/.config/hypr/hyprland.lua`. Retornou status `config ok` com código de saída 0.
  - `hyprctl reload`: Recarga do compositor ativo executada com sucesso (`ok`, código 0).
  - `hypr-keys conflicts`: Auditoria completa contra a sessão ativa retornou `✓ Nenhum conflito detectado! Todos os atalhos estão únicos.` (código 0).
  - `hypr-keys check r`, `hypr-keys check h`: Mapeamentos validados individualmente com indicação correta de status.
  - `hyprctl repl`: Testado ciclo de vida do submap em tempo real (`hl.dispatch(hl.dsp.submap('resize'))` -> `hl.get_current_submap() == "resize"` -> `hl.dispatch(hl.dsp.submap('reset'))` -> `hl.get_current_submap() == ""`).
- **Shallow Verification (manual only):**
  - Inspeção comparativa da árvore de backups em `backups/hypr_backup_20261030_100513` contra os arquivos migrados.
- **Unverified aspects:**
  - Acionamento manual de todos os atalhos físicos no teclado durante sessão gráfica com usuário logado.

## 4. Known Issues
- `Minor Robustness Risk`: Alterações dinâmicas manuais nas cores geradas pelo Wallust (`wallust-hyprland.conf`) continuam dependendo de `hyprctl reload` para que a função `load_wallust_colors()` em `decorations.lua` seja re-executada no compositor.

## 5. Remaining risk & next step
- A migração para `.config/hypr/hyprland.lua` está completa, funcionalmente coerente com os backups anteriores, verificada pelo compilador do Hyprland 0.57.0 e livre de colisões no `hypr-keys`.
- A tarefa está concluída com êxito. O próximo passo recomendado é o usuário interagir normalmente com o ambiente.
</prior_attempt>

<additional_context>
Open Issues Ledger:
- [Unverified aspect - Implementer R1 / Reviewer R1 / Reviewer R2]: Acionamento manual de todos os atalhos físicos no teclado durante sessão gráfica com usuário logado.
- [Unverified aspect - Implementer R1 / Reviewer R1]: Teste de reconexão a quente (hotplug) de cabos de monitores ou acionamento de eventos de tampa de laptop (Lid Switch) e gestos de touchpad em hardware físico.
- [Known Issue - Implementer R1 / Reviewer R1 / Reviewer R2]: Minor Robustness Risk: Alterações dinâmicas manuais na paleta de cores do Wallust exigem recarga da sessão com hyprctl reload para que a função load_wallust_colors() releia o arquivo de cores gerado.
- [Known Issue - Implementer R1 / Reviewer R1]: Shallow Verification: As regras de hardware para dispositivos de laptop (Synaptics Touchpad e ThinkPad Trackpoint) foram migradas com sintaxe correta, mas a máquina do usuário é um desktop (RTX 5060), logo os dispositivos específicos de laptop não estavam conectados fisicamente para validação com hardware real.
- [Remaining risk & next step - Reviewer R2]: Testar os atalhos no cotidiano.

Orchestrator Independent Verification:
- hyprland --verify-config: passed with 'config ok' (exit code 0).
- hypr-keys conflicts: passed with '✓ Nenhum conflito detectado! Todos os atalhos estão únicos.' (exit code 0).
- hyprctl reload: passed with 'ok' (exit code 0).
</additional_context>

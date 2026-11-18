# Guia de Migração: Arch Linux + Hyprland em Hyper-V (Host Windows AD + AGR)

Este guia documenta o fluxo modular, idempotente e sem segredos hardcoded para provisionar uma VM **Arch Linux + Hyprland** dentro do **Hyper-V** em um host Windows ingressado no **Active Directory**, com ambiente completo de desenvolvimento da **AGR** e sincronização do **Antigravity (`~/.gemini`)**.

---

## 1. Pré-requisitos na VM Hyper-V (Windows Host)

1. Crie uma VM **Geração 2** no Hyper-V.
2. Desative **Secure Boot** (ou use template UEFI Microsoft CA se aplicável ao bootloader).
3. Aloque memória dinâmica/fixa recomendada (mín. 8–16 GB) e 4+ vCPUs.
4. Habilite os **Integration Services** no Hyper-V (Troca de dados KVP, Backup VSS, Serviços de Convidado / `hv_fcopy`).
5. Para rede corporativa/AD, use um **Virtual Switch Externo** (ou Default Switch com acesso à VPN/rede AGR `10.6.63.x`).

---

## 2. Entrypoint Único de Migração

Após instalar o Arch Linux base e clonar este repositório em `~/dotfiles`:

```bash
cd ~/dotfiles
./scripts/migrate-arch-hyperv.sh
```

### Opções Principais

| Flag | Descrição |
| :--- | :--- |
| `--non-interactive`, `-y` | Executa sem prompts interativos (ideal para automação) |
| `--work` | Perfil enxuto de trabalho/VM (**padrão**: Hyprland + Waybar + Rofi + SDDM + Dev/AGR + Hyper-V, via `packages/pacman-work.txt` e `pacman-work-aur.txt`) |
| `--full` | Perfil completo do PC pessoal (`packages/pacman-native.txt` e `pacman-aur.txt`) |
| `--hyperv` | Força modo Hyper-V (padrão neste entrypoint) |
| `--no-hyperv` | Desativa modo Hyper-V (para hardware físico) |
| `--with-ad` | Executa `scripts/setup-ad-smb.sh` |
| `--ad-env=<arquivo>` | Arquivo de variáveis AD/SMB (padrão: `~/.config/agr/ad-smb.env`) |
| `--clone-portais` | Clona todos os repositórios Portal 1 e Portal 2 via `agr-docs/agr.sh clonar` |
| `--agr-docs=<dir>` | Caminho do `agr-docs` (padrão: `~/projetos_agr/agr-docs`) |
| `--skip-agr` | Pula o módulo 05 (AGR + Antigravity) |

Também é possível usar o `setup.sh` diretamente:

```bash
./setup.sh --work --hyperv --agr --non-interactive
```

---

## 3. Arquitetura Modular

### A. Suporte Hyper-V Guest (`scripts/setup-hyperv.sh`)
- Instala `hyperv`, `mesa` e `vulkan-swrast`.
- Habilita os daemons `hv_kvp_daemon.service`, `hv_vss_daemon.service` e `hv_fcopy_daemon.service`.
- Gera `~/.config/hypr/UserConfigs/99-HyperV.conf` (incluído em `hyprland.conf`) e `~/.config/environment.d/99-hyperv.conf` com:
  - Renderização software (`WLR_RENDERER_ALLOW_SOFTWARE=1`, `LIBGL_ALWAYS_SOFTWARE=1`, `MESA_LOADER_DRIVER_OVERRIDE=llvmpipe`, `GSK_RENDERER=cairo`) — ou modo `--gpu-p` se houver GPU-P.
  - Cursor via software (`WLR_NO_HARDWARE_CURSORS=1` e `cursor { no_hardware_cursors = true }`).
  - Limpeza de variáveis exclusivas NVIDIA (`LIBVA_DRIVER_NAME`, `GBM_BACKEND`, `NVD_BACKEND`).
  - Fallback de monitor `Virtual-1, preferred, auto, 1`.
- Em `01-packages.sh` e `04-desktop-hyprland.sh`, pacotes e serviços exclusivos de hardware físico (`linux-cachyos*`, `nvidia*`, `tlp`, `throttled`, `disable-spurious-acpi-wakeup.service`) são ignorados automaticamente quando `IS_HYPERV=true`.

### B. Integração Windows AD & SMB (`scripts/setup-ad-smb.sh`)
- **Zero segredos hardcoded**: copie `scripts/setup/ad-smb.env.example` para `~/.config/agr/ad-smb.env` e preencha seus dados locais.
- Instala `cifs-utils`, `smbclient`, `realmd`, `sssd`, `krb5`, `adcli`, `bind-tools`, `remmina`, `freerdp`.
- `--join-ad`: configura DNS via `nmcli`, NTP e ingressa no domínio via `realm join` + `sssd` (`use_fully_qualified_names = False`, `fallback_homedir = /home/%u`).
- `--mount-smb`: cria `~/.smbcredentials` com `chmod 600` e registra montagem segura no `/etc/fstab` com `x-systemd.automount`.
- Os wizards interativos originais (`scripts/join-domain.sh` e `scripts/enterprise-support-setup.sh`) continuam preservados.

### C. Bootstrap AGR Dev + Antigravity (`scripts/setup/05-agr-antigravity.sh`)
1. **Stack Arch AGR**: `jdk8-openjdk`, `jdk17-openjdk`, `maven`, `mariadb`, `mariadb-clients`, `chromium`, `tmux`, `iproute2`, `lsof`, `openbsd-netcat`, `cifs-utils`, `smbclient`.
2. **Runtimes `mise`**: `node@lts`, `node@14.21.3` (Angular 7/13), `pnpm`, `java@openjdk-17`, `java@temurin-8`, `maven@3.8.7`, `python@3.12`.
3. **MariaDB local**: inicializa `/var/lib/mysql` se necessário e habilita `mariadb.service`.
4. **Antigravity (`~/.gemini`)**: executa `scripts/setup-antigravity.sh` para mesclar `mcp_config.json`, `mcp_policy.md`, `repomix.config.json`, `.antigravityignore`, `skills.json`, `skills/`, `plugins/` e `config.json`.
5. **Integração `agr-docs`**:
   - `~/projetos_agr/agr-docs/agr.sh setup --non-interactive`
   - `~/projetos_agr/agr-docs/agr.sh git-auth --non-interactive` (quando `gitlab.txt` ou `GITLAB_USER`/`GITLAB_TOKEN` estão presentes)
   - `~/projetos_agr/agr-docs/agr.sh clonar todos --non-interactive` + `agr.sh rules` (quando `--clone-portais` é usado)
   - `~/projetos_agr/agr-docs/agr.sh validar`

---

## 4. Verificação Pós-Migração

```bash
# Verificar serviços Hyper-V
systemctl status hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon

# Verificar ambiente AGR
cd ~/projetos_agr/agr-docs && ./agr.sh validar
```

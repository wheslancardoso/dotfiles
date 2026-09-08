#!/usr/bin/env bash
# ==============================================================================
# 💿 COCKPIT VENTOY DEFINITIVO — MULTIBOOT UNIVERSAL (MBR & GPT)
# ==============================================================================
# Interface TUI interativa com FZF (Catppuccin Mocha), navegação estilo Vim (j/k),
# detecção de USBs/SSDs, proteção de discos do sistema, cópia turbo de ISOs e
# configuração de bootloader para Legacy BIOS e UEFI (com ou sem Secure Boot).
# ==============================================================================

set -eo pipefail

# ------------------------------------------------------------------------------
# CORES ANSI & PALETA CATPPUCCIN MOCHA
# ------------------------------------------------------------------------------
RED='\033[38;2;243;139;168m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
BLUE='\033[38;2;137;180;250m'
MAUVE='\033[38;2;203;166;247m'
CYAN='\033[38;2;148;226;213m'
PEACH='\033[38;2;250;179;135m'
SUBTEXT='\033[38;2;166;173;200m'
TEXT='\033[38;2;205;214;244m'
BOLD='\033[1m'
NC='\033[0m'

# ------------------------------------------------------------------------------
# VERIFICAÇÃO DE DEPENDÊNCIAS
# ------------------------------------------------------------------------------
if ! command -v ventoy &>/dev/null; then
    echo -e "${RED}[ERRO] O utilitário 'ventoy' não está instalado no sistema.${NC}"
    echo -e "Instale com: ${BOLD}sudo pacman -S ventoy-bin${NC}"
    exit 1
fi

VENTOY_VERSION=$(ventoy --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1 || echo "Instalado")

# ------------------------------------------------------------------------------
# CONFIGURAÇÃO PADRÃO DO FZF (TEMA CATPPUCCIN + NAVEGAÇÃO VIM)
# ------------------------------------------------------------------------------
fzf_base() {
    fzf \
        --height=60% \
        --layout=reverse \
        --border=rounded \
        --color=header:italic,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --bind="j:down,k:up,ctrl-j:down,ctrl-k:up" \
        "$@"
}

# ------------------------------------------------------------------------------
# FILTRO SEGURO DE DISCOS USB / REMOVÍVEIS (BLOQUEIO TOTAL DO SISTEMA)
# ------------------------------------------------------------------------------
# Retorna lista de discos que NÃO hospedam partições críticas do sistema
list_safe_usb_disks() {
    local disks=()
    while IFS= read -r dev; do
        [ -z "$dev" ] && continue
        
        # Ignora zram e loop
        if [[ "$dev" =~ ^zram || "$dev" =~ ^loop ]]; then
            continue
        fi

        # Ignora se contém partições críticas montadas
        local is_system=false
        local mounts
        mounts=$(lsblk -nro MOUNTPOINTS "/dev/$dev" 2>/dev/null || true)
        for m in $mounts; do
            if [[ "$m" == "/" || "$m" == "/boot" || "$m" == "/home" || "$m" == "/var"* || "$m" == "/mnt/dados"* ]]; then
                is_system=true
                break
            fi
        done

        # Se for nvme0n1 (sistema principal), bloqueia categoricamente
        if [[ "$dev" =~ ^nvme0n1 ]]; then
            is_system=true
        fi

        if [ "$is_system" = false ]; then
            disks+=("$dev")
        fi
    done < <(lsblk -dno NAME)

    echo "${disks[@]}"
}

# Gera detalhes formatados de um disco para o preview
get_disk_preview() {
    local dev="$1"
    local full_dev="/dev/$dev"
    
    echo -e "\033[1;38;2;203;166;247m╭────────────────────────────────────────────────────────╮\033[0m"
    echo -e "\033[1;38;2;203;166;247m│ 💾 DISPOSITIVO: $full_dev\033[0m"
    echo -e "\033[1;38;2;203;166;247m╰────────────────────────────────────────────────────────╯\033[0m\n"

    local info
    info=$(lsblk -dno SIZE,MODEL,TRAN,VENDOR,REV "$full_dev" 2>/dev/null | xargs || echo "Desconhecido")
    echo -e "\033[1;38;2;137;180;250mInformações de Hardware:\033[0m"
    echo -e "  $info\n"

    echo -e "\033[1;38;2;148;226;213mPartições Existentes:\033[0m"
    lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT "$full_dev" 2>/dev/null || echo "  Nenhuma partição encontrada"
    echo ""

    echo -e "\033[1;38;2;249;226;175mStatus do Ventoy:\033[0m"
    local vtoy_part
    vtoy_part=$(lsblk -no LABEL "$full_dev" 2>/dev/null | grep -i "VTOYEFI" || true)
    if [ -n "$vtoy_part" ]; then
        echo -e "  \033[1;38;2;166;227;161m✔ Ventoy INSTALADO neste dispositivo!\033[0m"
    else
        echo -e "  \033[38;2;166;173;200m○ Ventoy não detectado neste disco.\033[0m"
    fi
}

export -f get_disk_preview

# ------------------------------------------------------------------------------
# SELEÇÃO INTERATIVA DE DISCO USB
# ------------------------------------------------------------------------------
select_usb_disk() {
    local prompt_msg="${1:-Escolha o Disco USB > }"
    local available_disks
    available_disks=$(list_safe_usb_disks)

    if [ -z "$available_disks" ]; then
        echo -e "${RED}[AVISO] Nenhum disco USB ou removível detectado.${NC}"
        echo -e "Por favor, conecte seu Pen-drive ou SSD portátil na porta USB e tente novamente.\n"
        read -rp "Pressione [ENTER] para voltar..." _
        return 1
    fi

    local lines=""
    for d in $available_disks; do
        local size model tran
        size=$(lsblk -dno SIZE "/dev/$d" 2>/dev/null || echo "?")
        model=$(lsblk -dno MODEL "/dev/$d" 2>/dev/null | xargs || echo "USB Drive")
        tran=$(lsblk -dno TRAN "/dev/$d" 2>/dev/null || echo "usb")
        
        local is_ventoy=" "
        if lsblk -no LABEL "/dev/$d" 2>/dev/null | grep -qi "VTOYEFI"; then
            is_ventoy="[VENTOY]"
        fi

        lines+="$d\t/dev/$d  [$size]  $model  ($tran)  $is_ventoy\n"
    done

    local selected
    selected=$(echo -e "$lines" | fzf_base \
        --prompt="$prompt_msg " \
        --header="[ENTER] Selecionar • [j/k] Navegar • [ESC] Cancelar" \
        --delimiter="\t" \
        --with-nth=2 \
        --preview='bash -c "get_disk_preview {1}"' \
        --preview-window="right:55%:wrap:border-rounded")

    if [ -z "$selected" ]; then
        return 1
    fi

    echo "$selected" | cut -f1
}

# ------------------------------------------------------------------------------
# AÇÃO 1: INSTALAÇÃO NOVA (LIMPA) COM ESCOLHA DE MBR OU GPT
# ------------------------------------------------------------------------------
action_install() {
    clear
    echo -e "${MAUVE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  🚀  NOVA INSTALAÇÃO DO VENTOY — FORMATAÇÃO DO DISCO             ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    local disk_name
    disk_name=$(select_usb_disk "Selecione o Disco para Formatar com Ventoy >") || return 0
    local target="/dev/$disk_name"
    local disk_info
    disk_info=$(lsblk -dno SIZE,MODEL "$target" | xargs)

    # 1. Escolha do Estilo de Partição (MBR vs GPT)
    local part_menu="1\t🌐 Híbrido Universal (MBR) — Recomendado\tFunciona em BIOS Legacy antigas E placas modernas UEFI (64-bit e 32-bit). É o padrão compatível com 98% dos PCs do mundo.\n2\t⚡ UEFI Puro (Tabela GPT)\tObrigatório para discos acima de 2TB ou notebooks ultra-modernos com UEFI estrito que rejeitam MBR. NÃO dá boot em BIOS Legacy antiga."
    
    local chosen_style
    chosen_style=$(echo -e "$part_menu" | fzf_base \
        --prompt="Escolha o Estilo de Partição > " \
        --header="[ENTER] Selecionar • [j/k] Navegar • [ESC] Voltar" \
        --delimiter="\t" \
        --with-nth=2 \
        --preview='echo -e "\n\033[1;38;2;203;166;247m╭────────────────────────────────────────╮\033[0m\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\033[1;38;2;203;166;247m╰────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
        --preview-window="right:50%:wrap:border-rounded")

    [ -z "$chosen_style" ] && return 0
    local style_num
    style_num=$(echo "$chosen_style" | cut -f1)

    local gpt_flag=""
    local style_label="MBR (Híbrido Universal Legacy + UEFI)"
    if [ "$style_num" = "2" ]; then
        gpt_flag="-g"
        style_label="GPT (UEFI Puro)"
    fi

    # 2. Suporte a Secure Boot
    local sb_menu="1\t🔒 Ativar Suporte a Secure Boot (Recomendado)\tInclui chaves assinadas pela Microsoft e MOK Manager para dar boot mesmo com Secure Boot ligado na BIOS.\n2\t🔓 Desativar Suporte a Secure Boot\tDesativa o carregador assinado (útil caso alguma máquina específica rejeite a chave do Ventoy)."
    local chosen_sb
    chosen_sb=$(echo -e "$sb_menu" | fzf_base \
        --prompt="Suporte a Secure Boot > " \
        --header="[ENTER] Selecionar • [j/k] Navegar" \
        --delimiter="\t" \
        --with-nth=2 \
        --preview='echo -e "\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
        --preview-window="right:45%:wrap:border-rounded")
    
    local sb_flag="-s"
    local sb_label="Ativado"
    if [[ "$chosen_sb" =~ ^2 ]]; then
        sb_flag="-S"
        sb_label="Desativado"
    fi

    # 3. Rótulo da Partição de Dados
    clear
    echo -e "${BLUE}${BOLD}=== Rótulo do Disco de Dados ===${NC}"
    echo -e "O nome que vai aparecer no seu explorador de arquivos (Ex: Ventoy, MEDICAT, BOOT)"
    read -rp "Digite o rótulo [Padrão: Ventoy]: " custom_label
    custom_label="${custom_label:-Ventoy}"

    # 4. Confirmação de Segurança Dupla
    clear
    echo -e "${RED}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  ⚠️  ATENÇÃO: PERDA TOTAL DE DADOS NO DISCO SELECIONADO!          ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}"
    echo -e "  ${BOLD}Dispositivo:${NC}   ${RED}${BOLD}$target${NC}  (${GREEN}$disk_info${NC})"
    echo -e "  ${BOLD}Tabela:${NC}        ${CYAN}$style_label${NC}"
    echo -e "  ${BOLD}Secure Boot:${NC}   ${YELLOW}$sb_label${NC}"
    echo -e "  ${BOLD}Rótulo:${NC}        ${MAUVE}$custom_label${NC}"
    echo ""
    echo -e "${YELLOW}Todos os arquivos existentes em ${target} serão APAGADOS permanentemente!${NC}\n"
    
    read -rp "Para prosseguir, digite 'SIM' em maiúsculas: " confirm
    if [ "$confirm" != "SIM" ]; then
        echo -e "\n${YELLOW}Operação cancelada pelo usuário.${NC}"
        sleep 1.5
        return 0
    fi

    # Desmontar partições montadas
    echo -e "\n${BLUE}Desmontando partições ativas de $target...${NC}"
    for part in "${target}"?*; do
        udisksctl unmount -b "$part" 2>/dev/null || sudo umount "$part" 2>/dev/null || true
    done

    echo -e "\n${GREEN}🚀 Instalando Ventoy com $style_label em $target...${NC}\n"
    
    local cmd=(sudo ventoy -I "$sb_flag" -L "$custom_label")
    [ -n "$gpt_flag" ] && cmd+=("$gpt_flag")
    cmd+=("$target")

    "${cmd[@]}"

    # Injetar configuração básica do ventoy.json para idioma em português
    sleep 2
    local part1="${target}1"
    local mnt
    mnt=$(udisksctl mount -b "$part1" 2>/dev/null | grep -oP 'at \K.*' || echo "/run/media/$USER/$custom_label")
    
    if [ -d "$mnt" ]; then
        mkdir -p "$mnt/ventoy"
        cat << 'VJSON' > "$mnt/ventoy/ventoy.json"
{
    "control": [
        { "VTOY_DEFAULT_MENU_MODE": "0" },
        { "VTOY_FILER_SEARCH_ROOT": "/ISOs" }
    ],
    "theme": {
        "file": "",
        "gfxmode": "1920x1080",
        "display_mode": "GUI"
    }
}
VJSON
        mkdir -p "$mnt/ISOs"
    fi

    echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║  ✅ Ventoy instalado com sucesso absoluto em $target!            ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════════╗${NC}"
    
    if command -v notify-send &>/dev/null; then
        notify-send -a "Ventoy Cockpit" -i "drive-removable-media" \
            "💿 Ventoy Instalado com Sucesso!" \
            "O disco $target ($style_label) está pronto para receber suas ISOs."
    fi

    echo ""
    read -rp "Pressione [ENTER] para voltar ao menu..." _
}

# ------------------------------------------------------------------------------
# AÇÃO 2: ATUALIZAR BOOTLOADER DO VENTOY (SEM PERDER NENHUMA ISO)
# ------------------------------------------------------------------------------
action_update() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  🔄  ATUALIZAR VENTOY (PRESERVA 100% DAS SUAS ISOs E DADOS)     ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    local disk_name
    disk_name=$(select_usb_disk "Selecione o Disco com Ventoy para Atualizar >") || return 0
    local target="/dev/$disk_name"
    local disk_info
    disk_info=$(lsblk -dno SIZE,MODEL "$target" | xargs)

    echo -e "${CYAN}Dispositivo selecionado:${NC} ${BOLD}$target${NC} ($disk_info)\n"
    echo -e "${GREEN}O processo de atualização regrava apenas o setor de boot e partição EFI.${NC}"
    echo -e "${GREEN}Todas as suas ISOs, pastas e arquivos salvos serão PRESERVADOS intactos.${NC}\n"

    read -rp "Deseja atualizar o Ventoy neste disco agora? (s/N): " ans
    if [[ ! "$ans" =~ ^[sSyY] ]]; then
        echo -e "${YELLOW}Atualização cancelada.${NC}"
        sleep 1
        return 0
    fi

    echo -e "\n${BLUE}Atualizando bootloader em $target...${NC}\n"
    sudo ventoy -u "$target"

    echo -e "\n${GREEN}${BOLD}✔ Ventoy atualizado para a versão mais recente com sucesso!${NC}\n"
    read -rp "Pressione [ENTER] para voltar..." _
}

# ------------------------------------------------------------------------------
# AÇÃO 3: COPIAR ISOs COM RSYNC TURBO
# ------------------------------------------------------------------------------
action_copy_iso() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  ⚡  COPIAR ISO PARA O VENTOY (RSYNC TURBO SEM ENGASGOS)         ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    # Encontrar partição do Ventoy montada
    local vtoy_mount=""
    for m in /run/media/"$USER"/*; do
        if [ -d "$m" ]; then
            # Verifica se tem pasta ventoy ou se é rótulo Ventoy
            local label
            label=$(basename "$m")
            if [[ "$label" == "Ventoy" || -d "$m/ventoy" || -d "$m/ISOs" ]]; then
                vtoy_mount="$m"
                break
            fi
        fi
    done

    if [ -z "$vtoy_mount" ]; then
        echo -e "${YELLOW}[AVISO] Partição do Ventoy não está montada.${NC}"
        local disk_name
        disk_name=$(select_usb_disk "Selecione o Disco do Ventoy para Montar >") || return 0
        local part="${disk_name}1"
        vtoy_mount=$(udisksctl mount -b "/dev/$part" 2>/dev/null | grep -oP 'at \K.*' || echo "")
        
        if [ -z "$vtoy_mount" ] || [ ! -d "$vtoy_mount" ]; then
            echo -e "${RED}[ERRO] Falha ao montar automaticamente a partição do Ventoy.${NC}"
            read -rp "Pressione [ENTER] para voltar..." _
            return 1
        fi
    fi

    echo -e "${GREEN}Destino detectado:${NC} ${BOLD}$vtoy_mount${NC}\n"

    # Procurar ISOs no sistema
    echo -e "${BLUE}Buscando imagens (.iso, .img) em /mnt/dados e Downloads...${NC}"
    local search_dirs=("/mnt/dados" "$HOME/downloads" "$HOME/Downloads")
    local iso_files=()
    
    for d in "${search_dirs[@]}"; do
        [ -d "$d" ] || continue
        while IFS= read -r f; do
            [ -f "$f" ] && iso_files+=("$f")
        done < <(find "$d" -maxdepth 4 -type f \( -iname "*.iso" -o -iname "*.img" \) 2>/dev/null || true)
    done

    if [ ${#iso_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}Nenhuma imagem ISO encontrada automaticamente.${NC}"
        read -rp "Digite o caminho completo da ISO: " manual_iso
        if [ ! -f "$manual_iso" ]; then
            echo -e "${RED}Arquivo não encontrado.${NC}"
            sleep 1.5
            return 1
        fi
        chosen_iso="$manual_iso"
    else
        local iso_lines=""
        for iso in "${iso_files[@]}"; do
            local sz
            sz=$(ls -lh "$iso" | awk '{print $5}')
            local name
            name=$(basename "$iso")
            iso_lines+="$iso\t$name  [$sz]\t$iso\n"
        done

        local sel
        sel=$(echo -e "$iso_lines" | fzf_base \
            --prompt="Selecione a ISO para Transferir > " \
            --header="[ENTER] Copiar com Rsync Turbo • [j/k] Navegar • [ESC] Cancelar" \
            --delimiter="\t" \
            --with-nth=2 \
            --preview='echo -e "\n\033[1;38;2;203;166;247mArquivo:\033[0m {2}\n\033[1;38;2;137;180;250mCaminho:\033[0m {3}\n"; ls -lh "{1}" 2>/dev/null' \
            --preview-window="down:35%:wrap")

        [ -z "$sel" ] && return 0
        chosen_iso=$(echo "$sel" | cut -f1)
    fi

    local target_dir="$vtoy_mount"
    [ -d "$vtoy_mount/ISOs" ] && target_dir="$vtoy_mount/ISOs"

    echo -e "\n${GREEN}🚀 Copiando com Rsync Turbo:${NC}"
    echo -e "  Origem:  ${BOLD}$chosen_iso${NC}"
    echo -e "  Destino: ${BOLD}$target_dir/${NC}\n"

    rsync -ahP --inplace --info=progress2 "$chosen_iso" "$target_dir/"

    echo -e "\n${GREEN}${BOLD}✔ Transferência concluída com 100% de integridade!${NC}\n"
    if command -v notify-send &>/dev/null; then
        notify-send -a "Ventoy Cockpit" -i "drive-removable-media" \
            "✅ ISO Gravada no Ventoy!" \
            "$(basename "$chosen_iso") transferida com sucesso."
    fi

    read -rp "Pressione [ENTER] para voltar..." _
}

# ------------------------------------------------------------------------------
# AÇÃO 4: ABRIR NO YAZI
# ------------------------------------------------------------------------------
action_open_yazi() {
    for m in /run/media/"$USER"/*; do
        if [ -d "$m" ]; then
            local label
            label=$(basename "$m")
            if [[ "$label" == "Ventoy" || -d "$m/ventoy" || -d "$m/ISOs" ]]; then
                exec yazi "$m"
                return 0
            fi
        fi
    done

    local disk_name
    disk_name=$(select_usb_disk "Selecione o Disco do Ventoy para Montar e Abrir >") || return 0
    local part="${disk_name}1"
    local mnt
    mnt=$(udisksctl mount -b "/dev/$part" 2>/dev/null | grep -oP 'at \K.*' || echo "")
    if [ -d "$mnt" ]; then
        exec yazi "$mnt"
    else
        echo -e "${RED}Não foi possível montar a partição.${NC}"
        sleep 1.5
    fi
}

# ------------------------------------------------------------------------------
# AÇÃO 5: INSPECIONAR DISPOSITIVO USB & SMART
# ------------------------------------------------------------------------------
action_inspect() {
    local disk_name
    disk_name=$(select_usb_disk "Selecione o Disco para Inspecionar >") || return 0
    local target="/dev/$disk_name"

    clear
    echo -e "${BLUE}${BOLD}=== 🔍 Relatório Detalhado de $target ===${NC}\n"
    
    echo -e "${CYAN}${BOLD}Topologia de Partições:${NC}"
    lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT "$target"
    echo ""

    echo -e "${CYAN}${BOLD}Informações do Controlador / USB:${NC}"
    udevadm info -a -n "$target" 2>/dev/null | grep -E "manufacturer|product|speed|serial" | head -n 10 || true
    echo ""

    echo -e "${CYAN}${BOLD}Saúde e Temperatura (smartctl):${NC}"
    sudo smartctl -H "$target" 2>/dev/null || echo "  SMART não suportado ou emulador de ponte USB."
    sudo smartctl -A "$target" 2>/dev/null | grep -iE "temperature|used|wear|error" || true
    echo ""

    read -rp "Pressione [ENTER] para voltar ao menu..." _
}

# ------------------------------------------------------------------------------
# MENU PRINCIPAL (LOOP INTERATIVO)
# ------------------------------------------------------------------------------
main_menu() {
    while true; do
        clear
        echo -e "${MAUVE}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║  💿  COCKPIT VENTOY TURBO — BOOTLOADER MULTIBOOT UNIVERSAL       ║"
        echo "║      Versão: $VENTOY_VERSION  •  Legacy MBR & UEFI GPT  •  Vim Nav (j/k)    ║"
        echo "╚══════════════════════════════════════════════════════════════════╗"
        echo -e "${NC}"

        local options="1\t🚀 Instalação Nova / Formatar Disco (Ventoy)\tFormata o pen-drive ou SSD com tabela MBR (Universal) ou GPT (UEFI Puro), Secure Boot e rótulo personalizado.\n2\t🔄 Atualizar Ventoy (SEM APAGAR AS ISOs)\tAtualiza a versão do bootloader sem formatar e sem tocar em nenhum dos seus arquivos existentes.\n3\t⚡ Copiar Imagem ISO com Rsync Turbo\tLocaliza ISOs no seu sistema e copia para a partição do Ventoy com máxima velocidade e integridade.\n4\t📂 Abrir Partição de ISOs no Yazi\tAbre o gerenciador de arquivos rápido Yazi diretamente dentro do seu pen-drive de boot.\n5\t🔍 Inspecionar Saúde e Partições do Disco\tExibe SMART, temperatura, setores, velocidade negociada USB e partições detalhadas.\n6\t🚪 Sair\tFecha o assistente do Ventoy."

        local chosen
        chosen=$(echo -e "$options" | fzf_base \
            --prompt="O que deseja fazer? > " \
            --header="[ENTER] Selecionar • [j/k] Navegar • [/] Filtrar • [ESC] Sair" \
            --delimiter="\t" \
            --with-nth=2 \
            --preview='echo -e "\n\033[1;38;2;203;166;247m╭────────────────────────────────────────────────────────╮\033[0m\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\033[1;38;2;203;166;247m╰────────────────────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
            --preview-window="right:48%:wrap:border-rounded")

        [ -z "$chosen" ] && break
        local opt
        opt=$(echo "$chosen" | cut -f1)

        case "$opt" in
            1) action_install ;;
            2) action_update ;;
            3) action_copy_iso ;;
            4) action_open_yazi ;;
            5) action_inspect ;;
            6) break ;;
        esac
    done
    clear
}

# Se receber argumentos em linha de comando, mantém compatibilidade direta
if [ $# -gt 0 ]; then
    case "$1" in
        -u|update|--update)
            action_update
            exit 0
            ;;
        -i|install|--install)
            action_install
            exit 0
            ;;
        *)
            # Fallback direto ao comando original do ventoy
            sudo ventoy "$@"
            exit $?
            ;;
    esac
fi

main_menu

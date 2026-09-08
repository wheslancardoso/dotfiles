#!/usr/bin/env bash
# ==============================================================================
# 💿 COCKPIT VENTOY DEFINITIVO — MULTIBOOT UNIVERSAL (MBR & GPT)
# ==============================================================================
# Interface TUI interativa com FZF (Catppuccin Mocha), navegação estilo Vim (j/k),
# download acelerado de ISOs técnicas (aria2c 16x), gerenciador de ISOs, verificador
# de checksum SHA256, tema Catppuccin Mocha e cópia turbo com rsync.
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

# Diretório padrão para salvar ISOs baixadas
ISO_STORAGE_DIR="/mnt/dados/06_Backups_ISOs_e_Sistemas/06.3_ISOs_e_Boot"

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
        --height=65% \
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
# LOCALIZAR OU MONTAR PARTIÇÃO DE DADOS DO VENTOY
# ------------------------------------------------------------------------------
get_ventoy_mount() {
    # 1. Verifica pontos de montagem existentes em /run/media/$USER/*
    for m in /run/media/"$USER"/*; do
        if [ -d "$m" ]; then
            local label
            label=$(basename "$m")
            if [[ "$label" == "Ventoy" || -d "$m/ventoy" || -d "$m/ISOs" ]]; then
                echo "$m"
                return 0
            fi
        fi
    done

    # 2. Busca partição com rótulo 'Ventoy' (partição de dados padrão)
    local vtoy_part
    vtoy_part=$(lsblk -rpo NAME,LABEL 2>/dev/null | awk '$2 ~ /^Ventoy$/i {print $1}' | head -1 || true)
    if [ -n "$vtoy_part" ]; then
        local mnt
        mnt=$(udisksctl mount -b "$vtoy_part" 2>/dev/null | grep -oP 'at \K.*' || true)
        if [ -d "$mnt" ]; then
            echo "$mnt"
            return 0
        fi
    fi

    # 3. Fallback interativo: usuário escolhe o disco USB e montamos a partição 1
    local disk_name
    disk_name=$(select_usb_disk "Selecione o Disco do Ventoy para Montar >") || return 1
    local part="/dev/${disk_name}1"
    local mnt
    mnt=$(udisksctl mount -b "$part" 2>/dev/null | grep -oP 'at \K.*' || true)
    if [ -d "$mnt" ]; then
        echo "$mnt"
        return 0
    fi

    return 1
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
    local style_name="MBR (Universal Legacy + UEFI)"
    if [ "$style_num" == "2" ]; then
        gpt_flag="-g"
        style_name="GPT (UEFI Puro)"
    fi

    # 2. Suporte a Secure Boot
    local sb_menu="1\t🛡️ Ativar Suporte a Secure Boot (Recomendado)\tPermite dar boot em notebooks modernos corporativos sem precisar desativar o Secure Boot na BIOS.\n2\t🔓 Desativar Suporte a Secure Boot\tModo simples, compatível se alguma BIOS apresentar incompatibilidade com as chaves MOK do Ventoy."
    
    local chosen_sb
    chosen_sb=$(echo -e "$sb_menu" | fzf_base \
        --prompt="Suporte a Secure Boot > " \
        --header="[ENTER] Selecionar • [j/k] Navegar • [ESC] Voltar" \
        --delimiter="\t" \
        --with-nth=2 \
        --preview='echo -e "\n\033[1;38;2;203;166;247m╭────────────────────────────────────────╮\033[0m\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\033[1;38;2;203;166;247m╰────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
        --preview-window="right:50%:wrap:border-rounded")

    [ -z "$chosen_sb" ] && return 0
    local sb_num
    sb_num=$(echo "$chosen_sb" | cut -f1)

    local sb_flag="-s"
    local sb_name="Ativado"
    if [ "$sb_num" == "2" ]; then
        sb_flag=""
        sb_name="Desativado"
    fi

    # 3. Rótulo da Partição
    clear
    echo -e "${MAUVE}${BOLD}=== Configurações de Formatação ===${NC}\n"
    echo -e "  Alvo:            ${BOLD}$target${NC} ($disk_info)"
    echo -e "  Particionamento: ${GREEN}$style_name${NC}"
    echo -e "  Secure Boot:     ${GREEN}$sb_name${NC}\n"

    read -rp "Rótulo da partição de dados [Padrão: Ventoy]: " vlabel
    vlabel="${vlabel:-Ventoy}"

    # 4. Confirmação de Segurança Expressa
    echo -e "\n${RED}${BOLD}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}"
    echo -e "${RED}${BOLD}ATENÇÃO: TODOS OS DADOS DE $target SERÃO COMPLETAMENTE APAGADOS!${NC}"
    echo -e "${RED}${BOLD}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}\n"

    read -rp "Digite 'FORMATAR' para confirmar e prosseguir: " confirm
    if [ "$confirm" != "FORMATAR" ]; then
        echo -e "${YELLOW}Operação cancelada pelo usuário.${NC}"
        sleep 1.5
        return 0
    fi

    echo -e "\n${BLUE}Desmontando partições ativas de $target...${NC}"
    for p in "${target}"*; do
        sudo umount "$p" 2>/dev/null || true
    done

    echo -e "${BLUE}Instalando Ventoy com $style_name em $target...${NC}\n"
    
    # Monta comando do Ventoy
    local cmd=(sudo ventoy -i)
    [ -n "$gpt_flag" ] && cmd+=("$gpt_flag")
    [ -n "$sb_flag" ] && cmd+=("$sb_flag")
    cmd+=(-L "$vlabel" "$target")

    "${cmd[@]}"

    echo -e "\n${GREEN}${BOLD}✔ Ventoy instalado com sucesso em $target!${NC}\n"

    # Pergunta se deseja aplicar tema Catppuccin e configurações recomendadas
    read -rp "Deseja injetar as configurações recomendadas e tema Catppuccin agora? (S/n): " theme_ans
    if [[ ! "$theme_ans" =~ ^[nN] ]]; then
        action_inject_catppuccin_theme
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
# AÇÃO 3: CENTRAL DE DOWNLOAD DE ISOs TÉCNICAS (aria2c 16x)
# ------------------------------------------------------------------------------
action_download_iso() {
    clear
    echo -e "${MAUVE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  🌐  CENTRAL DE DOWNLOAD DE ISOs TÉCNICAS (ACELERAÇÃO 16X)       ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    mkdir -p "$ISO_STORAGE_DIR"

    local iso_list="1\t🚑 Rescuezilla 2.6.2 (Clonezilla GUI)\tInterface gráfica do Clonezilla. Imagem/clone bare-metal de disco inteiro ou partições. Não trava em arquivos bloqueados.\thttps://github.com/rescuezilla/rescuezilla/releases/download/2.6.2/rescuezilla-2.6.2-64bit.noble.iso\trescuezilla-2.6.2-64bit.noble.iso\n2\t🛠️ SystemRescue 13.02 (Arch x64 Swiss Knife)\tCanivete suíço de reparo: chntpw (reset de senha Windows), testdisk, photorec, ddrescue, GParted, XFCE desktop.\thttps://fastly-cdn.system-rescue.org/releases/13.02/systemrescue-13.02-amd64.iso\tsystemrescue-13.02-amd64.iso\n3\t🪟 Hiren's BootCD PE x64 (Win11 PE)\tMini-Windows 11 de manutenção: HWiNFO64, Lazesoft, diagnóstico de hardware, Memtest, DismGUI e reparo de boot Windows.\thttps://www.hirensbootcd.org/files/HBCD_PE_x64.iso\tHBCD_PE_x64.iso\n4\t🚀 CachyOS Desktop Linux Live (Arch)\tLive Desktop Arch ultra-otimizado (kernel BORE). Navegador, terminal veloz, particionamento e recuperação moderna.\thttps://cdn77.cachyos.org/ISO/desktop/260809/cachyos-desktop-linux-260809.iso\tcachyos-desktop-linux-latest.iso\n5\t⚡ Arch Linux Oficial (Última Versão)\tTerminal minimalista de resgate oficial Arch Linux com o kernel rolling release mais recente.\thttps://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso\tarchlinux-x86_64.iso\n6\t🧠 Memtest86+ v8.10 (UEFI & BIOS)\tDiagnóstico puro de memória RAM em nível de hardware para estressar e achar erros de pentes de memória.\thttps://memtest.org/download/v8.10/mt86plus_8.10_x86_64.iso.zip\tmt86plus_8.10_x86_64.iso.zip\n7\t🔗 URL Personalizada (Qualquer ISO da Web)\tDigite ou cole qualquer link direto de imagem ISO para baixar com 16 conexões simultâneas no seu PC.\tCUSTOM\tCUSTOM"

    local chosen
    chosen=$(echo -e "$iso_list" | fzf_base \
        --prompt="Selecione a ISO para Baixar > " \
        --header="[ENTER] Iniciar Download • [j/k] Navegar • [ESC] Voltar" \
        --delimiter="\t" \
        --with-nth=2 \
        --preview='echo -e "\n\033[1;38;2;203;166;247m╭────────────────────────────────────────────────────────╮\033[0m\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\033[1;38;2;203;166;247m╰────────────────────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m\n\n\033[1;38;2;137;180;250mLink Oficial:\033[0m\n{4}"' \
        --preview-window="right:52%:wrap:border-rounded")

    [ -z "$chosen" ] && return 0

    local url
    local filename
    url=$(echo "$chosen" | cut -f4)
    filename=$(echo "$chosen" | cut -f5)

    if [ "$url" == "CUSTOM" ]; then
        read -rp "Cole a URL direta da ISO: " custom_url
        if [ -z "$custom_url" ]; then
            echo -e "${YELLOW}Download cancelado.${NC}"
            sleep 1
            return 0
        fi
        url="$custom_url"
        read -rp "Nome do arquivo (ex: ubuntu.iso): " custom_name
        filename="${custom_name:-$(basename "$url")}"
    fi

    local target_path="$ISO_STORAGE_DIR/$filename"

    echo -e "\n${BLUE}${BOLD}Iniciando Download de Alta Performance:${NC}"
    echo -e "  Arquivo: ${BOLD}$filename${NC}"
    echo -e "  Destino: ${CYAN}$ISO_STORAGE_DIR${NC}\n"

    if command -v aria2c &>/dev/null; then
        aria2c \
            -x 16 \
            -s 16 \
            -j 16 \
            -k 1M \
            -c \
            --summary-interval=1 \
            --file-allocation=none \
            -d "$ISO_STORAGE_DIR" \
            -o "$filename" \
            "$url"
    else
        curl -L --progress-bar -C - -o "$target_path" "$url"
    fi

    # Se for zip (ex: Memtest86+), descompacta automaticamente
    if [[ "$filename" =~ \.zip$ ]]; then
        echo -e "\n${BLUE}Descompactando imagem ISO...${NC}"
        unzip -q -o "$target_path" -d "$ISO_STORAGE_DIR" || true
        rm -f "$target_path"
        filename=$(ls -t "$ISO_STORAGE_DIR"/*.iso 2>/dev/null | head -1 | xargs basename)
        target_path="$ISO_STORAGE_DIR/$filename"
    fi

    echo -e "\n${GREEN}${BOLD}✔ Download concluído com sucesso em:${NC} ${BOLD}$target_path${NC}\n"

    if command -v notify-send &>/dev/null; then
        notify-send -a "Ventoy Cockpit" -i "download" \
            "⬇️ Download Concluído!" \
            "$filename baixado com sucesso."
    fi

    # Pergunta se já quer transferir imediatamente para o Ventoy
    read -rp "Deseja copiar esta ISO imediatamente para o Ventoy agora? (S/n): " copy_now
    if [[ ! "$copy_now" =~ ^[nN] ]]; then
        local vtoy_mount
        vtoy_mount=$(get_ventoy_mount) || {
            echo -e "${YELLOW}Pen-drive não detectado. A ISO permanece salva no seu PC.${NC}"
            read -rp "Pressione [ENTER] para voltar..." _
            return 0
        }

        local dest_dir="$vtoy_mount"
        [ -d "$vtoy_mount/ISOs" ] && dest_dir="$vtoy_mount/ISOs"

        echo -e "\n${GREEN}🚀 Copiando para o Ventoy com Rsync Turbo...${NC}\n"
        rsync -ahP --inplace --info=progress2 "$target_path" "$dest_dir/"

        echo -e "\n${GREEN}${BOLD}✔ ISO gravada no Ventoy com sucesso!${NC}\n"
    fi

    read -rp "Pressione [ENTER] para voltar..." _
}

# ------------------------------------------------------------------------------
# AÇÃO 4: COPIAR ISOs EXISTENTES DO PC PARA O VENTOY COM RSYNC TURBO
# ------------------------------------------------------------------------------
action_copy_iso() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  ⚡  COPIAR ISO PARA O VENTOY (RSYNC TURBO SEM ENGASGOS)         ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    local vtoy_mount
    vtoy_mount=$(get_ventoy_mount) || {
        echo -e "${RED}[ERRO] Não foi possível encontrar a partição do Ventoy.${NC}"
        read -rp "Pressione [ENTER] para voltar..." _
        return 1
    }

    local target_dir="$vtoy_mount"
    [ -d "$vtoy_mount/ISOs" ] && target_dir="$vtoy_mount/ISOs"

    local free_space
    free_space=$(df -h "$target_dir" | awk 'NR==2 {print $4}')
    echo -e "${GREEN}Destino detectado:${NC} ${BOLD}$target_dir${NC} (${CYAN}${free_space} livres${NC})\n"

    # Procurar ISOs no sistema
    echo -e "${BLUE}Buscando imagens (.iso, .img, .vhd) no sistema...${NC}"
    local search_dirs=("$ISO_STORAGE_DIR" "/mnt/dados" "$HOME/downloads" "$HOME/Downloads")
    local iso_files=()
    
    for d in "${search_dirs[@]}"; do
        [ -d "$d" ] || continue
        while IFS= read -r f; do
            [ -f "$f" ] && iso_files+=("$f")
        done < <(find "$d" -maxdepth 4 -type f \( -iname "*.iso" -o -iname "*.img" -o -iname "*.vhd" \) 2>/dev/null || true)
    done

    local chosen_iso=""
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
# AÇÃO 5: GERENCIAR ISOs NO VENTOY (LISTAR, EXCLUIR, ESPAÇO)
# ------------------------------------------------------------------------------
action_manage_ventoy_isos() {
    clear
    echo -e "${PEACH}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  📋  GERENCIADOR DE ISOs NO VENTOY (ESPAÇO & EXCLUSÃO)           ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    local vtoy_mount
    vtoy_mount=$(get_ventoy_mount) || {
        echo -e "${RED}[ERRO] Partição do Ventoy não detectada ou montada.${NC}"
        read -rp "Pressione [ENTER] para voltar..." _
        return 1
    }

    while true; do
        clear
        local free_info
        free_info=$(df -h "$vtoy_mount" | awk 'NR==2 {printf "Usado: %s / %s (%s livre)", $3, $2, $4}')
        
        # Encontra imagens no Ventoy
        local iso_files=()
        while IFS= read -r f; do
            [ -f "$f" ] && iso_files+=("$f")
        done < <(find "$vtoy_mount" -maxdepth 3 -type f \( -iname "*.iso" -o -iname "*.img" -o -iname "*.vhd" -o -iname "*.vhdx" \) 2>/dev/null || true)

        echo -e "${PEACH}${BOLD}📋 Pen-drive Ventoy:${NC} ${BOLD}$vtoy_mount${NC}"
        echo -e "${CYAN}Capacidade:${NC} $free_info  •  ${GREEN}Total de Imagens:${NC} ${#iso_files[@]}\n"

        if [ ${#iso_files[@]} -eq 0 ]; then
            echo -e "${YELLOW}Nenhuma imagem ISO encontrada neste pen-drive.${NC}\n"
            read -rp "Pressione [ENTER] para voltar..." _
            break
        fi

        local lines=""
        for f in "${iso_files[@]}"; do
            local sz
            sz=$(ls -lh "$f" | awk '{print $5}')
            local name
            name=$(basename "$f")
            lines+="$f\t$name  [$sz]\t$f\n"
        done

        local sel
        sel=$(echo -e "$lines" | fzf_base \
            --prompt="Gerenciar Imagem > " \
            --header="[ENTER] Opções da Imagem • [j/k] Navegar • [ESC] Voltar ao Menu" \
            --delimiter="\t" \
            --with-nth=2 \
            --preview='echo -e "\n\033[1;38;2;203;166;247mArquivo:\033[0m {2}\n\033[1;38;2;137;180;250mCaminho:\033[0m {3}\n"; ls -lh "{1}" 2>/dev/null' \
            --preview-window="down:30%:wrap")

        [ -z "$sel" ] && break

        local target_file
        target_file=$(echo "$sel" | cut -f1)
        local base_name
        base_name=$(basename "$target_file")

        # Submenu para a ISO selecionada
        local sub_opts="1\t🔍 Calcular Checksum SHA256 (Verificar Integridade)\tCalcula o hash SHA256 do arquivo no pen-drive para garantir que não houve corrupção.\n2\t✏️ Renomear Arquivo\tAltera o nome do arquivo para mudar como ele aparece na lista do Ventoy.\n3\t🗑️ Excluir ISO do Pen-drive (Libera Espaço)\tRemove permanentemente a imagem para liberar espaço livre no pen-drive.\n4\t🔙 Voltar à Lista\tRetorna para a lista de imagens."

        local sub_sel
        sub_sel=$(echo -e "$sub_opts" | fzf_base \
            --prompt="Ação para $base_name > " \
            --delimiter="\t" \
            --with-nth=2 \
            --preview='echo -e "\n\033[1;38;2;203;166;247m{2}\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
            --preview-window="right:50%:wrap:border-rounded")

        [ -z "$sub_sel" ] && continue
        local sub_act
        sub_act=$(echo "$sub_sel" | cut -f1)

        case "$sub_act" in
            1)
                echo -e "\n${BLUE}Calculando hash SHA256 de ${BOLD}$base_name${NC}... (aguarde)"
                local hash
                hash=$(sha256sum "$target_file" | awk '{print $1}')
                echo -e "\n${GREEN}${BOLD}SHA256:${NC} ${MAUVE}$hash${NC}\n"
                read -rp "Pressione [ENTER] para continuar..." _
                ;;
            2)
                read -rp "Novo nome para o arquivo: " new_name
                if [ -n "$new_name" ]; then
                    local dir_name
                    dir_name=$(dirname "$target_file")
                    mv "$target_file" "$dir_name/$new_name"
                    echo -e "${GREEN}Arquivo renomeado com sucesso para $new_name!${NC}"
                    sleep 1
                fi
                ;;
            3)
                echo -e "\n${RED}${BOLD}CONFIRMAÇÃO DE EXCLUSÃO:${NC}"
                echo -e "Você está prestes a apagar: ${BOLD}$base_name${NC}"
                read -rp "Digite 'SIM' para apagar: " del_confirm
                if [ "$del_confirm" == "SIM" ]; then
                    rm -f "$target_file"
                    echo -e "${GREEN}Arquivo excluído com sucesso! Espaço liberado.${NC}"
                    sleep 1
                else
                    echo -e "${YELLOW}Exclusão cancelada.${NC}"
                    sleep 1
                fi
                ;;
            4)
                continue
                ;;
        esac
    done
}

# ------------------------------------------------------------------------------
# AÇÃO 6: VERIFICAR INTEGRIDADE (CHECKSUM SHA256)
# ------------------------------------------------------------------------------
action_verify_checksum() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  🔒  VERIFICADOR DE INTEGRIDADE SHA256 / MD5                     ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    echo -e "${BLUE}Buscando imagens (.iso, .img) no sistema e USBs...${NC}"
    local search_dirs=("$ISO_STORAGE_DIR" "/mnt/dados" "$HOME/downloads" "$HOME/Downloads")
    for m in /run/media/"$USER"/*; do
        [ -d "$m" ] && search_dirs+=("$m")
    done

    local iso_files=()
    for d in "${search_dirs[@]}"; do
        [ -d "$d" ] || continue
        while IFS= read -r f; do
            [ -f "$f" ] && iso_files+=("$f")
        done < <(find "$d" -maxdepth 4 -type f \( -iname "*.iso" -o -iname "*.img" \) 2>/dev/null || true)
    done

    if [ ${#iso_files[@]} -eq 0 ]; then
        read -rp "Digite o caminho completo da ISO: " manual_iso
        [ ! -f "$manual_iso" ] && return 0
        target_iso="$manual_iso"
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
            --prompt="Selecione a Imagem para Verificar > " \
            --delimiter="\t" \
            --with-nth=2 \
            --preview='echo -e "\n\033[1;38;2;203;166;247mArquivo:\033[0m {2}\n\033[1;38;2;137;180;250mCaminho:\033[0m {3}\n"; ls -lh "{1}" 2>/dev/null' \
            --preview-window="down:35%:wrap")

        [ -z "$sel" ] && return 0
        target_iso=$(echo "$sel" | cut -f1)
    fi

    local bname
    bname=$(basename "$target_iso")
    local fsize
    fsize=$(ls -lh "$target_iso" | awk '{print $5}')

    echo -e "\n${BLUE}Verificando integridade de:${NC} ${BOLD}$bname${NC} ($fsize)"
    echo -e "${YELLOW}Calculando SHA256... isso pode levar alguns segundos dependendo do tamanho.${NC}\n"

    local sha
    sha=$(sha256sum "$target_iso" | awk '{print $1}')
    local md5
    md5=$(md5sum "$target_iso" | awk '{print $1}')

    echo -e "${GREEN}${BOLD}================================================================${NC}"
    echo -e "  Arquivo: ${BOLD}$bname${NC}"
    echo -e "  SHA256:  ${MAUVE}${BOLD}$sha${NC}"
    echo -e "  MD5:     ${CYAN}$md5${NC}"
    echo -e "${GREEN}${BOLD}================================================================${NC}\n"

    read -rp "Pressione [ENTER] para voltar..." _
}

# ------------------------------------------------------------------------------
# AÇÃO 7: APLICAR TEMA CATPPUCCIN & CONFIGURAÇÃO AVANÇADA NO VENTOY
# ------------------------------------------------------------------------------
action_inject_catppuccin_theme() {
    clear
    echo -e "${MAUVE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  🎨  INJETOR DE TEMA CATPPUCCIN MOCHA & ventoy.json              ║"
    echo "╚══════════════════════════════════════════════════════════════════╗"
    echo -e "${NC}\n"

    local vtoy_mount
    vtoy_mount=$(get_ventoy_mount) || {
        echo -e "${RED}[ERRO] Partição do Ventoy não detectada ou montada.${NC}"
        read -rp "Pressione [ENTER] para voltar..." _
        return 1
    }

    echo -e "${CYAN}Alvo do Ventoy detectado:${NC} ${BOLD}$vtoy_mount${NC}\n"

    mkdir -p "$vtoy_mount/ventoy"
    mkdir -p "$vtoy_mount/ventoy/theme"

    echo -e "${BLUE}Gerando configuração avançada (ventoy.json)...${NC}"

    cat << 'EOF' > "$vtoy_mount/ventoy/ventoy.json"
{
  "control": [
    { "VTOY_DEFAULT_MENU_MODE": "0" },
    { "VTOY_FILER_SEARCH_ROOT": "/" },
    { "VTOY_DEFAULT_SEARCH_ROOT": "/" },
    { "VTOY_MENU_TIMEOUT": "15" },
    { "VTOY_SECONDARY_TIMEOUT": "15" },
    { "VTOY_MAX_SEARCH_LEVEL": "3" }
  ],
  "theme": {
    "file": "/ventoy/theme/theme.txt",
    "gfxmode": "1920x1080",
    "display_mode": "GUI",
    "ventoy_color": "#cba6f7"
  },
  "menu_alias": [
    {
      "image": "/rescuezilla-2.6.2-64bit.noble.iso",
      "alias": "🚑 Rescuezilla 2.6.2 — Backup & Clone Bare-Metal (Clonezilla GUI)"
    },
    {
      "image": "/systemrescue-13.02-amd64.iso",
      "alias": "🛠️ SystemRescue 13.02 — Recuperação, Reset Senha Windows & GParted"
    },
    {
      "image": "/HBCD_PE_x64.iso",
      "alias": "🪟 Hiren's BootCD PE x64 — Mini-Windows 11 de Manutenção Técnica"
    },
    {
      "image": "/Win11_25H2_BrazilianPortuguese_x64_v2.iso",
      "alias": "🪟 Windows 11 25H2 Oficial PT-BR — Instalação Limpa"
    },
    {
      "image": "/cachyos-desktop-linux-latest.iso",
      "alias": "🚀 CachyOS Desktop Live — Arch Linux Otimizado com Interface"
    },
    {
      "image": "/archlinux-x86_64.iso",
      "alias": "⚡ Arch Linux Oficial — Terminal Live de Emergência"
    }
  ]
}
EOF

    echo -e "${BLUE}Criando tema GRUB Catppuccin Mocha...${NC}"

    cat << 'EOF' > "$vtoy_mount/ventoy/theme/theme.txt"
# ==============================================================================
# 🌸 TEMA CATPPUCCIN MOCHA PARA VENTOY
# ==============================================================================
title-text: "✨ VENTOY MULTIBOOT COCKPIT"
title-font: "Unifont Regular 16"
title-color: "#cba6f7"
message-font: "Unifont Regular 14"
message-color: "#a6adc8"
terminal-font: "Unifont Regular 14"
desktop-color: "#1e1e2e"

+ boot_menu {
  left = 12%
  top = 18%
  width = 76%
  height = 64%
  item_color = "#cdd6f4"
  selected_item_color = "#11111b"
  item_height = 28
  item_padding = 4
  item_spacing = 6
  selected_item_pixmap_style = "solid"
}

+ label {
  top = 85%
  left = 12%
  width = 76%
  text = "[Enter] Boot  |  [F1] Ajuda  |  [F4] Localboot  |  [F5] Ferramentas"
  color = "#89b4fa"
  font = "Unifont Regular 12"
}
EOF

    echo -e "\n${GREEN}${BOLD}✔ Tema Catppuccin Mocha e ventoy.json aplicados com sucesso!${NC}\n"
    echo -e "Ao dar boot pelo pen-drive, o menu exibirá apelidos legíveis e tema estilizado."
    read -rp "Pressione [ENTER] para voltar..." _
}

# ------------------------------------------------------------------------------
# AÇÃO 8: ABRIR NO YAZI
# ------------------------------------------------------------------------------
action_open_yazi() {
    local vtoy_mount
    vtoy_mount=$(get_ventoy_mount) || {
        echo -e "${RED}Não foi possível localizar ou montar a partição do Ventoy.${NC}"
        sleep 1.5
        return 1
    }

    exec yazi "$vtoy_mount"
}

# ------------------------------------------------------------------------------
# AÇÃO 9: INSPECIONAR DISPOSITIVO USB & SMART
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

        local options="1\t🚀 Instalação Nova / Formatar Disco (Ventoy)\tFormata o pen-drive ou SSD com tabela MBR (Universal) ou GPT (UEFI Puro), Secure Boot e rótulo personalizado.\n2\t🔄 Atualizar Bootloader (SEM APAGAR AS ISOs)\tAtualiza a versão do bootloader sem formatar e sem tocar em nenhum dos seus arquivos existentes.\n3\t🌐 Baixar ISOs Técnicas com Aceleração 16x\tCentral de downloads oficial: Rescuezilla, SystemRescue, Hiren's PE, CachyOS, Arch Linux e Memtest.\n4\t⚡ Copiar Imagem ISO com Rsync Turbo\tLocaliza ISOs no seu computador e copia para a partição do Ventoy com máxima velocidade e integridade.\n5\t📋 Gerenciar ISOs do Pen-drive (Espaço & Exclusão)\tLista todas as ISOs instaladas, visualiza espaço livre restante e permite excluir imagens com segurança.\n6\t🔒 Verificar Integridade de ISO (Checksum SHA256)\tCalcula hashes SHA256 e MD5 para atestar que a imagem não foi corrompida antes de visitas a clientes.\n7\t🎨 Aplicar Tema Catppuccin Mocha & ventoy.json\tConfigura menu estilizado com cores Catppuccin e apelidos amigáveis para as imagens no boot.\n8\t📂 Abrir Partição de ISOs no Yazi\tAbre o gerenciador de arquivos rápido Yazi diretamente dentro do seu pen-drive de boot.\n9\t🔍 Inspecionar Saúde e Partições do Disco\tExibe SMART, temperatura, setores, velocidade negociada USB e partições detalhadas.\n10\t🚪 Sair\tFecha o assistente do Ventoy."

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
            3) action_download_iso ;;
            4) action_copy_iso ;;
            5) action_manage_ventoy_isos ;;
            6) action_verify_checksum ;;
            7) action_inject_catppuccin_theme ;;
            8) action_open_yazi ;;
            9) action_inspect ;;
            10) break ;;
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
        -d|download|--download)
            action_download_iso
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

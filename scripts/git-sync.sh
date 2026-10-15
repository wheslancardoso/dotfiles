#!/usr/bin/env bash
# ==============================================================================
# 🚀 GIT-SYNC — SINCRONIZADOR & AUDITOR DE REPOSITÓRIOS GIT MULTI-REPO
# ==============================================================================
# Inspeciona, audita e sincroniza em lote todos os repositórios Git locais com
# seus remotos (GitHub / GitLab) de forma segura, atômica e elegante.
#
# Uso:
#   git-sync                  -> Audita e exibe status de todos os repositórios
#   git-sync --status         -> Mesma auditoria tabular detalhada
#   git-sync --sync           -> Sincronização segura completa (fetch + pull + push)
#   git-sync --pull           -> Atualiza repositórios que estão atrasados (behind)
#   git-sync --push           -> Envia commits locais pendentes (ahead)
#   git-sync --stash          -> Aplica stash temporário em repos sujos antes do pull
#   git-sync --dry-run        -> Simula as ações sem alterar nenhum repositório
#   git-sync --all            -> Faz varredura ampla em $HOME (ignora caches/lixo)
#   git-sync /caminho/repo    -> Opera apenas nos diretórios especificados
# ==============================================================================

set -uo pipefail

# Paleta Catppuccin Mocha
MAUVE='\033[38;2;203;166;247m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
BLUE='\033[38;2;137;180;250m'
RED='\033[38;2;243;139;168m'
LAVENDER='\033[38;2;180;190;254m'
SAPPHIRE='\033[38;2;116;199;236m'
PEACH='\033[38;2;250;179;135m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
MUTED='\033[38;2;108;112;134m'
NC='\033[0m'
BOLD='\033[1m'

# Configurações padrão
MODE="status"      # status, sync, pull, push
AUTO_STASH=false
AUTO_COMMIT=false
COMMIT_MSG=""
DRY_RUN=false
SCAN_ALL=false
CUSTOM_PATHS=()

# Timeout em segundos para requisições de rede git
GIT_TIMEOUT=10

# Arquivo de configuração de repositórios conhecidos (opcional para o usuário)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-sync"
CONFIG_FILE="${CONFIG_DIR}/repos.conf"

show_help() {
    echo -e "${BOLD}${MAUVE}GIT-SYNC${NC} — Sincronizador & Auditor Multi-Repo Soberano

${BOLD}USO:${NC}
  ${GREEN}git-sync${NC} [OPÇÕES] [CAMINHOS...]

${BOLD}MODOS DE OPERAÇÃO:${NC}
  ${BLUE}-s, --status${NC}          Exibe tabela com o estado de todos os repositórios (padrão)
  ${BLUE}-S, --sync${NC}            Sincronização bidirecional segura (fetch -> pull --ff-only -> push)
  ${BLUE}-p, --pull${NC}            Atualiza apenas repositórios atrasados (behind)
  ${BLUE}-P, --push${NC}            Envia commits apenas de repositórios adiantados (ahead)

${BOLD}OPÇÕES DE COMMIT & MODIFICAÇÃO:${NC}
  ${PEACH}-c, --commit [MSG]${NC}    Faz commit automático (git add -A) das modificações locais antes do push
  ${YELLOW}--stash${NC}               Em repos com alterações não commitadas, faz stash antes de pull e restaura

${BOLD}OPÇÕES AUXILIARES:${NC}
  ${YELLOW}-n, --dry-run${NC}         Simula as operações sem executar comandos git destrutivos
  ${YELLOW}-a, --all${NC}             Varre recursivamente toda a pasta home (~/...) ignorando caches
  ${YELLOW}-t, --timeout <s >${NC}      Tempo limite para conexões com o servidor remoto (padrão: 10s)
  ${YELLOW}-h, --help${NC}            Exibe esta mensagem de ajuda

${BOLD}EXEMPLOS:${NC}
  ${MUTED}# Apenas checar o que está pendente ou desatualizado:${NC}
  git-sync
  git-sync --status

  ${MUTED}# Sincronizar todos os repos conhecidos com segurança:${NC}
  git-sync --sync

  ${MUTED}# Commitar todas as modificações locais e subir tudo para o remoto:${NC}
  git-sync --sync --commit "feat: sincronização geral"
  git-sync --sync -c

  ${MUTED}# Enviar commits pendentes sem baixar nada:${NC}
  git-sync --push

  ${MUTED}# Simular sincronização para ver o que seria feito:${NC}
  git-sync --sync --dry-run"
}

# Parse de argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--status)
            MODE="status"
            shift
            ;;
        -S|--sync)
            MODE="sync"
            shift
            ;;
        -p|--pull)
            MODE="pull"
            shift
            ;;
        -P|--push)
            MODE="push"
            shift
            ;;
        -c|--commit)
            AUTO_COMMIT=true
            # Se o próximo argumento existir e não começar com hífen, é a mensagem de commit
            if [[ $# -gt 1 && ! "$2" =~ ^- ]]; then
                COMMIT_MSG="$2"
                shift 2
            else
                COMMIT_MSG=""
                shift
            fi
            # Se o modo ainda for status, muda para sync por conveniência
            [ "$MODE" = "status" ] && MODE="sync"
            ;;
        --stash)
            AUTO_STASH=true
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -a|--all)
            SCAN_ALL=true
            shift
            ;;
        -t|--timeout)
            GIT_TIMEOUT="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}Erro: Opção desconhecida '$1'${NC}"
            echo -e "Use ${YELLOW}git-sync --help${NC} para ver as opções."
            exit 1
            ;;
        *)
            CUSTOM_PATHS+=("$1")
            shift
            ;;
    esac
done

# Descoberta de repositórios
get_repositories() {
    local repos=()

    # Se o usuário passou caminhos específicos via linha de comando
    if [ ${#CUSTOM_PATHS[@]} -gt 0 ]; then
        for p in "${CUSTOM_PATHS[@]}"; do
            local abs_p
            abs_p=$(realpath "$p" 2>/dev/null || echo "$p")
            if [ -d "$abs_p/.git" ]; then
                repos+=("$abs_p")
            elif [ -d "$abs_p" ]; then
                while IFS= read -r found; do
                    [ -n "$found" ] && repos+=("$(realpath "$(dirname "$found")")")
                done < <(find "$abs_p" -maxdepth 4 -name ".git" -type d 2>/dev/null)
            else
                echo -e "${YELLOW}Aviso: Diretório '$p' não encontrado.${NC}" >&2
            fi
        done
        printf '%s\n' "${repos[@]}" | sort -u
        return
    fi

    # Se existe arquivo de configuração explícito
    if [ -f "$CONFIG_FILE" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            # Ignora comentários e linhas vazias
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${line// }" ]] && continue
            local expanded="${line/#\~/$HOME}"
            local real_exp
            real_exp=$(realpath "$expanded" 2>/dev/null || echo "$expanded")
            if [ -d "$real_exp/.git" ]; then
                repos+=("$real_exp")
            fi
        done < "$CONFIG_FILE"

        if [ ${#repos[@]} -gt 0 ]; then
            printf '%s\n' "${repos[@]}" | sort -u
            return
        fi
    fi

    # Modo --all: varredura ampla em $HOME
    if [ "$SCAN_ALL" = true ]; then
        while IFS= read -r found; do
            local r_dir
            r_dir=$(realpath "$(dirname "$found")" 2>/dev/null || dirname "$found")
            # Ignora pastas de cache, yay, build, etc.
            if [[ "$r_dir" =~ /(node_modules|\.cache|\.cargo|\.rustup|\.local/share|yay|target|\.venv|\.oh-my-zsh|\.vscode) ]]; then
                continue
            fi
            repos+=("$r_dir")
        done < <(find "$HOME" -maxdepth 4 -name ".git" -type d 2>/dev/null)
        printf '%s\n' "${repos[@]}" | sort -u
        return
    fi

    # Lista prioritária / canônica de projetos do usuário
    local candidate_dirs=(
        "$HOME/dotfiles"
        "$HOME/concurso"
        "$HOME/timeless_life"
        "$HOME/apex-dl"
        "$HOME/agr-docs"
        "$HOME/finance-ia"
        "$HOME/zapscrap"
        "$HOME/tecconextension"
        "$HOME/teatro-abc"
        "$HOME/organizador-master"
        "$HOME/dynamic-water-reminder"
        "$HOME/Brazilian-Real-Estate-Intelligence"
        "$HOME/projects"
        "$HOME/projetos"
        "$HOME/Projetos"
    )

    for d in "${candidate_dirs[@]}"; do
        if [ -d "$d" ]; then
            local real_d
            real_d=$(realpath "$d" 2>/dev/null || echo "$d")
            if [ -d "$real_d/.git" ]; then
                repos+=("$real_d")
            elif [ -d "$real_d" ]; then
                while IFS= read -r found; do
                    [ -n "$found" ] && repos+=("$(realpath "$(dirname "$found")")")
                done < <(find "$real_d" -maxdepth 3 -name ".git" -type d 2>/dev/null)
            fi
        fi
    done

    # Também inspeciona diretórios de topo em ~
    for top in "$HOME"/*; do
        if [ -d "$top" ]; then
            local real_top
            real_top=$(realpath "$top" 2>/dev/null || echo "$top")
            if [ -d "$real_top/.git" ]; then
                repos+=("$real_top")
            fi
        fi
    done

    printf '%s\n' "${repos[@]}" | sort -u
}

# Função de execução com timeout seguro de rede
git_cmd_timeout() {
    local repo="$1"
    shift
    GIT_TERMINAL_PROMPT=0 timeout "$GIT_TIMEOUT" git -C "$repo" "$@" 2>/dev/null
}

main() {
    echo -e "${BOLD}${MAUVE}══════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${MAUVE}  ⚡ GIT-SYNC — Sincronizador Soberano de Repositórios Git${NC}"
    if [ "$DRY_RUN" = true ]; then
        echo -e "${PEACH}${BOLD}  [MODO DRY-RUN / SIMULAÇÃO ATIVADO — NENHUMA ALTERAÇÃO REAL SERÁ FEITA]${NC}"
    fi
    echo -e "${BOLD}${MAUVE}══════════════════════════════════════════════════════════════════════════════════${NC}"

    mapfile -t REPO_LIST < <(get_repositories)

    local total=${#REPO_LIST[@]}
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}Nenhum repositório Git encontrado para monitorar.${NC}"
        exit 0
    fi

    echo -e "${SUBTEXT}Detectados ${BOLD}${total}${NC}${SUBTEXT} repositórios ativos. Modo selecionado: ${BOLD}${BLUE}${MODE^^}${NC} (Timeout: ${GIT_TIMEOUT}s)${NC}"

    # Fetch em paralelo para performance instantânea
    echo -ne "${MUTED}↳ Atualizando referências remotas em paralelo... ${NC}"
    for r in "${REPO_LIST[@]}"; do
        (
            local r_remotes
            r_remotes=$(git -C "$r" remote 2>/dev/null || true)
            if [ -n "$r_remotes" ]; then
                git_cmd_timeout "$r" fetch --prune --quiet || true
            fi
        ) &
    done
    wait
    echo -e "${GREEN}Pronto!${NC}\n"

    # Cabeçalho da Tabela
    printf "${BOLD}%-28s %-16s %-14s %-18s %s${NC}\n" \
        "REPOSITÓRIO" "BRANCH" "LOCAL" "REMOTO" "AÇÃO / STATUS"
    echo -e "${MUTED}──────────────────────────────────────────────────────────────────────────────────${NC}"

    local count_synced=0
    local count_ahead=0
    local count_behind=0
    local count_diverged=0
    local count_dirty=0
    local count_noremote=0
    local count_errors=0

    # Contagem de nomes repetidos para desambiguação
    declare -A name_counts
    for r in "${REPO_LIST[@]}"; do
        local bn
        bn=$(basename "$r")
        name_counts["$bn"]=$(( ${name_counts["$bn"]:-0} + 1 ))
    done

    for repo in "${REPO_LIST[@]}"; do
        local full_name
        full_name=$(basename "$repo")
        local name_display="$full_name"

        # Se houver outro repositório com o mesmo nome na lista, adiciona contexto do pai
        if [ "${name_counts["$full_name"]:-0}" -gt 1 ]; then
            local parent_name
            parent_name=$(basename "$(dirname "$repo")")
            [ "$parent_name" = "lan" ] && parent_name="~"
            name_display="${full_name} (${parent_name})"
        fi

        [ ${#name_display} -gt 26 ] && name_display="${name_display:0:23}..."

        # Branch atual
        local full_branch
        full_branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
        local branch_display="$full_branch"
        [ ${#branch_display} -gt 14 ] && branch_display="${branch_display:0:12}.."

        # Checar se working tree está limpa ou suja
        local is_dirty=false
        local dirty_desc="Limpo"
        local dirty_color="$GREEN"

        local has_staged=false
        local has_unstaged=false
        local has_untracked=false

        if ! git -C "$repo" diff --cached --quiet 2>/dev/null; then
            has_staged=true
        fi
        if ! git -C "$repo" diff --quiet 2>/dev/null; then
            has_unstaged=true
        fi
        if [ -n "$(git -C "$repo" ls-files --others --exclude-standard 2>/dev/null)" ]; then
            has_untracked=true
        fi

        if [ "$has_staged" = true ] || [ "$has_unstaged" = true ] || [ "$has_untracked" = true ]; then
            is_dirty=true
            count_dirty=$((count_dirty + 1))
            dirty_color="$YELLOW"
            local flags=""
            [ "$has_staged" = true ] && flags="${flags}S"
            [ "$has_unstaged" = true ] && flags="${flags}M"
            [ "$has_untracked" = true ] && flags="${flags}?"
            dirty_desc="Modif (${flags})"
        fi

        # Checar remotos e upstream
        local upstream
        upstream=$(git -C "$repo" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)

        # Se não tem upstream configurado
        if [ -z "$upstream" ]; then
            local remotes
            remotes=$(git -C "$repo" remote 2>/dev/null || true)
            if [ -z "$remotes" ]; then
                printf "%-28s %-16s ${dirty_color}%-14s${NC} ${MUTED}%-18s${NC} ${SUBTEXT}%s${NC}\n" \
                    "$name_display" "$branch_display" "$dirty_desc" "Sem Remote" "Local Apenas"
                count_noremote=$((count_noremote + 1))
                continue
            else
                printf "%-28s %-16s ${dirty_color}%-14s${NC} ${YELLOW}%-18s${NC} ${SUBTEXT}%s${NC}\n" \
                    "$name_display" "$branch_display" "$dirty_desc" "Sem Upstream" "git push -u origin $full_branch"
                count_noremote=$((count_noremote + 1))
                continue
            fi
        fi

        # Calcula commits ahead e behind
        local ahead=0
        local behind=0
        ahead=$(git -C "$repo" rev-list --count "@{u}..HEAD" 2>/dev/null || echo 0)
        behind=$(git -C "$repo" rev-list --count "HEAD..@{u}" 2>/dev/null || echo 0)

        local remote_desc=""
        local remote_color=""
        local action_desc=""

        if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ]; then
            remote_desc="Sincronizado"
            remote_color="$GREEN"
            action_desc="OK"
            count_synced=$((count_synced + 1))
        elif [ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ]; then
            remote_desc="Ahead (${ahead})"
            remote_color="$PEACH"
            action_desc="Pendente Push"
            count_ahead=$((count_ahead + 1))
        elif [ "$ahead" -eq 0 ] && [ "$behind" -gt 0 ]; then
            remote_desc="Behind (${behind})"
            remote_color="$BLUE"
            action_desc="Pendente Pull"
            count_behind=$((count_behind + 1))
        else
            remote_desc="Divergiu (+${ahead}/-${behind})"
            remote_color="$RED"
            action_desc="Rebase/Merge"
            count_diverged=$((count_diverged + 1))
        fi

        # Exibição do status tabular
        printf "%-28s %-16s ${dirty_color}%-14s${NC} ${remote_color}%-18s${NC} ${BOLD}%s${NC}\n" \
            "$name_display" "$branch_display" "$dirty_desc" "$remote_desc" "$action_desc"

        # AÇÕES DE EXECUÇÃO (se não for apenas status)
        if [ "$MODE" != "status" ]; then
            # PULL
            if [ "$MODE" = "pull" ] || [ "$MODE" = "sync" ]; then
                if [ "$behind" -gt 0 ]; then
                    if [ "$is_dirty" = true ] && [ "$AUTO_STASH" = false ]; then
                        echo -e "   ${YELLOW}↳ Ignorando pull: Repositório possui modificações locais (use --stash para automatizar).${NC}"
                    else
                        if [ "$DRY_RUN" = true ]; then
                            echo -e "   ${PEACH}↳ [DRY-RUN] Executaria: git pull --ff-only${NC}"
                        else
                            local stash_created=false
                            if [ "$is_dirty" = true ] && [ "$AUTO_STASH" = true ]; then
                                echo -e "   ${MUTED}↳ Guardando alterações temporárias com git stash...${NC}"
                                git -C "$repo" stash push -u -m "git-sync-autostash-$(date +%s)" >/dev/null 2>&1 && stash_created=true
                            fi

                            echo -e "   ${BLUE}↳ Puxando ${behind} commit(s)...${NC}"
                            if git -C "$repo" pull --ff-only --quiet 2>/dev/null; then
                                echo -e "   ${GREEN}↳ Pull concluído com sucesso via Fast-Forward!${NC}"
                            else
                                echo -e "   ${RED}↳ Falha no pull: Não foi possível aplicar fast-forward.${NC}"
                            fi

                            if [ "$stash_created" = true ]; then
                                echo -e "   ${MUTED}↳ Restaurando alterações com git stash pop...${NC}"
                                git -C "$repo" stash pop --quiet >/dev/null 2>&1 || echo -e "   ${YELLOW}↳ Aviso: Verifique possíveis conflitos no stash.${NC}"
                            fi
                        fi
                    fi
                fi
            fi

            # AUTO-COMMIT (se solicitado via -c / --commit)
            if [ "$AUTO_COMMIT" = true ] && [ "$is_dirty" = true ]; then
                if [ "$behind" -gt 0 ]; then
                    echo -e "   ${YELLOW}↳ Ignorando auto-commit/push: Repositório possui commits remotos pendentes (faça pull primeiro).${NC}"
                else
                    local this_msg="${COMMIT_MSG:-sync: atualizações locais $(date '+%Y-%m-%d %H:%M')}"
                    if [ "$DRY_RUN" = true ]; then
                        echo -e "   ${PEACH}↳ [DRY-RUN] Executaria: git add -A && git commit -m \"$this_msg\"${NC}"
                        ahead=$((ahead + 1))
                    else
                        echo -e "   ${PEACH}↳ Gravando alterações locais: git commit -m \"$this_msg\"...${NC}"
                        git -C "$repo" add -A
                        if git -C "$repo" commit -m "$this_msg" --quiet 2>/dev/null; then
                            echo -e "   ${GREEN}↳ Commit criado com sucesso!${NC}"
                            is_dirty=false
                            ahead=$(git -C "$repo" rev-list --count "@{u}..HEAD" 2>/dev/null || echo 1)
                        else
                            echo -e "   ${RED}↳ Nenhuma alteração adicionada para commit.${NC}"
                        fi
                    fi
                fi
            fi

            # PUSH
            if [ "$MODE" = "push" ] || [ "$MODE" = "sync" ]; then
                # Recalcula ahead caso um pull ou commit tenha ocorrido
                [ "$DRY_RUN" = false ] && ahead=$(git -C "$repo" rev-list --count "@{u}..HEAD" 2>/dev/null || echo 0)
                if [ "$ahead" -gt 0 ]; then
                    if [ "$behind" -gt 0 ] && [ "$MODE" = "push" ]; then
                        echo -e "   ${RED}↳ Impossível dar push: Repositório está desatualizado em relação ao remoto (faça pull primeiro).${NC}"
                    else
                        if [ "$DRY_RUN" = true ]; then
                            echo -e "   ${PEACH}↳ [DRY-RUN] Executaria: git push origin $full_branch${NC}"
                        else
                            echo -e "   ${PEACH}↳ Enviando ${ahead} commit(s) para o remoto ($full_branch)...${NC}"
                            if git -C "$repo" push origin "$full_branch" --quiet 2>/dev/null; then
                                echo -e "   ${GREEN}↳ Push efetuado com sucesso!${NC}"
                            else
                                echo -e "   ${RED}↳ Falha ao enviar commits para o remoto.${NC}"
                            fi
                        fi
                    fi
                fi
            fi
        fi

    done

    echo -e "${MUTED}──────────────────────────────────────────────────────────────────────────────────${NC}"
    echo -e "${BOLD}RESUMO DO COCKPIT:${NC}"
    echo -e "  ${GREEN}● Sincronizados:${NC} ${count_synced}   ${BLUE}● Pendente Pull:${NC} ${count_behind}   ${PEACH}● Pendente Push:${NC} ${count_ahead}"
    echo -e "  ${YELLOW}● Com Modificações:${NC} ${count_dirty}   ${RED}● Divergentes:${NC} ${count_diverged}   ${MUTED}● Sem Upstream/Remote:${NC} ${count_noremote}   ${RED}● Erros/Timeout:${NC} ${count_errors}"
    echo -e "${BOLD}${MAUVE}══════════════════════════════════════════════════════════════════════════════════${NC}"

    if [ "$MODE" = "status" ]; then
        if [ "$count_behind" -gt 0 ] || [ "$count_ahead" -gt 0 ]; then
            echo -e "${SUBTEXT}Dica: Execute ${BOLD}${MAUVE}git-sync --sync${NC}${SUBTEXT} para sincronizar as pendências com segurança.${NC}"
        fi
        if [ "$count_dirty" -gt 0 ]; then
            echo -e "${SUBTEXT}Dica: Há modificações locais não commitadas. Use ${BOLD}${PEACH}git-sync --sync -c \"mensagem\"${NC}${SUBTEXT} para commitar e subir tudo ao GitHub.${NC}"
        fi
        echo ""
    fi
}

main


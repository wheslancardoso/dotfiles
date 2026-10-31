#!/usr/bin/env bash
# 🎮 Sincronização silenciosa e automatizada de saves via Ludusavi com notificação nativa

if command -v ludusavi &>/dev/null; then
    if command -v notify-send &>/dev/null; then
        notify-send -a "Ludusavi" -i "input-gaming" "Sincronizando Saves..." "Fazendo backup seguro de todos os seus jogos para a Nuvem."
    fi

    # Executa o backup automático do Ludusavi
    if ludusavi backup --force >/dev/null 2>&1; then
        if command -v notify-send &>/dev/null; then
            notify-send -a "Ludusavi" -i "input-gaming" "Saves Sincronizados! ✔" "Todos os saves de PC e Emuladores foram protegidos."
        fi
    else
        if command -v notify-send &>/dev/null; then
            notify-send -a "Ludusavi" -u critical "Aviso Ludusavi" "Houve um problema durante o backup dos saves."
        fi
    fi
else
    if command -v notify-send &>/dev/null; then
        notify-send -a "Ludusavi" "Ludusavi não instalado" "Instale com: yay -S ludusavi-bin"
    fi
fi

#!/usr/bin/env python3
"""
Logitech K380s / Universal Caps Lock Indicator & OSD Daemon
Monitora em tempo real o estado de Caps Lock via sysfs e hyprctl.
Oferece:
1. Streaming JSON em tempo real para a Waybar (widget custom/capslock)
2. Notificação OSD visual em tela cheia/desktop via notify-send ao alternar
3. Zero dependências externas (Python nativo) e baixíssimo consumo (< 0.01% CPU)
"""

import glob
import json
import os
import subprocess
import sys
import time


def get_caps_state() -> bool:
    """Verifica o estado atual do Caps Lock em microssegundos."""
    # 1. Leitura direta no sysfs (kernel Linux)
    led_files = glob.glob("/sys/class/leds/*::capslock/brightness")
    if led_files:
        for path in led_files:
            try:
                with open(path, "r") as f:
                    if f.read().strip() == "1":
                        return True
            except Exception:
                pass
        return False

    # 2. Fallback via hyprctl se sysfs não estiver acessível
    try:
        res = subprocess.run(
            ["hyprctl", "devices", "-j"],
            capture_output=True,
            text=True,
            check=False,
            timeout=1.0,
        )
        if res.returncode == 0 and res.stdout:
            data = json.loads(res.stdout)
            for kb in data.get("keyboards", []):
                if kb.get("capsLock", False):
                    return True
    except Exception:
        pass

    return False


def send_osd_notification(is_active: bool):
    """Exibe OSD visual na tela usando notify-send síncrono."""
    title = "Teclado Logitech K380s"
    if is_active:
        msg = "🔒 CAPS LOCK ATIVADO"
        icon = "dialog-warning"
    else:
        msg = "🔓 Caps Lock Desativado"
        icon = "input-keyboard"

    try:
        subprocess.run(
            [
                "notify-send",
                "-t", "1400",
                "-h", "string:x-canonical-private-synchronous:caps_lock",
                "-u", "low",
                "-i", icon,
                title,
                msg,
            ],
            check=False,
        )
    except Exception:
        pass


def run_waybar_mode():
    """Modo streaming para o módulo custom/capslock da Waybar."""
    last_state = get_caps_state()

    # Emite estado inicial
    initial_output = {
        "text": "󰪛 CAPS" if last_state else "",
        "class": "active" if last_state else "inactive",
        "tooltip": "Caps Lock: ATIVADO (K380s)" if last_state else "Caps Lock: Desativado",
    }
    print(json.dumps(initial_output), flush=True)

    while True:
        try:
            time.sleep(0.08)  # 80ms de ciclo de resposta instantânea
            current_state = get_caps_state()

            if current_state != last_state:
                # O estado mudou! Notifica na tela e atualiza Waybar
                send_osd_notification(current_state)

                data = {
                    "text": "󰪛 CAPS" if current_state else "",
                    "class": "active" if current_state else "inactive",
                    "tooltip": "Caps Lock: ATIVADO (K380s)" if current_state else "Caps Lock: Desativado",
                }
                print(json.dumps(data), flush=True)
                last_state = current_state
        except KeyboardInterrupt:
            break
        except Exception:
            time.sleep(0.5)


def run_daemon_mode():
    """Modo daemon independente (caso executado sem Waybar)."""
    last_state = get_caps_state()
    while True:
        try:
            time.sleep(0.08)
            current_state = get_caps_state()
            if current_state != last_state:
                send_osd_notification(current_state)
                last_state = current_state
        except KeyboardInterrupt:
            break
        except Exception:
            time.sleep(0.5)


if __name__ == "__main__":
    if "--status" in sys.argv:
        print("ON" if get_caps_state() else "OFF")
        sys.exit(0)

    if "--waybar" in sys.argv:
        run_waybar_mode()
    else:
        run_daemon_mode()

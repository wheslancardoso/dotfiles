#!/usr/bin/env bash
# ==============================================================================
# 🛑 Desativa dispositivos problemáticos em /proc/acpi/wakeup
# Evita que o computador acorde sozinho logo após ser suspenso.
# ==============================================================================

if [ -f /proc/acpi/wakeup ]; then
    # Dispositivos clássicos que causam acordar instantâneo ou espúrio:
    # GLAN (Ethernet Wake-on-LAN), GPP0 (PCI Express), XHC0/XHC (USB Hub controller sensível)
    for dev in GLAN GPP0 PEG0 XHC0 XHC; do
        if grep -q "^$dev.*enabled" /proc/acpi/wakeup 2>/dev/null; then
            echo "$dev" > /proc/acpi/wakeup 2>/dev/null || true
        fi
    done
fi

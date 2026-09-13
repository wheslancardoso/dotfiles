#!/usr/bin/env bash
# /* ---- 🛡️ anki-auth-status.sh: Status da Blindagem de Login do Anki ---- */

set -euo pipefail

VAULT="$HOME/.local/share/Anki2/.sync_vault.json"
PREFS="$HOME/.local/share/Anki2/prefs21.db"

echo -e "\033[1;36m=== 🛡️ ANKI SESSION & AUTH SHIELD STATUS ===\033[0m\n"

if [ ! -f "$PREFS" ]; then
    echo -e "\033[1;31m✖ Erro: prefs21.db não encontrado em $PREFS\033[0m"
    exit 1
fi

echo -e "\033[1;34m[1] Verificando prefs21.db (SQLite primário):\033[0m"
DB_STATUS=$(python3 -c '
import sqlite3, pickle
con = sqlite3.connect("'"$PREFS"'")
cur = con.cursor()
for name, data in cur.execute("SELECT name, data FROM profiles WHERE name != \"_global\""):
    obj = pickle.loads(data)
    user = obj.get("syncUser")
    key = obj.get("syncKey")
    if key:
        print(f"✔ Perfil \"{name}\": Conectado como {user} (Token presente)")
    else:
        print(f"✖ Perfil \"{name}\": Não autenticado (syncKey = None)")
' 2>/dev/null || echo "Erro ao ler banco")
echo "  $DB_STATUS"

echo -e "\n\033[1;34m[2] Verificando Persistent Auth Vault (~/.local/share/Anki2/.sync_vault.json):\033[0m"
if [ -f "$VAULT" ]; then
    VAULT_STATUS=$(python3 -c '
import json
with open("'"$VAULT"'") as f:
    data = json.load(f)
for prof, info in data.items():
    user = info.get("syncUser", "-")
    if info.get("syncKey"):
        print(f"✔ Blindagem Ativa: Perfil \"{prof}\" salvo com usuário {user}")
    else:
        print(f"✖ Blindagem Vazia: Perfil \"{prof}\" sem token")
' 2>/dev/null || echo "Vault vazio ou inválido")
    echo "  $VAULT_STATUS"
else
    echo -e "  \033[1;33m⚠ Vault ainda não criado (será gerado automaticamente assim que fizer login no Anki).\033[0m"
fi

echo -e "\n\033[1;34m[3] Addon de Autoproteção:\033[0m"
if [ -d "$HOME/.local/share/Anki2/addons21/persistent_auth_vault" ]; then
    echo -e "  \033[1;32m✔ persistent_auth_vault instalado e ativo em addons21/\033[0m"
else
    echo -e "  \033[1;31m✖ Addon não encontrado em addons21/\033[0m"
fi

echo -e "\n\033[1;34m[4] Validador de Certificados SSL (Truststore):\033[0m"
if pacman -Q python-truststore &>/dev/null; then
    echo -e "  \033[1;32m✔ python-truststore instalado (SSL do sistema 100% integrado)\033[0m"
else
    echo -e "  \033[1;31m✖ python-truststore não instalado\033[0m"
fi

echo -e "\n\033[1;35m════════════════════════════════════════════════════════════════\033[0m"

# -*- coding: utf-8 -*-
"""
==============================================================================
🔒 Persistent Auth Vault & Session Guard for Anki
==============================================================================
Garante persistência imediata, atômica e definitiva das credenciais e tokens
do AnkiWeb em disco, impedindo deslogamentos ao fechar janelas, suspender ou
reiniciar o computador.
==============================================================================
"""

import os
import sys
import json
import signal
from pathlib import Path

import aqt
from aqt import mw, gui_hooks
from aqt.profiles import ProfileManager
from aqt.main import AnkiQt
from aqt.preferences import Preferences
from aqt.qt import QTimer

VAULT_PATH = os.path.expanduser("~/.local/share/Anki2/.sync_vault.json")


def _read_vault() -> dict:
    if not os.path.exists(VAULT_PATH):
        return {}
    try:
        with open(VAULT_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"[AuthVault] Aviso ao ler vault: {e}", file=sys.stderr)
        return {}


def _write_vault(vault: dict) -> None:
    try:
        tmp_path = VAULT_PATH + ".tmp"
        with open(tmp_path, "w", encoding="utf-8") as f:
            json.dump(vault, f, indent=2, ensure_ascii=False)
        os.chmod(tmp_path, 0o600)
        os.replace(tmp_path, VAULT_PATH)
    except Exception as e:
        print(f"[AuthVault] Erro ao gravar vault: {e}", file=sys.stderr)


def update_vault_credentials(profile_name: str, **kwargs) -> None:
    if not profile_name:
        return
    vault = _read_vault()
    if profile_name not in vault:
        vault[profile_name] = {}
    
    for k, v in kwargs.items():
        if v is not None:
            vault[profile_name][k] = v
        elif k in vault[profile_name] and kwargs.get("_force_none"):
            vault[profile_name][k] = None

    _write_vault(vault)


def clear_vault_credentials(profile_name: str) -> None:
    if not profile_name:
        return
    vault = _read_vault()
    if profile_name in vault:
        del vault[profile_name]
        _write_vault(vault)
        print(f"[AuthVault] Credenciais do perfil '{profile_name}' removidas do vault (logout explícito).")


def force_save_profile(pm: ProfileManager) -> None:
    """Força commit imediato do perfil e das credenciais no prefs21.db."""
    try:
        if pm and hasattr(pm, "db") and pm.db and pm.name:
            pm.save()
            print("[AuthVault] Perfil e tokens persistidos com sucesso no prefs21.db.")
    except Exception as e:
        print(f"[AuthVault] Erro ao salvar perfil no prefs21.db: {e}", file=sys.stderr)


# ----------------------------------------------------------------------------
# 1. INTERCEPTAÇÃO DE DEFINIÇÃO DE TOKENS (SALVAMENTO INSTANTÂNEO EM 0ms)
# ----------------------------------------------------------------------------
_orig_set_sync_key = ProfileManager.set_sync_key
_orig_set_sync_username = ProfileManager.set_sync_username
_orig_set_current_sync_url = ProfileManager.set_current_sync_url
_orig_set_host_number = ProfileManager.set_host_number


def _guarded_set_sync_key(self: ProfileManager, val: str | None) -> None:
    _orig_set_sync_key(self, val)
    if val:
        update_vault_credentials(self.name, syncKey=val)
        force_save_profile(self)


def _guarded_set_sync_username(self: ProfileManager, val: str | None) -> None:
    _orig_set_sync_username(self, val)
    if val:
        update_vault_credentials(self.name, syncUser=val)
        force_save_profile(self)


def _guarded_set_current_sync_url(self: ProfileManager, url: str | None) -> None:
    _orig_set_current_sync_url(self, url)
    if url:
        update_vault_credentials(self.name, currentSyncUrl=url)
        force_save_profile(self)


def _guarded_set_host_number(self: ProfileManager, val: int | None) -> None:
    _orig_set_host_number(self, val)
    if val is not None:
        update_vault_credentials(self.name, hostNum=val)
        force_save_profile(self)


ProfileManager.set_sync_key = _guarded_set_sync_key
ProfileManager.set_sync_username = _guarded_set_sync_username
ProfileManager.set_current_sync_url = _guarded_set_current_sync_url
ProfileManager.set_host_number = _guarded_set_host_number


# ----------------------------------------------------------------------------
# 2. RESTAURAÇÃO AUTOMÁTICA NA INICIALIZAÇÃO / ABERTURA DE PERFIL
# ----------------------------------------------------------------------------
def _on_profile_did_open() -> None:
    if not mw or not mw.pm:
        return
    pm = mw.pm
    profile_name = pm.name or "Usuário 1"
    current_key = pm.profile.get("syncKey")
    current_user = pm.profile.get("syncUser")

    vault = _read_vault()
    saved_cred = vault.get(profile_name, {})

    if current_key:
        # Perfil já possui token: atualiza vault e garante sincronia em disco
        update_vault_credentials(
            profile_name,
            syncKey=current_key,
            syncUser=current_user,
            hostNum=pm.profile.get("hostNum", 0),
            currentSyncUrl=pm.profile.get("currentSyncUrl"),
        )
        force_save_profile(pm)
    elif saved_cred.get("syncKey"):
        # Perfil estava sem token mas o vault possui credenciais blindadas: restaura!
        print(f"[AuthVault] 🔄 Restaurando sessão do AnkiWeb para '{saved_cred.get('syncUser')}'...")
        pm.profile["syncKey"] = saved_cred["syncKey"]
        if saved_cred.get("syncUser"):
            pm.profile["syncUser"] = saved_cred["syncUser"]
        if "hostNum" in saved_cred:
            pm.profile["hostNum"] = saved_cred["hostNum"]
        if "currentSyncUrl" in saved_cred:
            pm.profile["currentSyncUrl"] = saved_cred["currentSyncUrl"]

        force_save_profile(pm)

        if hasattr(mw, "toolbar") and mw.toolbar:
            mw.toolbar.redraw()


gui_hooks.profile_did_open.append(_on_profile_did_open)


# ----------------------------------------------------------------------------
# 3. SALVAMENTO AUTOMÁTICO APÓS QUALQUER SINCRONIZAÇÃO
# ----------------------------------------------------------------------------
def _on_sync_did_finish() -> None:
    if mw and mw.pm:
        key = mw.pm.profile.get("syncKey")
        if key:
            update_vault_credentials(
                mw.pm.name,
                syncKey=key,
                syncUser=mw.pm.profile.get("syncUser"),
                hostNum=mw.pm.profile.get("hostNum", 0),
                currentSyncUrl=mw.pm.profile.get("currentSyncUrl"),
            )
            force_save_profile(mw.pm)


gui_hooks.sync_did_finish.append(_on_sync_did_finish)


# ----------------------------------------------------------------------------
# 4. LOGOUT EXPLÍCITO NAS PREFERÊNCIAS
# ----------------------------------------------------------------------------
_orig_sync_logout = Preferences.sync_logout


def _guarded_sync_logout(self: Preferences) -> None:
    if self.mw and self.mw.pm:
        clear_vault_credentials(self.mw.pm.name)
    return _orig_sync_logout(self)


Preferences.sync_logout = _guarded_sync_logout


# ----------------------------------------------------------------------------
# 5. BLINDAGEM NO FECHAMENTO DE JANELAS (SUPER + Q / SIGTERM / REBOOT)
# ----------------------------------------------------------------------------
_orig_closeEvent = AnkiQt.closeEvent


def _guarded_closeEvent(self: AnkiQt, event) -> None:
    # Salva ANTES de qualquer processo em segundo plano ou cancelamento
    try:
        if self.pm:
            force_save_profile(self.pm)
    except Exception:
        pass
    return _orig_closeEvent(self, event)


AnkiQt.closeEvent = _guarded_closeEvent


def _sig_handler(signum, frame) -> None:
    try:
        if mw and mw.pm:
            force_save_profile(mw.pm)
    except Exception:
        pass
    sys.exit(0)


try:
    signal.signal(signal.SIGTERM, _sig_handler)
    signal.signal(signal.SIGINT, _sig_handler)
except Exception:
    pass


if mw and hasattr(mw, "app") and mw.app:
    mw.app.aboutToQuit.connect(lambda: force_save_profile(mw.pm) if (mw and mw.pm) else None)


# ----------------------------------------------------------------------------
# 6. TIMER DE HIGIENE PERIÓDICA (A CADA 60 SEGUNDOS)
# ----------------------------------------------------------------------------
def _setup_timer():
    try:
        if mw and hasattr(mw, "app") and mw.app:
            timer = QTimer(mw)
            timer.setInterval(60000)
            def _periodic_check():
                if mw and mw.pm and mw.pm.profile.get("syncKey"):
                    force_save_profile(mw.pm)
            timer.timeout.connect(_periodic_check)
            timer.start()
    except Exception:
        pass

gui_hooks.profile_did_open.append(_setup_timer)

print("[AuthVault] 🛡️ Persistent Auth Vault ativado com sucesso!")

#!/usr/bin/env bash
# Wrapper para alternar a conexão com o Google Drive 5TB (Rclone VFS)
exec "$HOME/dotfiles/scripts/gdrive-mount.sh" toggle

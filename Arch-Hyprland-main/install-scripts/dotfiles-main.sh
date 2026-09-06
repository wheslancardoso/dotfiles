#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Hyprland-Dots to download from main #


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$SCRIPT_DIR/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Check if Wheslan Master Dotfiles should be used
USER_DOTFILES_REPO="${USER_DOTFILES_REPO:-https://github.com/wheslancardoso/dotfiles.git}"
DOTFILES_DIR="$HOME/dotfiles"

if [ "$custom_dots" == "ON" ] || [ -d "$DOTFILES_DIR" ] || [ "$use_master_dots" == "true" ]; then
  printf "${NOTE} Setting up ${SKY_BLUE}Wheslan Master Dotfiles & Vibe Coding Suite${RESET}....\n"
  if [ ! -d "$DOTFILES_DIR" ]; then
    printf "${NOTE} Cloning ${SKY_BLUE}$USER_DOTFILES_REPO${RESET} into $DOTFILES_DIR...\n"
    if ! git clone "$USER_DOTFILES_REPO" "$DOTFILES_DIR"; then
      echo -e "$ERROR Failed to clone $USER_DOTFILES_REPO. Falling back to default KooL dots."
    fi
  fi

  if [ -f "$DOTFILES_DIR/setup.sh" ]; then
    echo -e "${OK} Running Master Dotfiles setup (${DOTFILES_DIR}/setup.sh)..."
    chmod +x "$DOTFILES_DIR/setup.sh"
    local setup_args=()
    if [ "$non_interactive" == "true" ]; then
      setup_args+=("--non-interactive")
    fi
    cd "$DOTFILES_DIR" && bash ./setup.sh "${setup_args[@]}"
    printf "\n%.0s" {1..2}
    exit 0
  fi
fi

# Fallback to standard KooL Hyprland-Dots
printf "${NOTE} Cloning and Installing ${SKY_BLUE}KooL's Hyprland Dots${RESET}....\n"

if [ -d Hyprland-Dots ]; then
  cd Hyprland-Dots
  git stash && git pull
  chmod +x copy.sh
  ./copy.sh 
else
  if git clone --depth=1 https://github.com/JaKooLit/Hyprland-Dots; then
    cd Hyprland-Dots || exit 1
    chmod +x copy.sh
    ./copy.sh 
  else
    echo -e "$ERROR Can't download ${YELLOW}KooL's Hyprland-Dots${RESET} . Check your internet connection"
  fi
fi

printf "\n%.0s" {1..2}
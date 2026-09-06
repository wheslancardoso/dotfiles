#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Global Functions for Scripts #

set -e

# Set some colors for output messages
OK="$(tput setaf 2 2>/dev/null || true)[OK]$(tput sgr0 2>/dev/null || true)"
ERROR="$(tput setaf 1 2>/dev/null || true)[ERROR]$(tput sgr0 2>/dev/null || true)"
NOTE="$(tput setaf 3 2>/dev/null || true)[NOTE]$(tput sgr0 2>/dev/null || true)"
INFO="$(tput setaf 4 2>/dev/null || true)[INFO]$(tput sgr0 2>/dev/null || true)"
WARN="$(tput setaf 1 2>/dev/null || true)[WARN]$(tput sgr0 2>/dev/null || true)"
CAT="$(tput setaf 6 2>/dev/null || true)[ACTION]$(tput sgr0 2>/dev/null || true)"
MAGENTA="$(tput setaf 5 2>/dev/null || true)"
ORANGE="$(tput setaf 214 2>/dev/null || true)"
WARNING="$(tput setaf 1 2>/dev/null || true)"
YELLOW="$(tput setaf 3 2>/dev/null || true)"
GREEN="$(tput setaf 2 2>/dev/null || true)"
BLUE="$(tput setaf 4 2>/dev/null || true)"
SKY_BLUE="$(tput setaf 6 2>/dev/null || true)"
RESET="$(tput sgr0 2>/dev/null || true)"

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Show progress function
show_progress() {
    local pid=$1
    local package_name=$2
    local spin_chars=("●○○○○○○○○○" "○●○○○○○○○○" "○○●○○○○○○○" "○○○●○○○○○○" "○○○○●○○○○" \
                      "○○○○○●○○○○" "○○○○○○●○○○" "○○○○○○○●○○" "○○○○○○○○●○" "○○○○○○○○○●") 
    local i=0

    tput civis 
    printf "\r${NOTE} Installing ${YELLOW}%s${RESET} ..." "$package_name"

    while ps -p $pid &> /dev/null; do
        printf "\r${NOTE} Installing ${YELLOW}%s${RESET} %s" "$package_name" "${spin_chars[i]}"
        i=$(( (i + 1) % 10 ))  
        sleep 0.3  
    done

    printf "\r${NOTE} Installing ${YELLOW}%s${RESET} ... Done!%-20s \n" "$package_name" ""
    tput cnorm  
}



# Function to install packages with pacman
install_package_pacman() {
  # Check if package is already installed
  if pacman -Q "$1" &>/dev/null ; then
    echo -e "${INFO} ${MAGENTA}$1${RESET} is already installed. Skipping..."
  else
    # Run pacman and redirect all output to a log file
    (
      stdbuf -oL sudo pacman -S --noconfirm "$1" 2>&1
    ) >> "$LOG" 2>&1 &
    PID=$!
    show_progress $PID "$1" 

    # Double check if package is installed
    if pacman -Q "$1" &>/dev/null ; then
      echo -e "${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
    else
      echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed to install. Please check the $LOG. You may need to install manually."
    fi
  fi
}

ISAUR=$(command -v yay || command -v paru)
# Function to install packages with either yay or paru
install_package() {
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${INFO} ${MAGENTA}$1${RESET} is already installed. Skipping..."
  else
    (
      stdbuf -oL $ISAUR -S --noconfirm "$1" 2>&1
    ) >> "$LOG" 2>&1 &
    PID=$!
    show_progress $PID "$1"  
    
    # Double check if package is installed
    if $ISAUR -Q "$1" &>> /dev/null ; then
      echo -e "${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
    else
      # Something is missing, exiting to review log
      echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
    fi
  fi
}

# Function to just install packages with either yay or paru without checking if installed
install_package_f() {
  (
    stdbuf -oL $ISAUR -S --noconfirm "$1" 2>&1
  ) >> "$LOG" 2>&1 &
  PID=$!
  show_progress $PID "$1"  

  # Double check if package is installed
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
  else
    # Something is missing, exiting to review log
    echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
  fi
}


# Function for removing packages
uninstall_package() {
  local pkg="$1"

  # Checking if package is installed
  if pacman -Qi "$pkg" &>/dev/null; then
    echo -e "${NOTE} removing $pkg ..."
    sudo pacman -R --noconfirm "$pkg" 2>&1 | tee -a "$LOG" | grep -v "error: target not found"
    
    if ! pacman -Qi "$pkg" &>/dev/null; then
      echo -e "\e[1A\e[K${OK} $pkg removed."
    else
      echo -e "\e[1A\e[K${ERROR} $pkg Removal failed. No actions required."
      return 1
    fi
  else
    echo -e "${INFO} Package $pkg not installed, skipping."
  fi
  return 0
}

# Function to install a list of packages in fast batch mode (10x faster)
install_packages_batch() {
  local pkgs=("$@")
  local to_install=()

  ISAUR=$(command -v yay || command -v paru || true)

  for p in "${pkgs[@]}"; do
    [ -z "$p" ] && continue
    if ! pacman -Q "$p" &>/dev/null; then
      to_install+=("$p")
    fi
  done

  if [ ${#to_install[@]} -eq 0 ]; then
    echo -e "${OK} All packages in batch are already installed!"
    return 0
  fi

  echo -e "${NOTE} Attempting batch install of ${#to_install[@]} packages via pacman..."
  if sudo pacman -S --needed --noconfirm "${to_install[@]}" >> "$LOG" 2>&1; then
    echo -e "${OK} Batch pacman installation completed successfully!"
    return 0
  fi

  echo -e "${WARN} Some packages might belong to AUR. Trying batch via AUR helper (${ISAUR:-yay})..."
  if [ -n "$ISAUR" ]; then
    if $ISAUR -S --needed --noconfirm "${to_install[@]}" >> "$LOG" 2>&1; then
      echo -e "${OK} Batch AUR helper installation completed successfully!"
      return 0
    fi
  fi

  echo -e "${WARN} Batch installation had failures. Falling back to granular install..."
  for pkg in "${to_install[@]}"; do
    install_package "$pkg" "$LOG"
  done
}
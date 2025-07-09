#!/bin/bash

set -e

echo ">>> Beginning setup..."

# Define dotfiles repo directory
DOTFILES_DIR="$HOME/.dotfiles"

# Required packages
PACKAGES=(
  bspwm sxhkd polybar rofi picom alacritty feh zsh git curl unzip wget pywal
  neofetch networkmanager sddm xorg xorg-xinit
)

echo ">>> Installing required packages..."
sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"

# Clone dotfiles if not already
if [ ! -d "$DOTFILES_DIR" ]; then
  echo ">>> Cloning dotfiles..."
  git clone https://github.com/roman-xo/dot-test "$DOTFILES_DIR"
fi

echo ">>> Symlinking dotfiles..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.config" "$HOME/.config"
ln -sf "$DOTFILES_DIR/.xinitrc" "$HOME/.xinitrc" 2>/dev/null || true

echo ">>> Installing oh-my-zsh..."
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo ">>> Setting Zsh as default shell..."
chsh -s "$(which zsh)"

echo ">>> Enabling services..."
sudo systemctl enable NetworkManager
sudo systemctl enable sddm

echo ">>> Setting up wallpaper and pywal..."
mkdir -p "$HOME/wallpapers"
cp "$DOTFILES_DIR/wallpapers/default.jpg" "$HOME/wallpapers/default.jpg"

# Generate pywal theme
wal -i "$HOME/wallpapers/default.jpg"

echo ">>> Writing .xprofile for auto-theme on login..."
cat << 'EOF' > "$HOME/.xprofile"
[ -f "$HOME/.cache/wal/colors.sh" ] && source "$HOME/.cache/wal/colors.sh"
feh --bg-scale "$(cat "$HOME/.cache/wal/wal")"
EOF

echo ">>> Done! Reboot to enter your custom environment."

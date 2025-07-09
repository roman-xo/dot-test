#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/roman-xo/dot-test.git"

echo ">>> Installing base packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git bspwm sxhkd polybar rofi picom feh \
  alacritty zsh neofetch pywal sddm xorg-server xorg-xinit \
  network-manager-applet networkmanager unzip

echo ">>> Cloning dotfiles..."
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

echo ">>> Linking configs..."
ln -sf "$DOTFILES_DIR/.xinitrc" "$HOME/.xinitrc"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

for cfg in bspwm sxhkd polybar rofi picom alacritty wal; do
  mkdir -p "$HOME/.config/$cfg"
  ln -sf "$DOTFILES_DIR/.config/$cfg/"* "$HOME/.config/$cfg/"
done

echo ">>> Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ">>> Enabling services..."
sudo systemctl enable --now sddm
sudo systemctl enable --now NetworkManager

echo ">>> Setting Zsh as default shell..."
chsh -s "$(which zsh)"

echo ">>> Setup Complete!"

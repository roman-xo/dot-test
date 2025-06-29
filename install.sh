#!/bin/bash

# Exit if any command fails
set -e

# Update system
sudo pacman -Syu --noconfirm

# Install essential packages
sudo pacman -S --noconfirm \
    bspwm sxhkd picom kitty zsh feh xorg-server xorg-xinit \
    git curl wget unzip neofetch htop \
    python-pywal unzip \
    sddm xdg-user-dirs

# Optional but useful
sudo pacman -S --noconfirm thunar pavucontrol rofi

# Install Nerd Fonts (JetBrainsMono + Symbols) using an AUR helper
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    cd /opt
    sudo git clone https://aur.archlinux.org/yay.git
    sudo chown -R $USER:$USER yay
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

yay -S --noconfirm nerd-fonts-jetbrains-mono ttf-symbols-nerd

# Enable SDDM
sudo systemctl enable sddm

# Set Zsh as default shell
chsh -s $(which zsh)

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Clone zsh-autosuggestions if not already
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Setup XDG user dirs
xdg-user-dirs-update

# Copy dotfiles from repo to home
echo "Copying dotfiles..."
cp -r .config ~/
cp .zshrc ~/

# Ensure scripts are executable
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc

# Set wallpaper and generate Pywal theme
wal -i ~/Pictures/wallpaper.jpg || wal -n -c # fallback if no image

echo "Done! Rebooting into your new environment..."
reboot

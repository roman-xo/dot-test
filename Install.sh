#!/bin/bash
set -e

echo "[1/7] System update & core packages"
sudo pacman -Syu --noconfirm

echo "[2/7] Installing core system packages"
sudo pacman -S --noconfirm \
    bspwm sxhkd picom kitty zsh feh xorg-server xorg-xinit \
    git curl wget unzip htop \
    python-pywal \
    sddm xdg-user-dirs \
    thunar pavucontrol rofi

echo "[3/7] Installing yay (AUR helper) if not already present"
if ! command -v yay &>/dev/null; then
    cd /opt
    sudo git clone https://aur.archlinux.org/yay.git
    sudo chown -R "$USER":"$USER" yay
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

echo "[4/7] Installing AUR packages (Nerd Fonts, neofetch)"
yay -S --noconfirm nerd-fonts-jetbrains-mono ttf-symbols-nerd neofetch

echo "[5/7] Setting up dotfiles"
cp -r .config ~/
cp .zshrc ~/
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc

echo "[6/7] Setting up Oh My Zsh & plugins"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi
chsh -s $(which zsh)

echo "[7/7] Finishing touches"
xdg-user-dirs-update
wal -i ~/Pictures/wallpaper.jpg || wal -n -c
sudo systemctl enable sddm

echo "✅ All done. Rebooting into your new environment!"
reboot

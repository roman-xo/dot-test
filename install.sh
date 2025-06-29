
#!/bin/bash

# Exit on error
set -e

# Update and install base packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git base-devel xorg xorg-xinit sddm bspwm sxhkd kitty zsh zsh-autosuggestions neofetch picom polybar feh python-pywal lxappearance nitrogen

# Optional but useful tools
sudo pacman -S --noconfirm dolphin pavucontrol rofi

# Clone dotfiles repo (assuming you're running this from a fresh system)
git clone https://github.com/roman-xo/dot-test.git ~/dotfiles
cd ~/dotfiles

# Copy config files
cp -r .config ~/
cp .zshrc ~/

# Enable SDDM
sudo systemctl enable sddm

# Set Zsh as default shell
chsh -s $(which zsh)

echo "Installation complete. Reboot your system."

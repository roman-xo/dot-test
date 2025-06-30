#!/usr/bin/env bash
set -e

echo "[*] 1/7 | System update & core packages"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
  bspwm sxhkd picom kitty zsh feh xorg-server xorg-xinit \
  git curl wget unzip neofetch htop python-pywal \
  polybar rofi pavucontrol dolphin sddm xdg-user-dirs

echo "[*] 2/7 | Install yay (AUR helper) if missing"
if ! command -v yay >/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd ~ && rm -rf /tmp/yay
else
  echo "-- yay already installed"
fi

echo "[*] 3/7 | Install Nerd Fonts"
yay -S --noconfirm nerd-fonts-jetbrains-mono nerd-fonts-symbols

echo "[*] 4/7 | Oh My Zsh + autosuggestions"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

echo "[*] 5/7 | Copy dotfiles from repo"
DOT="$HOME/.dotfiles"
if [ ! -d "$DOT" ]; then
  git clone https://github.com/roman-xo/dot-test.git "$DOT"
fi
cp -rT "$DOT/.config" "$HOME/.config"
cp "$DOT/.zshrc" "$HOME/.zshrc"
[ -f "$DOT/.xprofile" ] && cp "$DOT/.xprofile" "$HOME/.xprofile"
chmod +x "$HOME/.config/bspwm/bspwmrc" "$HOME/.config/sxhkd/sxhkdrc"

echo "[*] 6/7 | Enable display manager & default shell"
chsh -s "$(which zsh)"
sudo systemctl enable sddm

echo "[*] 7/7 | Apply wallpaper + pywal (ensure ~/.config/wall.jpg exists)"
if [ -f "$HOME/.config/wall.jpg" ]; then
  wal -i "$HOME/.config/wall.jpg"
else
  echo "-- No wallpaper found at ~/.config/wall.jpg. Skipped pywal."
fi

echo "[✓] Setup complete! Reboot to enjoy your riced desktop."

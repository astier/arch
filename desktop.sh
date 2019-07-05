#!/usr/bin/env sh

# Internet
# Setup networkd first (see arch-wiki)
sudo systemctl enable --now ead.service iwd.service systemd-networkd.service systemd-resolved.service
sudo ln -fs /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Packages
sudo pacman -S reflector
sudo reflector -p https -f16 -l8 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -S arc-gtk-theme dash dunst firefox git light neovim pulsemixer slock tmux ttf-dejavu ufw unclutter xcompmgr xorg-server xorg-xinit xsel
sudo pacman -Rns dhcpcd nano netctl s-nail vi

# AUR
git clone https://aur.archlinux.org/yay
cd yay && makepkg -is
cd && rm -fr yay .config/go-build
sudo pacman -Rns go
yay -S dropbox

# Projects
mkdir projects && cd projects
git clone https://github.com/astier/arch
git clone https://github.com/astier/dotfiles
git clone https://github.com/astier/scripts
cd dotfiles && sh setup.sh
cd ../scripts && sh setup.sh

# Suckless
cd ~/projects && mkdir suckless && cd suckless
git clone https://github.com/astier/dmenu
git clone https://github.com/astier/dwm
git clone https://github.com/astier/st
cd dmenu && sudo make install clean
cd ../dwm && sudo make install clean
cd ../st && sudo make install clean

# Configuration
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo ln -sfT dash /usr/bin/sh
sudo ln /usr/local/bin/st /usr/bin/xterm
sudo localectl set-x11-keymap us pc105 altgr-intl caps:swapescape
sudo systemctl enable systemd-timesyncd.service ufw.service
sudo ufw enable

sudo reboot

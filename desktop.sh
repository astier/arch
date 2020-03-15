#!/usr/bin/env sh

# INTERNET
sudo cp ~/projects/dotfiles/dotfiles/iwd.conf /etc/iwd/main.conf
sudo systemctl enable --now iwd.service systemd-resolved.service
sudo ln -fs /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# PACKAGES
sudo pacman -S alsa-utils arc-gtk-theme dash fakeroot firefox fzf gcc light make man-db noto-fonts-cjk python-pynvim sx sxhkd tmux ttf-dejavu xorg-server xorg-xsetroot xsel yarn
git clone https://aur.archlinux.org/yay
cd yay && makepkg -is
yay -S dropbox

# PROJECTS
cd ~/projects || exit
git clone https://github.com/astier/dwm
git clone https://github.com/astier/st
cd dotfiles && sh setup.sh
cd ../dwm && sudo make install clean
cd ../scripts && sh setup.sh
cd ../st && sudo make install clean

# CONFIG
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall
chsh -s /bin/dash
sudo ln -sfT dash /usr/bin/sh
sudo systemctl enable fstrim.timer iptables.service systemd-timesyncd.service
sudo usermod -aG video "$USER" # fix broken light-package

# CLEAN
cd && rm -fr .bash_logout .cache/* yay
sudo pacman -Rns efibootmgr gendesk go
sudo pacman -Sc
sudo reboot

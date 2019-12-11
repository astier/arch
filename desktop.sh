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

# SUCKLESS
cd ~/projects || exit
git clone https://git.suckless.org/sites
git clone https://github.com/astier/dmenu
git clone https://github.com/astier/dwm
git clone https://github.com/astier/slock
git clone https://github.com/astier/st
cd dmenu && sudo make install clean
cd ../dwm && sudo make install clean
cd ../slock && sudo make install clean
cd ../st && sudo make install clean

# CONFIG
cd ../dotfiles && sh setup.sh
cd ../scripts && sh setup.sh
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
chsh -s /bin/dash
sudo ln -sfT dash /usr/bin/sh
sudo systemctl enable fstrim.timer iptables.service systemd-timesyncd.service
sudo usermod -aG video "$USER" # fix broken light-package

# CLEAN
cd && rm -fr .bash_logout .cache/* yay
sudo pacman -Rns efibootmgr gendesk go
sudo pacman -Sc

sudo reboot

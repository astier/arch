#!/usr/bin/env sh

# INTERNET
cd ~/repos || exit
sudo cp dotfiles/dotfiles/iwd.conf /etc/iwd/main.conf
sudo systemctl enable --now iwd.service systemd-resolved.service
sudo ln -fs /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# PROGRAMS
sudo pacman -S reflector
sudo reflector -p https -f32 -l16 --score 8 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -S alsa-utils arc-gtk-theme autorandr dash fakeroot firefox fzf gcc herbstluftwm hsetroot make man-db noto-fonts-cjk python-pynvim rclone sx sxhkd tmux ttf-dejavu xcompmgr xorg-server xorg-xset xsel
git clone https://aur.archlinux.org/yay-bin
git clone https://github.com/astier/st
cd scripts && sh setup.sh
cd ../st && sudo make install clean
cd ../yay-bin && makepkg -is
yay -S flat-remix lux xbanish

# CONFIG
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall
cd ../dotfiles && sh setup.sh
chsh -s /bin/dash
sudo ln -sfT dash /usr/bin/sh
sudo systemctl enable fstrim.timer iptables.service systemd-timesyncd.service
sudo usermod -aG video "$USER" # backlight

# CLEAN
cd && rm -fr .bash_logout .cache/* repos/yay-bin
sudo pacman -Rns efibootmgr
sudo pacman -Sc
sudo reboot

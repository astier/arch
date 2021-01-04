#!/usr/bin/env sh

# INTERNET
sudo cp ~/projects/dotfiles/iwd.conf /etc/iwd/main.conf
sudo systemctl enable --now iwd.service systemd-resolved.service
sudo ln -fs /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# PROGRAMS
sudo pacman -S \
    arc-gtk-theme \
    autorandr \
    dash \
    fakeroot \
    firefox \
    fzf \
    gcc \
    herbstluftwm \
    hsetroot \
    make \
    man-db \
    noto-fonts-cjk \
    picom \
    pulsemixer \
    rclone \
    sx \
    sxhkd \
    tmux \
    ttf-dejavu \
    xorg-server \
    xsel
git clone https://aur.archlinux.org/paru-bin
cd paru-bin && makepkg -is
paru flat-remix lux nerd-fonts-hack xbanish

# PROJECTS
cd ~/projects || return
git clone https://github.com/astier/st
cd dotfiles && sh setup.sh
cd ../scripts && sh setup.sh
cd ../st && make install clean

# CONFIG
chsh -s /bin/dash
sudo ln -sfT dash /usr/bin/sh
sudo usermod -aG video "$USER" # backlight
sudo nvim /usr/bin/sx # exec Xorg -ardelay 200 -arinterval 20
sudo systemctl enable fstrim.timer iptables.service systemd-timesyncd.service

# CLEAN
cd && rm -fr .bash_logout .cache/* paru-bin
sudo pacman -Rns efibootmgr
sudo pacman -Sc
sudo reboot

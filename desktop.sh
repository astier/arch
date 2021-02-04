#!/usr/bin/env sh

# INTERNET
doas cp ~/projects/dotfiles/iwd.conf /etc/iwd/main.conf
doas systemctl enable --now iwd.service systemd-resolved.service
doas ln -fs /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# PROGRAMS - REPO
doas pacman -S \
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
    noto-fonts-cjk \
    picom \
    pulsemixer \
    rclone \
    sx \
    sxhkd \
    tmux \
    ttf-dejavu \
    xsel

# PROGRAMS - AUR
git clone https://aur.archlinux.org/paru-bin
cd paru-bin && makepkg -is
paru flat-remix lux nerd-fonts-hack xbanish

# PROGRAMS - SRC
cd ~/projects || return
git clone https://github.com/astier/st
cd scripts && sh setup.sh
cd ../st && make install clean

# CONFIG
cd ../dotfiles && sh setup.sh
chsh -s /bin/dash
doas ln -sfT dash /usr/bin/sh
doas usermod -aG video "$USER" # backlight
doas nvim /usr/bin/sx # exec Xorg -ardelay 200 -arinterval 20
doas systemctl enable fstrim.timer iptables.service systemd-timesyncd.service

# CLEAN
cd && rm -fr .bash_logout .cache/* paru-bin
doas pacman -Rns efibootmgr
doas pacman -Sc
doas reboot

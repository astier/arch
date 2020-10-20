#!/usr/bin/env sh

# INTERNET
sudo cp ~/projects/dotfiles/dotfiles/iwd.conf /etc/iwd/main.conf
sudo systemctl enable --now iwd.service systemd-resolved.service
sudo ln -fs /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# PROGRAMS - OFFICIAL
sudo pacman -S \
    arc-gtk-theme
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
    pulsemixer \
    python-pynvim \
    rclone \
    sx \
    sxhkd \
    tmux \
    ttf-dejavu \
    xcompmgr \
    xorg-server \
    xsel \

# PROGRAMS - AUR
git clone https://aur.archlinux.org/yay-bin
cd ../yay-bin && makepkg -is
yay -S \
    flat-remix \
    lux \
    xbanish \

# PROGRAMS - CUSTOM
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
cd && rm -fr .bash_logout .cache/* yay-bin
sudo pacman -Rns efibootmgr
sudo pacman -Sc
sudo reboot

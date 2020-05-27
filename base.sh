#!/usr/bin/env sh

# establish internet-connection first
timedatectl set-ntp 1

# PARTITION
gdisk /dev/nvme0n1 # boot +2200 EF00, root
cryptsetup luksFormat /dev/nvme0n1p2 -d usb/key
cryptsetup open /dev/nvme0n1p2 root -d usb/key
mkfs.vfat -F16 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L ROOT /dev/mapper/root

# MOUNT
mount -L ROOT /mnt
mkdir /mnt/boot
mount -L BOOT /mnt/boot

# INSTALL
pacstrap /mnt base bash-completion efibootmgr git intel-ucode iwd linux linux-firmware neovim sudo
genfstab -L /mnt >> /mnt/etc/fstab
vi /mnt/etc/fstab # replace relatime with noatime,lazytime,commit=60

# CONFIGURE
arch-chroot /mnt
chattr +i /var/log/lastlog
setterm -cursor on > /etc/issue
echo hostname > /etc/hostname
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock -w
echo LANG=en_US.UTF-8 > /etc/locale.conf
vi /etc/locale.gen # uncomment en_US.UTF-8 UTF-8
locale-gen

# USER
EDITOR=nvim visudo
# %wheel ALL=(ALL) ALL
# Defaults passwd_timeout=0
useradd -mG wheel username
passwd username
passwd
passwd -l root

# MKINITCPIO
vi /etc/mkinitcpio.conf
# MODULES=(ext4 vfat)
# HOOKS=(base udev autodetect modconf block keyboard encrypt fsck)
mkinitcpio -p linux

# BOOT
mkdir /home/username/repos
cd /home/username/repos || exit
git clone https://github.com/astier/dotfiles
git clone https://github.com/astier/scripts
chown -R username /home/username/repos
sh scripts/efistub.sh

# REBOOT
exit
umount -R /mnt
reboot

#!/usr/bin/env sh

# establish internet-connection first
timedatectl set-ntp 1

# PARTITION
fdisk /dev/nvme0n1 # boot +2200 EF00, root
cryptsetup luksFormat /dev/nvme0n1p2 -d key
cryptsetup open /dev/nvme0n1p2 root -d key
mkfs.vfat -F16 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L ROOT /dev/mapper/root

# MOUNT
mount -L ROOT /mnt
mkdir /mnt/boot
mount -L BOOT /mnt/boot

# INSTALL
pacstrap /mnt base bash-completion efibootmgr git intel-ucode iwd linux linux-firmware man-db neovim opendoas
genfstab -L /mnt >> /mnt/etc/fstab
vi /mnt/etc/fstab # replace relatime with noatime + lazytime,commit=60 for ext4

# CONFIGURE
arch-chroot /mnt
ln -s /usr/bin/doas /usr/bin/sudo
chattr +i /var/log/lastlog
setterm -cursor on > /etc/issue
echo hostname > /etc/hostname
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock -w
echo LANG=en_US.UTF-8 > /etc/locale.conf
vi /etc/locale.gen # uncomment en_US.UTF-8 UTF-8
locale-gen

# USER
echo permit nopass :wheel > /etc/doas.conf
useradd -mG wheel username
passwd username
passwd
passwd -l root

# MKINITCPIO
vi /etc/mkinitcpio.conf
# MODULES=(i915)
# HOOKS=(base udev autodetect keyboard modconf block keyboard encrypt filesystems fsck)
mkinitcpio -p linux

# BOOT
mkdir /home/username/projects
cd /home/username/projects || exit
git clone https://github.com/astier/dotfiles
git clone https://github.com/astier/scripts
chown -R username /home/username/projects
sh scripts/efistub.sh

# REBOOT
exit
umount -R /mnt
reboot

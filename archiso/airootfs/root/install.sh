#!/bin/bash
echo installing in 5 seconds. press ctrl-c to abort
sleep 5 # give time to ctrl-c

ip link
timedatectl set-ntp true

# esp is highest sda num + 1, root + 2.
espnum=$(echo $(ls /dev | grep sda | tail -n 1 | tail -c 2) + 1 | bc)
rootnum=$(echo $espnum + 1 | bc)

echo $'n\n\n\n+512M\ny\nt\n\n1\nw\n' | fdisk /dev/sda # create ESP 
sleep 8 # wait to sync
echo $'n\n\n\n\ny\nw\n' | fdisk /dev/sda # create root

# make file systems
mkfs.fat -F 32 /dev/sda$espnum
echo y | mkfs.ext4 /dev/sda$rootnum # echo y: confirms request

# mount partitions
mount /dev/sda$rootnum /mnt
mkdir /mnt/boot
mount /dev/sda$espnum /mnt/boot

# failover: install base system
while true
do
	pacstrap /mnt base linux linux-firmware && break || sleep 15
done

# generate filesystem table
genfstab -U /mnt >> /mnt/etc/fstab

# set timezone and hwclock (but I am unsure if it actually sets the hwclock)
ln -sf /mnt/usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

# set locale
echo en_US.UTF-8 UTF-8 >> /mnt/etc/locale.gen
#vda should be a string with a locale (ex: de or de_CH)
echo $(cat /dev/vda | head -n 1).UTF-8 UTF-8 >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=$(cat /dev/vda | head -n 1).UTF-8 > /mnt/etc/locale.conf
echo KEYMAP=$(cat /dev/vda | head -n 1)-latin1 > /mnt/etc/vconsole.conf
#vdb should be a string with a hostname. Default: lorOS
cp /dev/vdb /mnt/etc/hostname

# install extended system; again, retry on fail
#vdc should be a string of packages to install seperated by spaces
while true
do
	pacstrap /mnt $(cat /dev/vdc) && break || sleep 15
done

# enable services
#vdd should be a string of services to enable  seperated by spaces
arch-chroot /mnt systemctl enable $(cat /dev/vdd)

# install bootloader
pacstrap /mnt grub efibootmgr
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory /boot --bootloader-id=lorOS
mkdir /mnt/boot/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

#vde should be postinstall script. execute it.
bash /dev/vde
umount -a
shutdown now
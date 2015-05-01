#emerge --sync
#emerge sys-kernel/gentoo-sources
#emerge sys-apps/pciutils

cd /usr/src/linux
make menuconfig
make && make modules_install
make install

#emerge sys-kernel/linux-firmware
#emerge sys-boot/grub

grub2-install $1
grub2-mkconfig -o /boot/grub/grub.cfg

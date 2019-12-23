#!/bin/bash

NEW_KERNEL="$(rpm -q --last kernel | head -1 | awk '{print $1}')"
NEW_INITRD="nondracut-initramfs-${NEW_KERNEL}.img"
NEW_TITLE="Fedora ${NEW_KERNEL} dracut FREE"

[ -f /etc/initrd.conf ] && readarray PACKAGES < /etc/initrd.conf

mkdir /root/initrd

dnf -y update
dnf install --setopt=install_weak_deps=False --installroot=/root/initrd/ --releasever=31 \
  systemd \
  passwd \
  fedora-release \
  vim-minimal \
  lvm2 \
  systemd-udev \
  kernel-modules \
  "${PACKAGES[@]}"

touch /root/initrd/etc/initrd-release
ln -s /lib/systemd/systemd /root/initrd/init
systemctl --root /root/initrd set-default initrd.target

cd /root/inirtd/ || exit 1
find . | cpio -o -c | gzip -9 > "/boot/${NEW_INITRD}"

# generate grup config
grubby --add-kernel="/boot/vmlinuz-${NEW_KERNEL}" --boot-filesystem="/boot/${NEW_INITRD}" --grup --title="${NEW_TITLE}"
# grubby --add-kernel="/boot/vmlinuz-5.2.18-100.fc29.x86_64" --initrd="/boot/initramfs-5.2.18-100.fc29.x86_64.img" --grub2 --title="New Initramfs"

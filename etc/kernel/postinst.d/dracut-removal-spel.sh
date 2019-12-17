#!/bin/bash

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
find . | cpio -o -c | gzip -9 > /boot/initrd.img # correct form is initramfs-{kernel-version]-{number}.{os-version}.{arch}

# generate grup config


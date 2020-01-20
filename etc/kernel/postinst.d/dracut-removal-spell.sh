#!/bin/bash

NEW_KERNEL="$1"
KERNEL_IMAGE="$2"
NEW_INITRD="nondracut-initramfs-${NEW_KERNEL}.img"
NEW_TITLE="Fedora ${NEW_KERNEL} dracut FREE"

[ -f /etc/initrd.conf ] && readarray PACKAGES < <(grep "^[^#]" /etc/initrd.conf)

INITRD_DIR=$(mktemp -d) # better would be /var/tmp

dnf -y -q update
dnf -y -q install --setopt=install_weak_deps=False --installroot="$INITRD_DIR" --releasever=31 \
  systemd \
  passwd \
  fedora-release \
  vim-minimal \
  lvm2 \
  systemd-udev \
  kernel-modules \
  "${PACKAGES[@]}"

touch "${INITRD_DIR}/etc/initrd-release"
ln -s /lib/systemd/systemd "${INITRD_DIR}/init"
systemctl -q --root "$INITRD_DIR" set-default initrd.target

cp /etc/{passwd,shadow} "${INITRD_DIR}/etc/"

cd "$INITRD_DIR" || exit 1
find . | cpio --quiet -o -c | gzip -q -9 > "/boot/${NEW_INITRD}"
cd && rm -rf "$INITRD_DIR"

# generate grup config
grubby --add-kernel="$KERNEL_IMAGE" --initrd="/boot/${NEW_INITRD}" --grub2 --title="${NEW_TITLE}"

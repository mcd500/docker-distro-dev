#!/bin/bash -xue

update-binfmts --enable qemu-arm64

mmdebstrap --architectures=arm64 --include=\
"debian-ports-archive-keyring,locales,wget,curl,openssh-client,openssh-server,sudo,file,libcurl4-gnutls-dev,libjansson-dev,rsync,ntpdate,usbutils,pciutils,net-tools" \
  focal /tmp/arm64-rootfs \
  "deb http://ports.ubuntu.com/ubuntu-ports/ focal main universe" \
  "deb http://ports.ubuntu.com/ubuntu-ports/ focal-updates main universe" \
  "deb http://ports.ubuntu.com/ubuntu-ports/ focal-security main universe"

chroot /tmp/arm64-rootfs /bin/bash <<-EOF
echo "root:optee" | chpasswd
EOF

echo "en_US.UTF-8 UTF-8" >> ${TARGET_DIR}/etc/locale.gen
chroot /tmp/arm64-rootfs /bin/bash -c 'locale-gen'

echo 'arm64-ubuntu' > /tmp/arm64-rootfs/etc/hostname

mkdir -p /tmp/arm64-rootfs/etc/network/interfaces.d

cat >/tmp/arm64-rootfs/etc/network/interfaces.d/eth0 <<_END
auto eth0
iface eth0 inet dhcp
_END

cat >/tmp/arm64-rootfs/etc/network/interfaces.d/enp1s0 <<_END
auto enp1s0
iface enp1s0 inet dhcp
_END

sed -i 's/^[#]\?Storage=auto$/Storage=volatile/' /tmp/arm64-rootfs/etc/systemd/journald.conf
sed -i 's/^[#]\?PermitRootLogin[ \t].*$/PermitRootLogin yes/' /tmp/arm64-rootfs/etc/ssh/sshd_config
echo 'unset HISTFILE 2>/dev/null' >>/tmp/arm64-rootfs/root/.bashrc
chroot /tmp/arm64-rootfs /bin/bash -c 'systemctl disable rsync.service'

chroot /tmp/arm64-rootfs /bin/bash -c 'for N in $(seq 5); do apt-get update && break; done'

cd /tmp/arm64-rootfs; tar -cJpf /mnt/arm64-20.04-rootfs.tar.xz --exclude="dev,proc,sys" .

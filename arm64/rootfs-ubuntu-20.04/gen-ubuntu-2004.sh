#!/bin/bash -xue

update-binfmts --enable qemu-aarch64

mmdebstrap --architectures=arm64 --include=\
"debian-ports-archive-keyring,locales,wget,curl,openssh-client,openssh-server,sudo,file,libcurl4-gnutls-dev,libjansson-dev,rsync,ntpdate,usbutils,pciutils,net-tools,vim" \
  focal /tmp/arm64-rootfs \
  "deb http://ports.ubuntu.com/ubuntu-ports/ focal main universe" \
  "deb http://ports.ubuntu.com/ubuntu-ports/ focal-updates main universe" \
  "deb http://ports.ubuntu.com/ubuntu-ports/ focal-security main universe"

cp `which qemu-aarch64-static` /tmp/arm64-rootfs/usr/bin/

chroot /tmp/arm64-rootfs /bin/bash <<_EOF
echo "root:optee" | chpasswd
_EOF

echo "en_US.UTF-8 UTF-8" >> /tmp/arm64-rootfs/etc/locale.gen
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

chroot /tmp/arm64-rootfs /bin/bash -c 'ldconfig /usr/lib && tee-supplicant &'

cd /tmp/arm64-rootfs; tar -cJpf /mnt/arm64-20.04-rootfs.tar.xz --exclude="dev,proc,sys" .

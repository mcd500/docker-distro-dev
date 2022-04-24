#!/bin/bash -xue

update-binfmts --enable qemu-riscv64

mmdebstrap --architectures=riscv64 --include=\
"debian-ports-archive-keyring,locales,wget,curl,openssh-client,openssh-server,sudo,file,libcurl4-gnutls-dev,libjansson-dev,rsync,ntpdate,usbutils,pciutils,net-tools" \
  sid /tmp/riscv64-rootfs "deb http://deb.debian.org/debian-ports/ sid main" \
  "deb http://deb.debian.org/debian-ports/ unreleased main"

chroot /tmp/riscv64-rootfs /bin/bash <<-EOF
echo "root:sifive" | chpasswd
EOF

echo 'riscv-debian' > /tmp/riscv64-rootfs/etc/hostname

cat >/tmp/riscv64-rootfs/etc/network/interfaces.d/eth0 <<_END
auto eth0
iface eth0 inet dhcp
_END

cat >/tmp/riscv64-rootfs/etc/network/interfaces.d/enp1s0 <<_END
auto enp1s0
iface enp1s0 inet dhcp
_END

sed -i 's/^[#]\?Storage=auto$/Storage=volatile/' /tmp/riscv64-rootfs/etc/systemd/journald.conf
sed -i 's/^[#]\?PermitRootLogin[ \t].*$/PermitRootLogin yes/' /tmp/riscv64-rootfs/etc/ssh/sshd_config
echo 'unset HISTFILE 2>/dev/null' >>/tmp/riscv64-rootfs/root/.bashrc
chroot /tmp/riscv64-rootfs /bin/bash -c 'systemctl disable rsync.service'

chroot /tmp/riscv64-rootfs /bin/bash -c 'for N in $(seq 5); do apt-get update && break; done'

cd /tmp/riscv64-rootfs; tar -czpf /mnt/sid-rootfs.tar.gz --exclude="dev,proc,sys" .

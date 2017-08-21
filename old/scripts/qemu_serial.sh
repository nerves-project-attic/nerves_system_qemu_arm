#!/bin/bash
IMAGE=$1

# change ownership of image as owned by root (from buildInDocker)
# better than run qemu as root
sudo chown $USER:users $IMAGE

qemu-system-x86_64 \
    -drive file=$IMAGE,format=raw \
    -net nic -net user \
    -redir tcp:2222::22 \
    -name nerves \
    -netdev user,id=eth0 \
    -device virtio-net-pci,netdev=eth0 \
    -netdev user,id=eth1 \
    -device virtio-net-pci,netdev=eth1 \
    -nographic \
    -device  isa-serial,iobase=0x3f8,index=0,irq=4,chardev=guest_ttyS0 \
    -chardev tty,id=guest_ttyS0,path=/dev/pts/3





# Response from:
# # dmesg | grep tty
#[    0.000000] Command line: BOOT_IMAGE=/bzImage root=/dev/sda2 rootfstype=ext4 rootwait console=tty1 console=ttyS0,115200
#[    0.000000] Kernel command line: BOOT_IMAGE=/bzImage root=/dev/sda2 rootfstype=ext4 rootwait console=tty1 console=ttyS0,115200
#[    0.000000] console [tty1] enabled
#[    0.000000] console [ttyS0] enabled
#[    2.497887] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
#[    2.526302] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
#[    2.554611] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
#[    2.582949] 00:06: ttyS3 at I/O 0x2e8 (irq = 10, base_baud = 115200) is a 16550A
#[    3.759121] tty tty14: hash matches

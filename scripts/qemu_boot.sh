#!/bin/bash
IMAGE=$1

# Determine the project root
SCRIPT=`readlink $0 || echo ''`
if [ -z "$SCRIPT" ]; then PROJECT_ROOT=`dirname $0`/../; else PROJECT_ROOT=`dirname $SCRIPT`/../; fi
PROJECT_ROOT=`readlink -f $PROJECT_ROOT`/

declare -a QEMU_ARGS

source $PROJECT_ROOT/scripts/setup-qemu-nat-network.sh

net_up

trap net_down EXIT

TAP1=tap_qemu1
TAP2=tap_qemu2

QEMU_ARGS+=("-netdev");  QEMU_ARGS+=("tap,ifname=$TAP1,script=no,downscript=no,id=guest_eth0")
QEMU_ARGS+=("-device");  QEMU_ARGS+=("virtio-net-pci,netdev=guest_eth0")

QEMU_ARGS+=("-netdev");  QEMU_ARGS+=("tap,ifname=$TAP2,script=no,downscript=no,id=guest_eth1")
QEMU_ARGS+=("-device");  QEMU_ARGS+=("virtio-net-pci,netdev=guest_eth1")


function close_bridge() {
    if [ "$USE_BRIDGE_HELPER_SCRIPT" == "true" ]; then
        echo "killing bridge"
        sudo brctl show
        sudo ip link set dev $BRDEV down
        sudo brctl delbr $BRDEV
    fi
}

# change ownership of image as owned by root (from buildInDocker)
# better than run qemu as root
sudo chown $USER:users $IMAGE

qemu-system-x86_64 \
    -m 2G \
    -drive file=$IMAGE,format=raw \
    -name nerves \
    "${QEMU_ARGS[@]}" \
    -nographic \
    -serial null \
    -serial mon:stdio


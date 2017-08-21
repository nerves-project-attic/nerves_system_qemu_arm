#!/bin/bash
case $OSTYPE in
  darwin*)
    ifconfig bridge1 deletem "$1"
    ;;
  linux-gnu*)
    # disable the tap interface
    sudo ip link set tap0 down
    # delete the tap interface. it gets removed from the bridge automatically
    sudo ip tuntap del dev tap0 mode tap
    ;;
esac

#!/bin/bash
case $OSTYPE in
  darwin*)
    ifconfig bridge1 addm "$1"
    ;;
  linux-gnu*)
    # create the tap interface
    sudo ip tuntap add dev tap0 mode tap user `whoami`
    # enable the tap interface
    sudo ip link set tap0 up
    # add tap interface to existing bridge
    sudo brctl addif bridge1 tap0
    ;;
esac

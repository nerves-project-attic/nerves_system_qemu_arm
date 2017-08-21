#!/bin/bash

## Notes:
##
##   Guest eth0,eth1 connected to Host:tap_nerves1,tap_nerves2 bridged to br_nerves
##
##   br_nerves - runs a dnsmasq - eth0 and eth1 will get their leases from this service, and the gateway will be set to the IP address of br_nerves.
##
##   For br_nerves to operate as a gateway, IP tables need to be added:
##
##   iptables was determined as per http://wiki.qemu.org/Documentation/Networking/NAT
##
##   NAT table
##
##     * Anything source being in subnet will be masquraded
# See https://wiki.archlinux.org/index.php/QEMU#Network_sharing_between_physical_device_and_a_Tap_device_through_iptables

function net_sysctl_up() {
    FILE=/etc/sysctl.d/nerves-qemu-sysctl.conf
    sudo tee $FILE > /dev/null <<EOF
net.ipv4.ip_forward = 1
EOF

    echo "Loading sysctl conf:"
    sudo sysctl -p /etc/sysctl.d/nerves-qemu-sysctl.conf
}

function net_sysctl_down() {
    echo "Hmm, I'll leave ipv4 port forwarding on for now"
}

function net_envs() {
    export NERVES_NET_IF_TAP1=tap_qemu1
    export NERVES_NET_IF_TAP2=tap_qemu2
    export NERVES_NET_IF_BR=br_nerves
    export NERVES_NET_USER=$USER
    export NERVES_NET_GROUP=`id -g -n $USER`
    export NERVES_NET_SUBNET=192.168.100.0
    export NERVES_NET_SUBNET_MASK=255.255.255.0

    export NERVES_NET_MASKBITS=24
    export NERVES_NET_ADDR_TAP1=192.168.100.90
    export NERVES_NET_ADDR_TAP2=192.168.100.91
    export NERVES_NET_ADDR_BR=192.168.100.253
}

# Create a named tap!
function net_taps_up() {
    net_envs
    echo "Create taps, adding them to the bridge, and configuring them and make them 'up'"
    sudo ip tuntap add name $NERVES_NET_IF_TAP1 mode tap user $NERVES_NET_USER group $NERVES_NET_GROUP
    sudo ip tuntap add name $NERVES_NET_IF_TAP2 mode tap user $NERVES_NET_USER group $NERVES_NET_GROUP
    # Set the IP address of the TAP itself.
    sudo brctl addif $NERVES_NET_IF_BR $NERVES_NET_IF_TAP1
    sudo brctl addif $NERVES_NET_IF_BR $NERVES_NET_IF_TAP2
    #sudo ip address add "$NERVES_NET_ADDR_TAP1"/"$NERVES_NET_MASKBITS" brd + dev "$NERVES_NET_IF_TAP1"
    sudo ip link set dev "$NERVES_NET_IF_TAP1" multicast on promisc on
    sudo ip link set dev "$NERVES_NET_IF_TAP2" multicast on promisc on
    sudo ip link set "$NERVES_NET_IF_TAP1" up
    sudo ip link set "$NERVES_NET_IF_TAP2" up
}


function net_taps_down() {
    net_envs
    echo "Removing taps interfaces from bridge and deleting them"
    sudo brctl delif $NERVES_NET_IF_BR $NERVES_NET_IF_TAP1
    sudo brctl delif $NERVES_NET_IF_BR $NERVES_NET_IF_TAP2

    sudo ip link delete $NERVES_NET_IF_TAP1
    sudo ip link delete $NERVES_NET_IF_TAP2
}

function net_iptables_up() {
    net_envs
    echo "Adding rules to iptables to allow NAT an packet transfer to / from bridge"
    # NAT TABLE:
    sudo iptables -t nat -A POSTROUTING -s $NERVES_NET_SUBNET/$NERVES_NET_SUBNET_MASK -j MASQUERADE

    # FILTER TABLE:
    # Accept everything on the bridge (for now)
    sudo iptables -t filter -A FORWARD -i $NERVES_NET_IF_BR -j ACCEPT
    sudo iptables -t filter -A FORWARD -o $NERVES_NET_IF_BR -j ACCEPT
}

function net_iptables_down() {
    net_envs
    echo "Removing rules from iptables to allow NAT an packet transfer to / from bridge"
    # NAT TABLE:
    sudo iptables -t nat -D POSTROUTING -s $NERVES_NET_SUBNET/$NERVES_NET_SUBNET_MASK -j MASQUERADE

    # FILTER TABLE:
    sudo iptables -t filter -D FORWARD -i $NERVES_NET_IF_BR -j ACCEPT
    sudo iptables -t filter -D FORWARD -o $NERVES_NET_IF_BR -j ACCEPT
}

# http://wiki.qemu.org/Documentation/Networking/NAT
function net_bridge_up() {
    net_envs
    echo "Starting up bridge, $NERVES_NET_IF_BR"
    sudo brctl addbr $NERVES_NET_IF_BR
    sudo ip address add "$NERVES_NET_ADDR_BR"/"$NERVES_NET_MASKBITS" brd + dev "$NERVES_NET_IF_BR"
    sudo ip link set "$NERVES_NET_IF_BR" up
    sudo ip link set dev "$NERVES_NET_IF_BR" multicast on promisc on

    sudo dnsmasq \
        --strict-order \
        --except-interface=lo \
        --interface=$NERVES_NET_IF_BR \
        --listen-address=$NERVES_NET_ADDR_BR \
        --bind-interfaces \
        --dhcp-range=192.168.100.20,192.168.100.40 \
        --conf-file="" \
        --pid-file=/run/nerves_dnsmasq.pid \
        --dhcp-leasefile=/tmp/qemu-dnsmasq-bridge.leases \
        --dhcp-no-override

}

function net_bridge_down() {
    net_envs
    echo "Shutting down bridge, $NERVES_NET_IF_BR"
    sudo kill -9 `cat /run/nerves_dnsmasq.pid`
    sudo ip link set "$NERVES_NET_IF_BR" down
    sudo brctl delbr $NERVES_NET_IF_BR
    #    echo "Bridges after shutting down"
    #sudo brctl show
}

# See https://wiki.archlinux.org/index.php/QEMU#Host-only_networking

# Adapted from https://wiki.archlinux.org/index.php/QEMU#Network_sharing_between_physical_device_and_a_Tap_device_through_iptables
function net_up() {
    net_sysctl_up
    net_bridge_up
    net_taps_up
    net_iptables_up
}
function net_down() {
    net_iptables_down
    net_taps_down
    net_bridge_down
    net_sysctl_down
}
# http://blog.elastocloud.org/2015/07/qemukvm-bridged-network-with-tap.html
# http://www.linux-kvm.org/page/Networking

# ARM Versatile image for QEMU
[![Build Status](https://travis-ci.org/nerves-project/nerves_system_qemu_arm.png?branch=master)](https://travis-ci.org/nerves-project/nerves_system_qemu_arm)

This is the base Nerves System configuration for [QEMU](http://wiki.qemu.org/Main_Page).

| Feature              | Description                     |
| -------------------- | ------------------------------- |
| CPU                  | Emulated single core ARM Cortex A9 |
| Memory               | Per QEMU commandline            |
| Storage              | N/A                             |
| Linux kernel         | 4.4.1                           |
| IEx terminal         | tty1                            |
| GPIO, I2C, SPI       | No                              |
| ADC                  | No                              |
| PWM                  | No                              |
| UART                 | No                              |
| Camera               | No                              |
| Ethernet             | Yes*                            |
| WiFi                 | No                              |
| Bluetooth            | No                              |

This is the start of a QEMU configuration. Help is needed to make Ethernet
work so that it's possible to `remsh` into the image. If you know how to
make QEMU do this on Linux and/or OS X please let us know!

## Booting

### Hello, Nerves!

Here follows a baseline example of how to run the Nerves [getting started
example](https://hexdocs.pm/nerves/getting-started.html) on QEMU:

    $ mix nerves.new hello_nerves --target qemu_arm

    $ cd hello_nerves && mix deps.get && mix firmware

    $ fwup -a -d _images/qemu_arm/hello_nerves.img -i _images/qemu_arm/hello_nerves.fw -t complete

    $ qemu-system-arm -M vexpress-a9 -smp 1 -m 256                         \
        -kernel _build/qemu_arm/dev/nerves/system/images/zImage            \
        -dtb _build/qemu_arm/dev/nerves/system/images/vexpress-v2p-ca9.dtb \
        -drive file=_images/qemu_arm/hello_nerves.img,if=sd,format=raw     \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2" -serial stdio \
        -net none

If all goes well, you will shortly see the QEMU graphical monitor console
pop up, displaying the Nerves logo in the top left corner and running an
interactive Elixir shell (IEx):

[![Screenshot](https://i.imgur.com/9JEMMGE.jpg)](http://imgur.com/9JEMMGE)

## Networking

To enable networking with Nerves on QEMU, you will need to do more elaborate
setup, and you will require superuser (i.e., root) privileges.

### Networking on OS X

**Note:** These instructions are up to date as of OS X El Capitan 10.11.6.
In the following, `en0` is assumed to be your primary physical OS X network
interface (Ethernet or Wi-Fi), and `bridge1` a virtual bridge interface that
we'll create for use with QEMU. In case those interface names don't work for
you, adjust all instructions accordingly. Similarly, the subnet
192.168.78.1/24 is an arbitrary choice for example purposes, change it as
you please.

*Kudos to [@salessandri](https://github.com/salessandri) for his guide to
[setting up a NAT network for QEMU on OS
X](https://blog.san-ss.com.ar/2016/04/setup-nat-network-for-qemu-macosx)
on which the following is based.*

#### 1. TunTap drivers

Install the [TunTap](http://tuntaposx.sourceforge.net/) kernel extensions
either manually from SourceForge or directly with [Homebrew](http://brew.sh/):

    $ sudo brew cask install tuntap

Note that `sudo` is required in the above, as these kernel extensions will
get installed into the system paths `/Library/Extensions/{tap,tun}.kext`.

Now load the `tun`/`tap` kernel extensions, and ensure that they will get
automatically loaded on startup when your machine is rebooted in the future:

    $ sudo launchctl load /Library/LaunchDaemons/net.sf.tuntaposx.tap.plist
    $ sudo launchctl load /Library/LaunchDaemons/net.sf.tuntaposx.tun.plist

#### 2. Bridge interface

Create and configure a virtual network bridge interface `bridge1` for QEMU,
connecting the bridge to your primary physical network interface `en0` and
configuring it to use its own /24 subnet:

    $ sudo ifconfig bridge1 create
    $ sudo ifconfig bridge1 addm en0
    $ sudo ifconfig bridge1 192.168.78.1/24   # 78 = ?N

#### 3. Packet forwarding and NAT

Configure your Mac such that packets arriving from the `bridge1` interface
are routed correctly, and enable NAT such that response packets find their
way back:

    $ sudo sysctl -w net.inet.ip.forwarding=1
    $ sudo pfctl -F all              # flush existing rules
    $ sudo pfctl -f qemu-pf.conf     # load NAT rules for bridge1

(Note that `pfctl -F all` also flushes any other rules, unrelated to QEMU.
If you know how to improve this, please contribute a README improvement.)

#### 4. DHCP configuration

**TODO**

### Hello, Network!

Now you're ready to proceed to building and booting up the Nerves
[hello_network](https://github.com/nerves-project/nerves-examples/tree/master/hello_network)
example:

    $ git clone https://github.com/nerves-project/nerves-examples.git

    $ cd nerves-examples/hello_network

    $ NERVES_TARGET=qemu_arm mix deps.get

    $ NERVES_TARGET=qemu_arm mix firmware

    $ fwup -a -d _images/qemu_arm/hello_network.img -i _images/qemu_arm/hello_network.fw -t complete

    $ sudo qemu-system-arm -M vexpress-a9 -smp 1 -m 256                    \
        -kernel _build/qemu_arm/dev/nerves/system/images/zImage            \
        -dtb _build/qemu_arm/dev/nerves/system/images/vexpress-v2p-ca9.dtb \
        -drive file=_images/qemu_arm/hello_network.img,if=sd,format=raw    \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2" -serial stdio \
        -net nic,model=lan9118                                             \
        -net tap,ifname=tap0,script=qemu-ifup.sh,downscript=qemu-ifdown.sh

Once booted up into the IEX console, you can verify that network connectivity and
DNS name resolution works by typing in:

    iex(1)> HelloNetwork.test_dns
    {:ok,
     {:hostent, 'nerves-project.org', [], :inet, 4,
      [{192, 30, 252, 154}, {192, 30, 252, 153}]}}

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add nerves_system_qemu_arm to your list of dependencies in `mix.exs`:

        def deps do
          [{:nerves_system_qemu_arm, "~> 0.4.0"}]
        end

  2. Ensure nerves_system_qemu_arm is started before your application:

        def application do
          [applications: [:nerves_system_qemu_arm]]
        end

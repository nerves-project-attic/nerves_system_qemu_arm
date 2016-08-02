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

## Usage

Here's an example of how to run the Nerves [getting started
example](https://hexdocs.pm/nerves/getting-started.html) on QEMU:

    $ mix nerves.new hello_nerves --target qemu_arm

    $ cd hello_nerves && mix deps.get && mix firmware

    $ fwup -a -d _images/qemu_arm/hello_nerves.img -i _images/qemu_arm/hello_nerves.fw -t complete

    $ qemu-system-arm -M vexpress-a9 -smp 1 -m 256                         \
        -kernel _build/qemu_arm/dev/nerves/system/images/zImage            \
        -dtb _build/qemu_arm/dev/nerves/system/images/vexpress-v2p-ca9.dtb \
        -drive file=_images/qemu_arm/hello_nerves.img,if=sd,format=raw     \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2"               \
        -serial stdio -net nic,model=lan9118 -net user

If all goes well, you will shortly see the QEMU graphical monitor console
pop up, displaying the Nerves logo in the top left corner and running an
interactive Elixir shell (IEx).

For network connectivity, try running the Nerves
[hello_network](https://github.com/nerves-project/nerves-examples/tree/master/hello_network)
example and configuring the QEMU command line `-net` directives for your
environment.

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

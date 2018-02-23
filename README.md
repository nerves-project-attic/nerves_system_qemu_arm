# Generic ARM Cortex A9 image for QEMU

[![CircleCI](https://circleci.com/gh/nerves-project/nerves_system_qemu_arm.svg?style=svg)](https://circleci.com/gh/nerves-project/nerves_system_qemu_arm)
[![Hex version](https://img.shields.io/hexpm/v/nerves_system_qemu_arm.svg "Hex version")](https://hex.pm/packages/nerves_system_qemu_arm)

This is the base Nerves System configuration for generic ARM platform emulated
by [QEMU](https://www.qemu.org/).

| Feature              | Description                     |
| -------------------- | ------------------------------- |
| CPU                  | Emulated single core ARM Cortex A9 |
| Memory               | Per QEMU commandline            |
| Storage              | N/A                             |
| Linux kernel         | 4.4.1                           |
| IEx terminal         | tty1 (the display)              |
| GPIO, I2C, SPI       | No                              |
| ADC                  | No                              |
| PWM                  | No                              |
| UART                 | No                              |
| Camera               | No                              |
| Ethernet             | Yes                             |
| WiFi                 | No                              |
| Bluetooth            | No                              |

Unlike other Nerves systems, this one does not contain a minimal configuration
since it is expected to be used exclusively for debugging on a fast computer.
Currently, it contains the following additional packages:

* The `qt-webkit-kiosk` fullscreen browser

As such, it takes a long time to build if you need to make custom modifications
to it. The goal is that rebuilds are uncommon. However, if you need to build
this system it needs more than 4 GB of DRAM. You may also consider stripping
down the configuration if qt-webkit-kiosk isn't needed.

## Getting Started

The `examples` directory contains simple Nerves projects that demonstrate
uses of `nerves_system_qemu_arm`. The `hello_nerves` example follows closely to
the baseline [Nerves getting started
example](https://hexdocs.pm/nerves/getting-started.html) with the additions of
networking and ssh firmware update support. Here's how to use it:

```bash
cd examples/hello_nerves
export MIX_TARGET=qemu_arm

# Check the config/config.exs file to make sure that the ssh authorized
# key logic works for you. The nerves_firmware_ssh project has more info.

# Build it
mix deps.get
mix firmware

# Create the base image file. This is like a virtual SDCard for the emulator.
# It just needs to be done once and then you can use over-the-air updates
mix firmware.image

# Generate a shell script to invoke qemu (only needs to be done once)
mix nerves.gen.qemu_script

# Start qemu
./run-qemu.sh

# It should open a window and boot to an iex prompt. Since it's the first
# boot and the application data partition hasn't been formatted, you should
# see some log messages about it being corrupt and then it being formatted.

# At this point, feel free to make an edit to the Elixir code. For example,
# have it IO.puts something.

# When you're ready, build, and run a firmware update.
mix firmware
mix firmware.push

# See the nerves_firmware_ssh project for troubleshooting firmware updates
# and using OpenSSH's ssh client.
```

## Starting a local web browser for use as a kiosk

The `hello_nerves` example also contains a trivial single page website to
demonstrate kiosk mode. To see it, start the example in QEMU and at the iex
prompt, run this:

```elixir
:os.cmd('qt-webkit-kiosk -platform linuxfb -c /etc/qt-webkit-kiosk.ini').
```

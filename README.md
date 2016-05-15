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
make QEMU do this on Linux and/or OSX please let us know!

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

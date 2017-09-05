# Changelog

## v0.12.3-dev

## v0.12.2

  * Bug fixes
    * Hex package was missing the nerves.gen.qemu_script helper

## v0.12.1

The documentation has been completely updated to reflect the new way of
launching qemu. The old documentation has been retained since it contains so
much useful information. It can be found in the `old` directory.

  * New features
    * Added the `mix nerves.gen.qemu_script` helper to create the starter shell
      script for running qemu

## v0.12.0

  * New features
    * The application data partition is now `ext4`. This greatly improves its
      robustness to corruption. Nerves.Runtime contains code to initialize it on
      first boot.
    * Firmware images now contain metadata that can be queried at runtime (see
      Nerves.Runtime.KV
    * Firmware updates verify that they're updating the right target. If the target
      doesn't say that it's an `qemu` through the firmware metadata, the update
      will fail.
    * Added meta-misc and meta-vcs-identifier to the `fwup.conf` metadata for use
      by users and for the regression test framework
    * Added qt-webkit-kiosk

  * Tool Dependencies
    * nerves_toolchain_arm_unknown_linux_gnueabihf 0.11.0
      https://github.com/nerves-project/toolchains/releases/tag/v0.11.0
    * fwup 0.15.4
    * nerves_system_br v0.13.5
      * Buildroot 2017.05
      * Erlang/OTP 20.0

## v0.11.0

  * New Features
    * Support for Nerves 0.5.0

## v0.10.0

  * New features
    * Bump toolchain to use gcc 5.3 (previously using gcc 4.9.3)

## v0.9.1

  * Bug Fixes
    * Loosen mistaken nerves dep on `0.4.0` to `~> 0.4.0`

## v0.9.0

This version switches to using the `nerves_package` compiler. This will
consolidate overall deps and compilers.

  * Nerves.System.BR v0.8.1
    * Support for distillery
    * Support for nerves_package compiler

## v0.7.0

When upgrading to this version, be sure to review the updates to
nerves_defconfig. BR2_PACKAGE_ERLANG is no longer selected automatically and
must be added.

  * nerves_system_br v0.7.0
    * Package updates
      * Buildroot 2016.08

    * Bug fixes
      * Many packages were removed. These include Elixir and LFE since neither are
        actually used. Both are added as part of the user build step, so no
        functionality is lost. The most visible result is that the system images
        are smaller and the test .fw file boots to the Erlang prompt.
      * Fix false positive from scrubber when checking executable formats due to
        C++ template instantiations. Ignores SYSV vs. GNU/Linux ABI difference.

## v0.6.1

  * Package versions
    * Nerves.System.BR v0.6.1

  * New features
    * Update docs/scripts on how to run qemu
    * Switch terminal output from video output to emulated serial port

## v0.6.0
  * Nerves.System.BR v0.6.0
    * Package updates
      * Erlang OTP 19
      * Elixir 1.3.1
      * fwup 0.8.0
      * erlinit 0.7.3
      * bborg-overlays (pull in I2C typo fix from upstream)
    * Bug fixes
      * Synchronize file system kernel configs across all platforms

## v0.5.1
  * Nerves.System.BR v0.5.1
    * Bug Fixes(nerves-env)
      * Added include paths to CFLAGS and CXXFLAGS
      * Pass sysroot to LDFLAGS

## v0.5.0
  * Nerves.System.BR v0.5.0
    * New features
      * WiFi drivers enabled by default on RPi2 and RPi3
      * Include wireless regulatory database in Linux kernel by default
        on WiFi-enabled platforms. Since kernel/rootfs are read-only and
        coupled together for firmware updates, the normal CRDA/udev approach
        isn't necessary.
      * Upgraded the default BeagleBone Black kernel from 3.8 to 4.4.9. The
        standard BBB device tree overlays are included by default even though the
        upstream kernel patches no longer include them.
      * Change all fwup configurations from two step upgrades to one step
        upgrades. If you used the base fwup.conf files to upgrade, you no
        longer need to finalize the upgrade. If not, there's no change.

## v0.4.1

  * Nerves.System.BR v0.4.1
    * Bug fixes
      * syslinux fails to boot when compiled on some gcc 5 systems
      * Fixed regression when booting off eMMC on the BBB

    * Package updates
      * Erlang 18.3
      * Elixir 1.2.5

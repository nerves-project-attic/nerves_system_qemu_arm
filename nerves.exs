use Mix.Config

version =
  Path.join(__DIR__, "VERSION")
  |> File.read!
  |> String.strip

pkg = :nerves_system_qemu_arm

config pkg, :nerves_env,
  type: :system,
  version: version,
  compiler: :nerves_package,
  artifact_url: [
    "https://github.com/nerves-project/#{pkg}/releases/download/v#{version}/#{pkg}-v#{version}.tar.gz",
  ],
  platform: Nerves.System.BR,
  platform_config: [
    defconfig: "nerves_defconfig",
  ],
  checksum: [
    "rootfs_overlay",
    "scripts",
    "nerves_defconfig",
    "qemu-dnsmasq.conf",
    "qemu-ifdown.sh",
    "qemu-ifup.sh",
    "qemu-pf.conf",
    "VERSION"
  ]

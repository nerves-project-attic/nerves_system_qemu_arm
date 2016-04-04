use Mix.Config

config :nerves_system_qemu_arm, :nerves_env,
  type: :system,
  build_platform: Nerves.System.Platforms.BR,
  bakeware: [target: "qemu_arm", recipe: "nerves/qemu_arm"],
  ext: [
    defconfig: "nerves_defconfig"
  ]

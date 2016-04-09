use Mix.Config

config :nerves_system_qemu_arm, :nerves_env,
  type: :system,
  bakeware: [target: "qemu_arm", recipe: "nerves/qemu_arm"],
  build_platform: Nerves.System.Platforms.BR,
  build_config: [
    defconfig: "nerves_defconfig"
  ]

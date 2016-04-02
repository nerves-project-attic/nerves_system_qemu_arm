use Mix.Config

config :nerves_system_qemu_arm, :nerves_env,
  type:  :system,
  build_platform: :nerves_system_br,
  bakeware: [target: "qemu_arm", recipe: "nerves/qemu_arm"],
  ext: [
    defconfig: "nerves_defconfig"
  ]

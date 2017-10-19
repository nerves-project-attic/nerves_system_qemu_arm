defmodule NervesSystemQemuArm.Mixfile do
  use Mix.Project

  @version Path.join(__DIR__, "VERSION")
    |> File.read!
    |> String.trim

  def project do
    [app: :nerves_system_qemu_arm,
     version: @version,
     elixir: "~> 1.4",
     compilers: Mix.compilers ++ [:nerves_package],
     description: description(),
     package: package(),
     deps: deps(),
     aliases: ["deps.precompile": ["nerves.env", "deps.precompile"]]]
  end

  def application do
   []
  end

  defp deps do
    [
      {:nerves, "~> 0.7", runtime: false },
      {:nerves_system_br, "~> 0.14.0", runtime: false },
      {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 0.11.0", runtime: false}
    ]
  end

  defp description do
    """
    Nerves System - QEMU Arm
    """
  end

  defp package do
    [maintainers: ["Frank Hunleth", "Justin Schneck"],
     files: ["LICENSE", "mix.exs", "nerves_defconfig", "nerves.exs",
             "README.md", "VERSION", "rootfs_overlay", "lib",
             "priv"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/nerves-project/nerves_system_qemu_arm"}]
  end
end

defmodule NervesSystemQemuArm.Mixfile do
  use Mix.Project

  @version Path.join(__DIR__, "VERSION")
    |> File.read!
    |> String.strip

  def project do
    [app: :nerves_system_qemu_arm,
    version: @version,
    elixir: "~> 1.2",
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
    [{:nerves, "~> 0.4"},
     {:nerves_system_br, "~> 0.9.2"},
     {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 0.10.0"}]
  end

  defp description do
    """
    Nerves System - QEMU Arm
    """
  end

  defp package do
    [maintainers: ["Frank Hunleth", "Justin Schneck"],
     files: ["LICENSE", "mix.exs", "nerves_defconfig", "nerves.exs", "README.md", "VERSION", "rootfs-additions"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/nerves-project/nerves_system_qemu_arm"}]
  end
end

defmodule Mix.Tasks.Nerves.Qemu.Run do
  use Mix.Task

  @shortdoc "Boot QEmu"

  @moduledoc """
  Boots qemu from the kernel identified in the Nerves System using the
  Nerves.Shell. Pass the ELIXIR_ERL_OPTIONS="+Bc" for the ability to send
  CTL-C to the tty instead of inturrupting the Erlang VM.

  This requires that the image is available by running

  `$ mix firmware.image ./path/to/my_app.img`

  This command requires the path to the firmware image as the first argument

  Example usage:

    `$ ELIXIR_ERL_OPTIONS="+Bc" mix nerves.qemu.run ./my_nerves_app.img`

  ## Options

  You can also specify additional arguments
    `--ram` - Defaults to 1024M
    `--kernel` - Defaults to $NERVES_SYSTEM/images/u-boot
    `--net` - Can be passed multiple times for each -net line
      Defaults to `["nic,model=lan9118","user,hostfw=tcp::9898-:9898"]`
  """

  @default_nets [
    "nic,model=lan9118",
    "user,hostfw=tcp::9898-:9898"]
  @default_ram "1024M"

  @switches [ram: :string, kernel: :string, net: :keep]

  def run(["--" <> _arg | _argv]) do
    error_image()
  end

  def run([image | argv]) do
    {opts, _, _} = OptionParser.parse(argv, switches: @switches)
    kernel = opts[:kernel] || kernel()
    ram = opts[:ram] || @default_ram
    image =
      (image || error_image())
      |> Path.expand
    nets =
      (opts || [])
      |> Keyword.get_values(:net)
      |> nets()
    initial_text = [
      "Starting QEmu"
    ]

    cmd = [
      "qemu-system-arm",
      "-M vexpress-a9",
      "-m #{ram}",
      "-kernel #{kernel}",
      "-drive file=#{image},if=sd,format=raw"
    | nets]
    cmd = Enum.join(cmd, " ")
    Mix.Nerves.Shell.open(cmd, initial_text)
  end

  def kernel do
    system_dir = System.get_env("NERVES_SYSTEM")
    Path.join(system_dir, "images/u-boot")
  end

  def image do
    Mix.Project.config[:images_path]
  end

  def nets([]) do
    nets(@default_nets)
  end

  def nets(nets) do
    Enum.map(nets, &format_net/1)
  end

  defp format_net(net), do: "-net #{net}"
  defp error_image do
    Mix.raise """
      You must specify an image. For example:
      $ ELIXIR_ERL_OPTIONS="+Bc" mix nerves.qemu.run ./path/to/app.img
    """
  end
end

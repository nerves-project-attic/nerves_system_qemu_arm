defmodule HelloNerves.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # worker(HelloNerves.Worker, [arg1, arg2, arg3]),
    ]

    # Setup networking
    Nerves.Network.setup "eth0", ipv4_address_method: :dhcp

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloNerves.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

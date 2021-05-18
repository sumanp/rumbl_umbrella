defmodule InfoSys.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: InfoSys.Worker.start_link(arg)
      # {InfoSys.Worker, arg}
      Supervisor.child_spec({InfoSys.Counter, 5}, restart: :permanent)
      # module you want to start and the value that will be received on start_link
      # by the GenServer. Alternatively, passing in only a module name uses a default
      # value of [].
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InfoSys.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

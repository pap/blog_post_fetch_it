defmodule FetchItWorkers do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # start aberth server
    number_acceptors = 100
    port = 10001
    handlers = [FetchItWorkers.RPC]
    {:ok, _pid} = :aberth.start_server(number_acceptors, port, handlers)



    children = [
      worker(FetchItWorkers.RedisPubSub, []),
      worker(FetchItWorkers.TwitterClient, [])
    ]

    opts = [strategy: :one_for_one, name: FetchItWorkers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

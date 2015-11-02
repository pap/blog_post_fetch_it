defmodule FetchItWorkers do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # start aberth server
    # RPC requests
    number_acceptors = 100
    port = 10001
    handlers = [FetchItWorkers.RPC]
    {:ok, _pid} = :aberth.start_server(number_acceptors, port, handlers)

    # Redis client init
    {:ok, redis_client} = Redix.start_link

    children = [
      worker(FetchItWorkers.RedisPubSub, []),
      worker(FetchItWorkers.TwitterClient, []),
      worker(FetchItWorkers.RedisPoller, [redis_client]),
      supervisor(FetchItWorkers.SidekiqSupervisor, [redis_client])
    ]

    opts = [strategy: :one_for_one, name: FetchItWorkers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

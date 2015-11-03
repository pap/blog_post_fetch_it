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

    # TODO: add poolboy "controled" TwitterClient
    children = [
      worker(FetchItWorkers.RedisPubSub, []),
      worker(FetchItWorkers.TwitterClient, []),
      worker(FetchItWorkers.RedisPoller, [redis_client]),
      :poolboy.child_spec(:sidekiq_pool, sidekiq_pool_opts, [])
    ]

    opts = [strategy: :one_for_one, name: FetchItWorkers.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp sidekiq_pool_opts do
    [
      name: {:local, :sidekiq_pool},
      worker_module: FetchItWorkers.Sidekiq,
      size: 5,
      max_overflow: 10
    ]
  end
end

defmodule FetchItWorkers do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(FetchItWorkers.RedisPubSubWorker, []),
      worker(FetchItWorkers.RedisStoreWorker, []),
      worker(FetchItWorkers.TwitterWorker, [])
    ]

    opts = [strategy: :one_for_one, name: FetchItWorkers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

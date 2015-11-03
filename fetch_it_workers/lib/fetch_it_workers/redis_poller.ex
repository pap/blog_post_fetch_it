defmodule FetchItWorkers.RedisPoller do
  use GenServer

  def start_link(redis_client) do
    GenServer.start_link(__MODULE__, [redis_client], [])
  end

  def poll(redis_client) do
    job = Redix.command!(redis_client, ~w(RPOP queue:elixir))
    new_job(job, redis_client)

    :timer.sleep(100)
    poll(redis_client)
  end

  def new_job(nil, redis_client) do
    # No job to process ...
  end

  def new_job(job, redis_client) do
    :poolboy.transaction(
      :sidekiq_pool,
      fn(pid) -> GenServer.call(pid, {:run, job, redis_client}) end,
      :infinity
    )
  end

  def init([redis_client]) do
    # timeout to start polling
    {:ok, redis_client, 0}
  end

  def handle_info(:timeout, redis_client) do
    poll(redis_client)
  end
end

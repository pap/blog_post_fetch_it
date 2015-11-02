defmodule FetchItWorkers.RedisPoller do
  use GenServer

  def start_link(redis_client) do
    GenServer.start_link(__MODULE__, [redis_client], [])
  end

  def poll(redis_client) do
    Redix.command!(redis_client, ~w(RPOP queue:elixir))
    |> FetchItWorkers.SidekiqSupervisor.new_job

    :timer.sleep(100)
    poll(redis_client)
  end

  def init([redis_client]) do
    # timeout to start polling
    {:ok, redis_client, 10}
  end

  def handle_info(:timeout, redis_client) do
    poll(redis_client)
  end
end

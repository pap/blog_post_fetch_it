defmodule FetchItWorkers.RedisPubSubWorker do
  use GenServer

  @redis_sub_channel "workers"

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    # returning a quick timeout will allow the subscribe to happen on ...
    {:ok, %{pub_sub_con: nil}, 50}
  end

  def handle_info(:timeout, _state) do
    # timeout on init on purpose to defer the redis queue subscribe to here
    {:ok, pub_sub_conn} = Redix.PubSub.start_link
    :ok = Redix.PubSub.subscribe(pub_sub_conn, @redis_sub_channel, self())

    {:noreply, %{pub_sub_conn: pub_sub_conn}}
  end

  def handle_info({:redix_pubsub, :subscribe, channel, _}, state) do
    IO.puts "Worker subscribed to #{channel} channel ..."
    {:noreply, state}
  end

  def handle_info({:redix_pubsub, :message, message, _channel}, state) do
    IO.puts("Received a message ...")
    message |> inspect |> IO.puts
    # TODO: fetch tweets ...
    # save tweets ... possibly on redis
    {:noreply, state}
  end
end

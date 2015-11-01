defmodule FetchItWorkers.RedisPubSub do
  use GenServer

  @redis_sub_channel "workers"

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :redis_pub_sub)
  end

  def init(_args) do
    # returning a quick timeout will allow the subscribe to happen on
    {:ok, %{pub_sub_con: nil}, 10}
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
    {:ok, decoded} = Poison.decode(message)

    # TODO: import funs to make these calls "smaller"
    tweets = FetchItWorkers.TwitterClient.fetch_tweets(:twitter_worker, decoded["search_string"], decoded["number_of_tweets"])
    # TODO: store on file with uuid as file name
    # (...)
    {:noreply, state}
  end
end

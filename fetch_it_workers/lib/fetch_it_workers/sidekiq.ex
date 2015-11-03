defmodule FetchItWorkers.Sidekiq do
  use GenServer

  def start_link(_args) do
    :random.seed(:os.timestamp)
    GenServer.start_link(__MODULE__, [], [])
  end

  def run(pid, job, redis_client) do
    GenServer.call(pid, {:run, job, redis_client})
  end

  def handle_call({:run, job, redis_client}, _from, state) do

    {:ok, job} = Poison.decode(job)
    jid = job["jid"]
    args = Enum.into(job["args"] |> hd, %{})
    queue = "queue:default"
    class = "TwitterWorker"
    enqueued_at = job["enqueued_at"]

    IO.puts "Handling Sidekiq Job (#{jid})"

    tweets = FetchItWorkers.TwitterClient.fetch_tweets(:twitter_worker, args["search_string"], args["number_of_tweets"])
    FetchItWorkers.Filestore.store_tweets(args["uuid"], tweets)

    new_job = %{
      queue: queue,
      jid: jid,
      class: class,
      args: [jid, args["uuid"], args["search_string"], args["number_of_tweets"]],
      enqueued_at: enqueued_at
    } |> Poison.Encoder.encode([])

    Redix.command(redis_client, ~w(LPUSH #{queue} #{new_job}))

    {:reply, :ok, state}
  end
end

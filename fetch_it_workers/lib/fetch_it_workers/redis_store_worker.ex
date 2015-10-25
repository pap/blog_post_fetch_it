defmodule FetchItWorkers.RedisStoreWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # TODO: create store funs
  # store(bucket, key, value)
  # fetch(bucket, key) this one more for fun ... not actually needed
end

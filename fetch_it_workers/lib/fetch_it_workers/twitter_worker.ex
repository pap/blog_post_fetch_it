defmodule FetchItWorkers.TwitterWorker do
  use GenServer

  @number_of_tweets 20

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :twitter_worker)
  end

  def fetch_tweets(pid, :latest) do
    GenServer.call(pid, {:all, @number_of_tweets })
  end

  def fetch_tweets(pid, search_string) iwhen is_binary search_string do
    GenServer.call(pid, {:search, search_string})
  end

  def handle_call({:search, search_string}, _from, _state) do
    {:reply, _insert_return_here, _state}
  end

  def handle_call({:all, @number_of_tweets}, _from, _state) do
    {:reply, _insert_return_here, _state}
  end
end

defmodule FetchItWorkers.TwitterWorker do
  use GenServer

  @number_of_tweets 20

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :twitter_worker)
  end

  def fetch_tweets(pid, search_string, number_of_tweets \\ @number_of_tweets) do
    GenServer.call(pid, {:search, search_string, number_of_tweets})
  end

  def handle_call({:search, search_string, number_of_tweets}, _from, state) do
    response = ExTwitter.search(search_string, [count: number_of_tweets])
    |> Enum.map(&map_tweet/1)
    |> Enum.map(&json_encode/1)

    # TODO: remove dbg code
    response |> inspect |> IO.puts

    {:reply, response, state}
  end

  defp map_tweet(tweet) do
    case tweet.entities.urls do
      [_ | _] ->
        [%{expanded_url: url}| _] = tweet.entities.urls
        url
      _ -> nil
    end

    %{name: name, screen_name: screen_name} = tweet.user

    %{
      tweet: %{id: tweet.id_str, text: tweet.text, created_at: tweet.created_at, url: url},
      user: %{name: name, screen_name: screen_name}
    }
  end

  defp json_encode(tweet) do
    Poison.Encoder.encode(tweet, [])
  end
end

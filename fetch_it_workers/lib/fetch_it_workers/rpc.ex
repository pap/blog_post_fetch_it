defmodule FetchItWorkers.RPC do
  def fetch_tweets(message) when is_list message do
    [search_string, number_of_tweets] = message

    FetchItWorkers.TwitterClient.fetch_tweets(:twitter_worker, search_string, number_of_tweets)
    |> Enum.map(&(List.to_string(&1)))
    |> MessagePack.pack!
  end
end

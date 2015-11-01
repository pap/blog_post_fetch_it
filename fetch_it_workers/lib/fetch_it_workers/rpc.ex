defmodule FetchItWorkers.RPC do

  def fetch_tweets(message) when is_list message do
    message |> inspect |> IO.puts
    [search_string, number_of_tweets] = message
    tweets = FetchItWorkers.TwitterClient.fetch_tweets(:twitter_worker, search_string, number_of_tweets)
    tweets |> Enum.map(&(List.to_string(&1))) |> MessagePack.pack!
  end
end

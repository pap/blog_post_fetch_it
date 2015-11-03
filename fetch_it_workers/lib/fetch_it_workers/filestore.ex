defmodule FetchItWorkers.Filestore do

  def store_tweets(uuid, tweets) do
    {:ok, file} = File.open("../tweet_store/#{uuid}", [:write, :utf8])
    IO.write(file, Enum.map(tweets, &("#{&1}\n")))
    File.close(file)
  end
end

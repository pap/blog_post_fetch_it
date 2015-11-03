require 'sinatra'

require_relative 'config'

get "/" do
  "FetchIt! API"
end

get '/sidekiq' do
  stats = Sidekiq::Stats.new
  @failed = stats.failed
  @processed = stats.processed
  @messages = $redis.lrange('queue:default', 0, -1)
  erb :index
end

namespace "/api" do
  namespace "/v1" do

    post "/pubsub/twitter" do
      params = JSON.parse(request.body.read)
      data = Request.new.data(params)
      $redis.publish("workers", data.to_json)

      json data
    end

    post "/background_job/twitter" do
      params = JSON.parse(request.body.read)
      data = Request.new.data(params)
      TwitterWorker.perform_async(data)
      json data
    end

    post "/rpc/twitter" do
      params = JSON.parse(request.body.read)
      search_string = params["search"]
      number_of_tweets = params["number"]

      service = BERTRPC::Service.new('localhost', 10001)
      #:'Elixir.FetchItWorkers.RPC'
      response = service.call.send(:'Elixir.FetchItWorkers.RPC').fetch_tweets([search_string, number_of_tweets])
      tweets = MessagePack.unpack(response)

      json tweets.map { |t| JSON.parse(t) }
    end

    get "/tweets/:uuid" do
      tweets = []
      file = File.new("../tweet_store/#{params[:uuid]}", "r")

      file.each_line do |line|
        tweets << line
      end
      file.close

      json tweets.map { |t| JSON.parse(t) }
    end
  end
end

__END__

@@ layout
<html>
<head>
<title>FetchIt!</title>
<body>
<%= yield %>
</body>
</html>

@@ index
<h1>Sidekiq Status</h1>
<h2>Failed: <%= @failed %></h2>
<h2>Processed: <%= @processed %></h2>

<a href="/sidekiq">Refresh page</a>

<h3>Messages</h3>
<% @messages.each do |msg| %>
<p><%= msg %></p>
<% end %>

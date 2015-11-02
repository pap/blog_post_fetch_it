require 'sinatra'
require 'sidekiq'
require 'bertrpc'
require 'msgpack'

require_relative 'config'

# TODO: remove to their own files
class Request
  def data(params)
    {
      "uuid" => SecureRandom.uuid,
      "search_string" => params["search"],
      "number_of_tweets" => params["number"],
      "requested_at" => Time.now
    }
  end
end

class TwitterWorker
  include Sidekiq::Worker

  def self.perform_async(*payload)
      queue = "queue:elixir"
      json = {
        queue: queue,
        class: "TwitterWorker",
        args: payload,
        jid: SecureRandom.hex(12),
        enqueued_at: Time.now.to_f
      }.to_json
      client = Sidekiq.redis { |conn| conn }
      client.lpush(queue, json)
  end

  # it will get the results processed by elixir
  def perform(*payload)
  end

end

get "/" do
  "FetchIt! API"
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

    get "/twitter/:uuid" do
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

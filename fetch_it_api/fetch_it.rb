require "sinatra"

require_relative 'config'

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
      # TODO: add sidekiq ...
      json data
    end

    post "/rpcerlang/twitter" do
      # TODO: use rpcerlang
      params = JSON.parse(request.body.read)
      data = Request.new.data(params)

      # TODO: rpc call
      # wait for the response
      json data
    end

    get "/twitter/:uuid" do
      # No redis save .. use sqlite and a webhook to receive from the worker
      tweets = $redis.get(params[:uuid])
      # TODO: cleanup
      puts tweets
      #json JSON.parse(tweets)
      json tweets
    end
  end
end

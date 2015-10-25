require "sinatra"

require_relative 'config'

get "/" do
  "FetchIt! API"
end

namespace "/api" do
  namespace "/v1" do
    post "/twitter" do
      params = JSON.parse(request.body.read)

      data = {
        "uuid" => SecureRandom.uuid,
        "search_string" => params["search"],
        "number_of_tweets" => params["number"],
        "requested_at" => Time.now
      }

      $redis.publish("workers", data.to_json)

      json data
    end

    get "/twitter/:uuid" do
      # TODO: read json ... hash commands?
      tweets = $redis.get(params[:uuid])
      json JSON.parse(tweets)
    end
  end
end

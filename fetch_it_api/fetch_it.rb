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

    get "/twitter" do
      puts "GET twitter"
      # Get the tweets saved with uuid
      # store them as a file for now ;)
    end
  end
end

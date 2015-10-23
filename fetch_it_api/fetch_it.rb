require "sinatra"

require_relative 'config'

get "/" do
  "FetchIt! API"
end

namespace "/api" do
  namespace "/v1" do
    post "/twitter" do
      puts "POST twitter"
      # Enqueue the fetch tweets worker with number and search term
      # respond with uuid
    end

    get "/twitter" do
      puts "GET twitter"
      # Get the tweets saved with uuid
      # store them as a file for now ;)
    end
  end
end

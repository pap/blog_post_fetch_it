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

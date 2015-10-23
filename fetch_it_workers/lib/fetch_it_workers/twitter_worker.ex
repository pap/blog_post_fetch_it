defmodule FetchItWorkers.TwitterWorker do
  use GenServer

  @number_of_tweets 20

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :twitter_worker)
  end

  def fetch_tweets(pid, search_string, number_of_tweets \\ @number_of_tweets) do
    GenServer.call(pid, {:search, search_string, number_of_tweets})
  end

  def handle_call({:search, search_string, number_of_tweets}, _from, state) do
    response = ExTwitter.search(search_string, [count: number_of_tweets])
    |> Enum.map(&map_tweet/1)

    {:reply, response, state}
  end

  defp map_tweet(tweet) do
    case tweet.entities.urls do
      [h | t] ->
        [%{expanded_url: url}| _] = tweet.entities.urls
        url
      _ -> nil
    end

    %{id: tweet.id_str, text: tweet.text, created_at: tweet.created_at, url: url}
  end
end

# temp = FetchItWorkers.TwitterWorker.fetch_tweets(:twitter_worker, "apple", 30)

# %ExTwitter.Model.Tweet{contributors: nil, coordinates: nil, created_at: "Fri Oct 23 16:54:27 +0000 2015", entities: %{hashtags: [], media: [%{display_url: "pic.twitter.com/4cs6tborZ8", expanded_url: "http://twitter.com/HiOrHeyRecords/status/657600424090931200/photo/1", id: 657600393803878400, id_str: "657600393803878400", indices: 'd{', media_url: "http://pbs.twimg.com/media/CSBEEvTWUAAkPOt.jpg", media_url_https: "https://pbs.twimg.com/media/CSBEEvTWUAAkPOt.jpg", sizes: %{large: %{h: 630, resize: "fit", w: 640}, medium: %{h: 590, resize: "fit", w: 600}, small: %{h: 334, resize: "fit", w: 340}, thumb: %{h: 150, resize: "crop", w: 150}}, source_status_id: 657600424090931200, source_status_id_str: "657600424090931200", source_user_id: 2305473636, source_user_id_str: "2305473636", type: "photo", url: "https://t.co/4cs6tborZ8"}], symbols: [], urls: [%{display_url: "5sosf.am/vjnufZ", expanded_url: "http://5sosf.am/vjnufZ", indices: 'Lc', url: "https://t.co/Y9uRCjecWD"}], user_mentions: [%{id: 2305473636, id_str: "2305473636", indices: [3, 18], name: "HI OR HEY RECORDS", screen_name: "HiOrHeyRecords"}, %{id: 264107729, id_str: "264107729", indices: 'FK', name: "5 Seconds of Summer", screen_name: "5SOS"}]}, favorite_count: 0, favorited: false, geo: nil, id: 657600986974810112, id_str: "657600986974810112", in_reply_to_screen_name: nil, in_reply_to_status_id: nil, in_reply_to_status_id_str: nil, in_reply_to_user_id: nil, in_reply_to_user_id_str: nil, lang: "en", place: nil, retweet_count: 826, retweeted: false, source: "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>", text: "RT @HiOrHeyRecords: SOUNDS GOOD FEELS GOOD is finally here! Loving it @5SOS https://t.co/Y9uRCjecWD https://t.co/4cs6tborZ8", truncated: false, user: %ExTwitter.Model.User{default_profile_image: false, screen_name: "musicismyout", friends_count: 1346, default_profile: false, verified: false, is_translation_enabled: false, utc_offset: nil, listed_count: 3, follow_request_sent: false, profile_link_color: "3B94D9", profile_background_color: "000000", profile_background_image_url: "http://abs.twimg.com/images/themes/theme1/bg.png", favourites_count: 1151, id_str: "2879045333", followers_count: 974, description: "If you don't like bands, you're doing something wrong. ATL, FOB, 5SOS, Green Day, SWS, Blink-182, MCR, 1D", location: "", name: "lina ❤️s bands", is_translator: false, profile_use_background_image: false, profile_sidebar_fill_color: "000000", created_at: "Sun Nov 16 03:31:54 +0000 2014", statuses_count: 11455, profile_sidebar_border_color: "000000", time_zone: nil, geo_enabled: false, profile_text_color: "000000", id: 2879045333, url: nil, ...}}

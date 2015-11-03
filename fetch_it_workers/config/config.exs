use Mix.Config

config :poolboy,
  pools: [
    sidekiq: [
      name: {:local, :sidekiq_pool},
      worker_module: FetchItWorkers.Sidekiq,
      size: 5,
      max_overflow: 10
    ]
  ]

import_config "secrets.exs"
# secrets.exs is excluded from version control
# It contains the Twitter credentials ...

#  config :extwitter, :oauth, [
#    consumer_key: "INSERT YOURS",
#    consumer_secret: "INSERT YOURS",
#    access_token: "INSERT YOURS",
#    access_token_secret: "INSERT YOURS"
#  ]

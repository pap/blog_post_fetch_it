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
    puts "Received: #{payload}"
  end
end

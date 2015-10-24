require 'redis'
require 'sinatra/namespace'
require 'json'
require 'sinatra/json'

configure do
  $redis = Redis.new
end


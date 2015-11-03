require 'redis'
require 'sinatra/namespace'
require 'json'
require 'sinatra/json'
require 'sinatra'
require 'sidekiq'
require 'sidekiq/api'
require 'bertrpc'
require 'msgpack'
require 'tilt/erb'

Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb'), &method(:require))

configure do
  $redis = Redis.new
end


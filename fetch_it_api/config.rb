require 'redis'
require 'sinatra/namespace'
require 'json'
require 'sinatra/json'

configure do
  $redis = Redis.new
end

Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb'), &method(:require))

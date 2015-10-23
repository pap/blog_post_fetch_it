require 'redis'
require 'resque'
require 'sinatra/namespace'
require 'sinatra/json'

Resque.redis =  "redis:6379"


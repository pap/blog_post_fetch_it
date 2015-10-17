#\ -p 8888

require 'bundler/setup'
require 'praxis'

application = Praxis::Application.instance
application.logger = Logger.new(STDOUT)
application.setup

run application

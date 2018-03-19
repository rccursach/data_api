# Start Redis on it's default port (or specify in your ENV)
# 
# Usage:
# ruby redis_pubsub_demo.rb
#

require 'eventmachine'
require 'em-websocket'
require 'yajl'
require_relative 'src/evented_redis'
require_relative 'src/ws_controller'

host = ENV['WS_HOST'] || '0.0.0.0'
port = ENV['PORT'] || 8082
# Let's go:  Fire up a ws server on port 8082
EventMachine.run {
  EventMachine.start_server(host, port, WSController, {:debug => true})
  puts "listening on ws://#{host}:#{port}/websocket"
}

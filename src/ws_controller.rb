class WSController < EventMachine::WebSocket::Connection
  
  # Overrides
  def trigger_on_message(msg)
      received_data msg
  end
  
  def trigger_on_open(handshake)
     create_redis
  end
  def trigger_on_close(event = {})
    handle_leave
    destroy_redis
  end
  # end Overrides
  
  def create_redis
    @pub = EventedRedis.connect
    @sub = EventedRedis.connect
  end
  
  def destroy_redis
    @pub.close_connection_after_writing
    @sub.close_connection_after_writing
  end
  
  def received_data(data)
    msg = parse_json(data)
    case msg[:action]
    when 'join'
      handle_join(msg)
    when 'message'
      handle_message(msg)
    else
      # skip
    end
  end
  
  def handle_join(msg)
    subscribe
  end
  
  def handle_leave
    publish :action => 'control', :message => 'disconected'
  end
  
  def handle_message(msg)
    publish msg
  end
  
  private
  def subscribe
    @sub.subscribe('data') do |type,channel,message|
      debug [:redis_type, type]
      debug [:redis_channel, channel]
      debug [:redis_message, message]
      
      if type ==  "message"
        send message
      end
      
    end
  end
  
  def publish(message)
    @pub.publish('data', encode_json(message))
  end
  
  def encode_json(obj)
    Yajl::Encoder.encode(obj)
  end
  
  def parse_json(str)
    Yajl::Parser.parse(str, :symbolize_keys => true)
  end
end

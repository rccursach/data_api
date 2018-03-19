require 'sinatra/base'

class StaticController < Sinatra::Base
  enable :inline_templates
  get('/') { erb :main }
end


dispatch = Rack::Builder.app do
  map '/' do
    run StaticController.new
  end
end

Rack::Server.start({
  app:    dispatch,
  server: 'thin',
  Host:   '0.0.0.0',
  Port:   '3001',
  signals: false,
})

#  Web Page Template below
__END__
@@ main
<html>
<head>
</head>
<body>
  <div id="msgs">
  </div>
  <div id="channel" class="bordered">
    <div id="input">
      <form><input type="text" id="message"/></form>
    </div>
  </div>

  <script>
  var host = window.location.host.split(':')[0];
  var ws = new WebSocket("ws://" + host + ":8082/websocket");

  ws.onmessage = function(evt) {
    var doc = document;
    // var obj = eval('(' + evt.data + ')');
    var obj = evt.data;
    
    d = doc.createElement('div')
    d.appendChild(doc.createTextNode(obj))
    doc.querySelector("#msgs").appendChild(d);
  }

  document.querySelector('#channel form')
  .addEventListener('submit', function(event){
    event.preventDefault();
    var input = document.querySelector('#channel form input')
    var msg = input.value;
    ws.send(JSON.stringify({ action: 'message', message: msg }));
    input.value = '';
  })

  // send name when joining
  ws.onopen = function() {
    ws.send(JSON.stringify({ action: 'join' }));
  }
  </script>
</body>
</html>
<!--
<!DOCTYPE html>
<html>
<head>
  <title>Socket</title>
  <style type="text/css">
    #msgs {
      font-family: courrier;
    }
  </style>
</head>
<body>
  <p>
    Listening on ws://<span id="host"></span>:8082/websocket
  </p>
  <div id="msgs">
    
  </div>
  <script type="text/javascript">
  var host = window.location.host.split(':')[0];
  var ws = new WebSocket("ws://" + host + ":8082/websocket");

  document.querySelector('#host').appendChild(document.createTextNode(host))

  ws.onmessage = function(evt) {
    var doc = document;
    var obj = evt.data;
    d = doc.createElement('div')
    d.appendChild(doc.createTextNode(obj))
    doc.querySelector("#msgs").appendChild(d);
  }
  // send name when joining
  ws.onopen = function() {
    ws.send(JSON.stringify({ action: 'join' }));
  }
  </script>
</body>
</html>
-->
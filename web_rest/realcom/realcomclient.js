const WebSocket = require('ws');
 
const ws = new WebSocket('ws://localhost:5857');
 
ws.on('open', function open() {
  ws.send('client data');
});
 
ws.on('message', function incoming(data) {
  console.log(data);
});
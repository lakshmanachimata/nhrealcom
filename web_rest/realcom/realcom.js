const express = require('express');
const http = require('http');
const url = require('url');
const WebSocket = require('ws');

var ws1 = undefined;
var ws2 = undefined;

var connections = new Map();
const app = express();

app.use(function (req, res) {
    res.send({ msg: "hello" });
});

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });


wss.on('connection', function connection(ws, req) {
    const location = url.parse(req.url, true);
    connections.set( ws._socket.remoteAddress,ws)
    if (ws1 == undefined) {
        console.log("setting ws1")
        ws1 = ws
    } else if (ws2 == undefined) {
        console.log("setting ws2")
        ws2 = ws
    } // You might use location.query.access_token to authenticate or share sessions

    // or req.headers.cookie (see http://stackoverflow.com/a/16395220/151312)

    ws.on('message', function incoming(message) {
        // var ws = connections.get(ws._socket.remoteAddress)
        if (ws1 != undefined && ws2 != undefined && ws._socket.remoteAddress == ws1._socket.remoteAddress) {

            ws2.send(message)
        }
        if (ws2 != undefined && ws1 != undefined && ws._socket.remoteAddress == ws2._socket.remoteAddress) {
            ws1.send(message)
        }


    });

    ws.on('close', function close() {
      console.log('disconnected');
    });
});


server.listen(5857, function listening() {
    console.log('Listening on %d', server.address().port);
});
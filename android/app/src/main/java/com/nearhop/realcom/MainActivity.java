package com.nearhop.realcom;

import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import java.net.URI;
import java.net.URISyntaxException;

public class MainActivity extends NHActivity {

    WebSocketClient  mWebSocketClient;
    EditText sendingText;
    TextView messagesView;
    ScrollView messagesScroll;
    Button sendMsg;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        sendingText = (EditText)findViewById(R.id.clientmessage);
        messagesView = (TextView)findViewById(R.id.messages);
        messagesScroll = (ScrollView)findViewById(R.id.messagesscroll);
        sendMsg = (Button)findViewById(R.id.sendme);
        sendMsg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendMessage();
            }
        });
        connectWebSocket();
    }

    public void sendFirstMessage() {
        mWebSocketClient.send("nearhop_android");
    }

    public void sendMessage() {
        String textToSend = sendingText.getText().toString();
        if(textToSend != null && textToSend.length() == 0){
            Toast.makeText(getApplicationContext(),"Enter some text",Toast.LENGTH_SHORT).show();
            return;
        }
        mWebSocketClient.send(textToSend);
        messagesView.setText(messagesView.getText() + "\n" +"CLIENT : " + textToSend);
        sendingText.setText("");
    }

    private void connectWebSocket() {
        URI uri;
        try {
            uri = new URI("ws://192.168.2.102:5857");
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }

        mWebSocketClient = new WebSocketClient(uri) {
            @Override
            public void onOpen(ServerHandshake serverHandshake) {
//                mWebSocketClient.send("HI");
//                messagesView.setText( "CLIENT : HI");
                sendFirstMessage();
            }

            @Override
            public void onMessage(String s) {
                final String message = s;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        messagesView.setText(messagesView.getText() + "\n" + "SERVER : " +message);
                    }
                });
            }

            @Override
            public void onClose(int i, String s, boolean b) {
                Log.i("Websocket", "Closed " + s);
            }

            @Override
            public void onError(Exception e) {
                Log.i("Websocket", "Error " + e.getMessage());
            }
        };
        mWebSocketClient.connect();
    }

}

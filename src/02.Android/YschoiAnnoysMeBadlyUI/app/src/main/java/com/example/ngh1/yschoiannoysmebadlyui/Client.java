package com.example.ngh1.yschoiannoysmebadlyui;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;

/**
 * Created by ngh1 on 2015-10-05.
 */
public class Client extends Activity {
    private String host = null;
    private int num;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.client);

        final EditText ip = (EditText) findViewById(R.id.editIp);
        final EditText food = (EditText) findViewById(R.id.editFood);

        Button connectBtn = (Button) findViewById(R.id.connectBtn);

        connectBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                host = ip.getText().toString();
                num = Integer.parseInt(food.getText().toString());
                (new Connect()).execute(this);
            }
        });
    }

    class Connect extends AsyncTask {
        @Override
        protected Object doInBackground(Object[] params) {
            try {
                int port = 30530;

                Socket socket = new Socket(host, port);

                OutputStream out = socket.getOutputStream();
                DataOutputStream dos = new DataOutputStream(out);

                String msg = "give food : " + num;
                dos.writeUTF(msg);

                dos.close();
                out.close();
                socket.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }

            return null;
        }
    }

}

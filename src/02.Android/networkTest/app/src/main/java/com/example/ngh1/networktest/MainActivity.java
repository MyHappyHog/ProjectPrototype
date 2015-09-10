package com.example.ngh1.networktest;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import java.net.UnknownHostException;

public class MainActivity extends Activity {

    private TextView txtResponse;
    private EditText edtTextAddress, edtTextPort, edtTextMystr;
    private Button btnConnect, btnClear;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        edtTextAddress = (EditText) findViewById(R.id.address);
        edtTextPort = (EditText) findViewById(R.id.port);
        edtTextMystr = (EditText) findViewById(R.id.mystr);
        btnConnect = (Button) findViewById(R.id.connect);
        btnClear = (Button) findViewById(R.id.clear);
        txtResponse = (TextView) findViewById(R.id.response);

        btnConnect.setOnClickListener(buttonConnectOnClickListener);
        btnClear.setOnClickListener(new OnClickListener() {

            public void onClick(View v) {
                txtResponse.setText("");
            }
        });
    }

    // 클릭이벤트 리스너
    OnClickListener buttonConnectOnClickListener = new OnClickListener() {

        public void onClick(View arg0) {
            NetworkTask myClientTask = new NetworkTask(
                    edtTextAddress.getText().toString(),
                    Integer.parseInt(edtTextPort.getText().toString()),
                    edtTextMystr.getText().toString()
            );
            myClientTask.execute();
        }
    };

    public class NetworkTask extends AsyncTask<Void, Void, Void> {

        String dstAddress;
        int dstPort;
        String dstMystr;
        String response;

        NetworkTask(String addr, int port, String mystr) {
            dstAddress = addr;
            dstPort = port;
            dstMystr = mystr;
        }

        @Override
        protected Void doInBackground(Void... arg0) {

            try {
                Socket socket = new Socket(dstAddress, dstPort);
                InputStream inputStream = socket.getInputStream();
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(
                        1024);
                byte[] buffer = new byte[1024];

                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    byteArrayOutputStream.write(buffer, 0, bytesRead);
                }

                socket.close();
                response = byteArrayOutputStream.toString("UTF-8");

            } catch (UnknownHostException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            txtResponse.setText(response);
            super.onPostExecute(result);
        }

    }

}

package com.example.ngh1.yschoiannoysmebadlyui;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Created by ngh1 on 2015-10-05.
 */
public class Server {
    public static void main(String[] args) {
        try {
            int port = 30530;
            ServerSocket socket = new ServerSocket(port);

            System.out.println("waiting...");
            Socket sock = socket.accept();

            System.out.println("connected!");

            InputStream in = sock.getInputStream();
            DataInputStream dis = new DataInputStream(in);

            String userMsg = dis.readUTF();
            System.out.println(userMsg);

            dis.close();
            in.close();
            sock.close();

        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
}
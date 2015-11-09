package com.example.ngh1.networktest;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Created by ngh1 on 2015-09-07.
 */
public class Server {

    public static void main(String[] args) {
        try {
            ServerSocket serverSocket = new ServerSocket(0);
            System.out.println("I'm waiting here: " + serverSocket.getLocalPort());

            while (true) {
                Socket socket = serverSocket.accept();
                System.out.println("from " + socket.getInetAddress() + ":" + socket.getPort());
                System.out.println(socket.toString());

                OutputStream outputStream = socket.getOutputStream();
                PrintStream printStream = new PrintStream(outputStream);
                printStream.print("Server Send Data ~~ ");
                printStream.close();

                socket.close();
            }
        } catch (IOException e) {
            System.out.println(e.toString());
        }
    }
}


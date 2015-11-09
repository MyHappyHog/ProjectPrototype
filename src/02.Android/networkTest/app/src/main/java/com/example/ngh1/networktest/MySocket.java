package com.example.ngh1.networktest;

import java.io.IOException;
import java.net.Socket;

/**
 * Created by ngh1 on 2015-09-08.
 */
public class MySocket extends Socket {
    private String dstMystr;

    MySocket(String addr, int port, String mystr) throws IOException {
        super(addr, port);
        dstMystr = mystr;
    }

    @Override
    public String toString() {
        return super.toString() + dstMystr;
    }
}

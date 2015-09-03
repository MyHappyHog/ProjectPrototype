package com.example.ngh1.dynamic_graph;

import java.util.Random;

/**
 * Created by ngh1 on 2015-09-03.
 * @class MockData
 * @description : get optimized random data for Point class,
 */
public class MockData {
    public static Point getDataFromReceiver(int x) {
        return new Point(x, generateRandomData());
    }

    private static int generateRandomData() {
        Random random = new Random();
        return random.nextInt(100);
    }
}

package com.example.ngh1.dynamic_graph;

/**
 * Created by ngh1 on 2015-09-03.
 * @class Point
 * @description : simple Point class.
 */
public class Point {
    private int xpos, ypos;

    public Point (int xpos, int ypos) {
        this.xpos = xpos;
        this.ypos = ypos;
    }

    public int getX() {
        return xpos;
    }

    public int getY() {
        return ypos;
    }

    public void setX(int xpos) {
        this.xpos = xpos;
    }

    public void setY(int ypos) {
        this.ypos = ypos;
    }
}

package com.example.ngh1.dynamic_graph;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;

import org.achartengine.ChartFactory;
import org.achartengine.GraphicalView;
import org.achartengine.chart.PointStyle;
import org.achartengine.model.TimeSeries;
import org.achartengine.model.XYMultipleSeriesDataset;
import org.achartengine.renderer.XYMultipleSeriesRenderer;
import org.achartengine.renderer.XYSeriesRenderer;

/**
 * Created by ngh1 on 2015-09-03.
 * @class DynamicLineGraph
 * @description generate DynamicLineGraph object
 */
public class DynamicLineGraph {
    private GraphicalView view;

    private TimeSeries dataset = new TimeSeries("Random value");
    private XYMultipleSeriesDataset mDataset = new XYMultipleSeriesDataset();

    private XYSeriesRenderer renderer = new XYSeriesRenderer();
    private XYMultipleSeriesRenderer mRenderer = new XYMultipleSeriesRenderer();


    /**
     * @method DynamicLineGraph (constructor)
     * @description set default setting for dynamic line graph
     */
    public DynamicLineGraph() {
        mDataset.addSeries(dataset);

        renderer.setColor(Color.WHITE);
        renderer.setPointStyle(PointStyle.SQUARE);
        renderer.setFillPoints(true);
        renderer.setDisplayChartValues(true);
        renderer.setChartValuesTextAlign(Paint.Align.RIGHT);

        renderer.setChartValuesTextSize((float) 20.0);
        renderer.setLineWidth((float) 2.5);


        mRenderer.setApplyBackgroundColor(true);
        mRenderer.setBackgroundColor(Color.BLACK);

        mRenderer.setChartTitleTextSize((float) 25.0);
        mRenderer.setLabelsTextSize((float) 20.0);
        mRenderer.setAxisTitleTextSize((float) 15.0);
        mRenderer.setLegendTextSize((float) 22.0);

        mRenderer.setYAxisMin((double) 0);
        mRenderer.setYAxisMax((double) 100);
        mRenderer.setXAxisMin((double) 0);
        mRenderer.setXAxisMax((double) 9);

        mRenderer.setXTitle("X VALUES");
        mRenderer.setYTitle("Y VALUES");
        // mRenderer.setDisplayValues(true);
        mRenderer.setChartTitle("Dynamic Random Graph Test");

        mRenderer.addSeriesRenderer(renderer);
    }

    public GraphicalView getView(Context context) {
        view = ChartFactory.getLineChartView(context, mDataset, mRenderer);
        return view;
    }

    public void addNewPoints(Point p) {
        dataset.add(p.getX(), p.getY());
    }

    /**
     * @param i : current xpos
     * @param minY : min ypos in graph
     * @param maxY : max ypos in graph
     */
    public void nextFixedDisp(int i, int minY, int maxY) {
        mRenderer.setXAxisMin((double) (i - 9));
        mRenderer.setXAxisMax((double) (i));
        mRenderer.setYAxisMin((double) (minY));
        mRenderer.setYAxisMax((double) (maxY));
    }

}

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatelessWidget {
  final ChartTypes chartType;
  final String strTitle;
  final TextStyle? titleTextStyle;
  final List<List<ChartData>> chartData;
  final List<ChartSeriesData>? chartSeriesData;
  final LegendPosition legendPosition;
  final bool bShowLegend;
  final bool bXAxisGridLines;
  final bool bYAxisGridLines;
  final bool bBorder;
  final int dXAxisLabelRotation;
  final bool bDataLabel;
  final String? strXAxisTitle;
  final TextStyle? xAxisTitleStyle;
  final String? strYAxisTitle;
  final TextStyle? yAxisTitleStyle;
  final String strXLabelPrefix;
  final String strYLabelPrefix;
  final String strXLabelSuffix;
  final String strYLabelSuffix;
  final TextStyle? xLabelStyle;
  final TextStyle? yLabelStyle;
  final Color strokeColor;
  final double strokeWidth;
  final TextStyle? axisTextStyle;

  const Chart({
    Key? key,
    required this.chartType,
    this.strTitle = "",
    this.titleTextStyle,
    required this.chartData,
    this.legendPosition = LegendPosition.bottom,
    this.bShowLegend = true,
    this.bXAxisGridLines = false,
    this.bYAxisGridLines = true,
    this.bBorder = true,
    this.dXAxisLabelRotation = 0,
    this.bDataLabel = false,
    this.chartSeriesData,
    this.strXAxisTitle,
    this.xAxisTitleStyle,
    this.strYAxisTitle,
    this.yAxisTitleStyle,
    this.strXLabelPrefix = "",
    this.strYLabelPrefix = "",
    this.xLabelStyle,
    this.yLabelStyle,
    this.strXLabelSuffix = "",
    this.strYLabelSuffix = "",
    this.strokeColor = AppColors.CHART_STROKE_COLOR,
    this.strokeWidth = 1,
    this.axisTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(value: AutomationConstants.CHART, child: mapCharts());
  }

  Widget _circularChart() {
    return SfCircularChart(
      title: _chartTitle(),
      legend: _chartLegend(),
      series: <CircularSeries>[
        if (chartType == ChartTypes.pieChart)
          PieSeries<ChartData, String>(
            dataSource: chartData[0],
            pointColorMapper: (ChartData data, _) => data.color,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor,
            xValueMapper: (ChartData data, _) => data.strXAxisData,
            yValueMapper: (ChartData data, _) => data.strYAxisData,
          ),
        if (chartType == ChartTypes.donut)
          DoughnutSeries<ChartData, String>(
            dataSource: chartData[0],
            strokeWidth: strokeWidth,
            strokeColor: strokeColor,
            pointColorMapper: (ChartData data, _) => data.color,
            xValueMapper: (ChartData data, _) => data.strXAxisData,
            yValueMapper: (ChartData data, _) => data.strYAxisData,
          ),
      ],
    );
  }

  Widget _nonCircularChart() {
    return SfCartesianChart(
      title: _chartTitle(),
      legend: _chartLegend(),
      plotAreaBorderWidth: bBorder ? 0.7 : 0,
      series: <CartesianSeries>[
        if (chartType == ChartTypes.barChart)
          ...List.generate(
            chartData.length,
            (index) => StackedBarSeries<ChartData, String>(
              dataSource: chartData[index],
              borderWidth:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].borderWidth!
                      : 2.0,
              borderColor:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].borderColor!
                      : Colors.transparent,
              name:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].chartLegendName
                      : null,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.strXAxisData,
              yValueMapper: (ChartData data, _) => data.strYAxisData,
              dataLabelSettings: _dataLabelSettings(),
            ),
          ),
        if (chartType == ChartTypes.areaChart)
          ...List.generate(
            chartData.length,
            (index) => AreaSeries<ChartData, String>(
              dataSource: chartData[index],
              name:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].chartLegendName
                      : null,
              color:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].seriesColor
                      : null,
              pointColorMapper: (ChartData data, _) => data.color,
              borderWidth:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].borderWidth!
                      : 2.0,
              borderColor:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].borderColor!
                      : Colors.transparent,
              xValueMapper: (ChartData data, _) => data.strXAxisData,
              yValueMapper: (ChartData data, _) => data.strYAxisData,
              dataLabelSettings: _dataLabelSettings(),
            ),
          ),
        if (chartType == ChartTypes.columnChart)
          ...List.generate(
            chartData.length,
            (index) => ColumnSeries<ChartData, String>(
              dataSource: chartData[index],
              name:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].chartLegendName
                      : null,
              color:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].seriesColor
                      : null,
              pointColorMapper: (ChartData data, _) => data.color,
              borderWidth:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].borderWidth!
                      : 2.0,
              borderColor:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].borderColor!
                      : Colors.transparent,
              xValueMapper: (ChartData data, _) => data.strXAxisData,
              yValueMapper: (ChartData data, _) => data.strYAxisData,
              dataLabelSettings: _dataLabelSettings(),
            ),
          ),
        if (chartType == ChartTypes.lineChart)
          ...List.generate(
            chartData.length,
            (index) => StackedLineSeries<ChartData, String>(
              dataSource: chartData[index],
              markerSettings: MarkerSettings(
                isVisible: true,
                borderColor:
                    (chartSeriesData != null && chartSeriesData!.length >= index)
                        ? chartSeriesData![index].seriesColor
                        : null,
              ),
              name:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].chartLegendName
                      : null,
              color:
                  (chartSeriesData != null && chartSeriesData!.length >= index)
                      ? chartSeriesData![index].seriesColor
                      : null,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.strXAxisData,
              yValueMapper: (ChartData data, _) => data.strYAxisData,
              dataLabelSettings: _dataLabelSettings(),
            ),
          ),
      ],
      primaryXAxis: CategoryAxis(
        majorGridLines: bXAxisGridLines ? const MajorGridLines() : const MajorGridLines(width: 0),
        labelRotation: dXAxisLabelRotation,
        labelStyle: axisTextStyle ?? AppStyles.chartAxisTextStyle,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        axisLabelFormatter: (details) {
          return ChartAxisLabel(
            "$strXLabelPrefix${details.text}$strXLabelSuffix",
            xLabelStyle ?? details.textStyle,
          );
        },
        title: AxisTitle(text: strXAxisTitle, textStyle: xAxisTitleStyle),
      ),
      primaryYAxis: NumericAxis(
        // majorGridLines: null,
        majorGridLines: bYAxisGridLines ? const MajorGridLines() : const MajorGridLines(width: 0),
        labelStyle: axisTextStyle ?? AppStyles.chartAxisTextStyle,
        axisLabelFormatter: (details) {
          return ChartAxisLabel(
            "$strYLabelPrefix${details.text}$strYLabelSuffix",
            yLabelStyle ?? details.textStyle,
          );
        },
        title: AxisTitle(text: strYAxisTitle, textStyle: yAxisTitleStyle),
      ),
    );
  }

  DataLabelSettings _dataLabelSettings() {
    return DataLabelSettings(isVisible: bDataLabel);
  }

  ChartTitle _chartTitle() {
    return ChartTitle(text: strTitle, textStyle: titleTextStyle ?? AppStyles.chartTitleStyle);
  }

  Legend _chartLegend() {
    return Legend(
      isVisible: bShowLegend,
      overflowMode: LegendItemOverflowMode.wrap,
      position: legendPosition,
    );
  }

  Widget mapCharts() {
    if (chartType == ChartTypes.pieChart || chartType == ChartTypes.donut) {
      return _circularChart();
    } else {
      return _nonCircularChart();
    }
  }
}

class ChartData {
  final String strXAxisData;
  final double strYAxisData;
  final Color? color;
  ChartData({required this.strXAxisData, required this.strYAxisData, this.color});
}

class ChartSeriesData {
  final String? chartLegendName;
  final Color? seriesColor;
  final Color? borderColor;
  final double? borderWidth;

  ChartSeriesData({this.chartLegendName, this.seriesColor, this.borderColor, this.borderWidth});
}

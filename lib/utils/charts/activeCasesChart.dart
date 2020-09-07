import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Chart used to display active cases progression
class ActiveCasesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final int max;
  final bool animate;
  final Function changeCallback;

  ActiveCasesChart (this.seriesList, this.max, this.changeCallback, {this.animate});

  @override
  Widget build(BuildContext context) {
    int tick = max < 100 ? (max~/5).toInt() : (max~/5).toInt();

    List<charts.TickSpec<num>> ticks = new List();
    for (int i=0; i<=5; i++) {
      ticks.add(charts.TickSpec<num>(tick*i));
    }

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: this.changeCallback,
        )
      ],

      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec( ticks ),
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.text[600])
              ),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.background[500])
              )
          )
      ),

      domainAxis: new charts.DateTimeAxisSpec(
          tickProviderSpec: charts.DayTickProviderSpec(increments: [30]),
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.text[600])
              ),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.background[500])
              )
          )
      ),
    );
  }

  factory ActiveCasesChart.fromValues (Map<DateTime, int> series, Function changeCallback, {String selectedProvince}) {
    int max = 0;
    for (var d in series.values) {
      if (d != null && d > max) {
        max = d;
      }
    }

    List<ActiveCasesProgressionPoint> points = new List();
    for (DateTime date in series.keys) {
      points.add(
        ActiveCasesProgressionPoint(time: date, value: series[date])
      );
    }

    List<charts.Series<ActiveCasesProgressionPoint, DateTime>> data = [
      new charts.Series<ActiveCasesProgressionPoint, DateTime>(
          id: 'Active cases',
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
          domainFn: (ActiveCasesProgressionPoint value, _) => value.time,
          measureFn: (ActiveCasesProgressionPoint value, _) => value.value,
          data: points
      )
    ];

    return new ActiveCasesChart (
      data,
      max,
      changeCallback,
      animate: true,
    );
  }
}

/// Sample time series data type.
class ActiveCasesProgressionPoint {
  final DateTime time;
  final int value;

  ActiveCasesProgressionPoint({this.time, this.value});
}
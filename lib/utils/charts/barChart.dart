import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

/// Bar chart used to display popularity statistics.
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  factory SimpleBarChart.fromPopularTimes(List<List<int>> times) {
    return new SimpleBarChart(
      _createDataFromPopularTimes(times),
      animate: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis:
        new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: true,
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.text[600])
              ),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.background[500])
              )
          ),

          tickProviderSpec:
            new charts.StaticOrdinalTickProviderSpec(
                <charts.TickSpec<String>>[
                  new charts.TickSpec('7h'),
                  new charts.TickSpec('9h'),
                  new charts.TickSpec('11h'),
                  new charts.TickSpec('13h'),
                  new charts.TickSpec('15h'),
                  new charts.TickSpec('17h'),
                  new charts.TickSpec('19h'),
                  new charts.TickSpec('21h'),
                  new charts.TickSpec('23h'),
                ]
            )),
    );
  }

  /// Converts popularity statistics into graph-compatible data.
  static List<charts.Series<CrowdRate, String>> _createDataFromPopularTimes(List<List<int>> times) {
    final data = new List<CrowdRate>();

    for (var time in times) {
      data.add(new CrowdRate("${time.first}h", time.last));
    }

    return [
      new charts.Series<CrowdRate, String>(
        id: 'Crowds',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CrowdRate cr, _) => cr.hour,
        measureFn: (CrowdRate cr, _) => cr.rate,
        data: data
      )
    ];
  }
}

class CrowdRate {
  final String hour;
  final int rate;

  CrowdRate (this.hour, this.rate);
}
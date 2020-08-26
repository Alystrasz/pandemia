import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Chart used to display virus progression in a given country.
class VirusChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final int max;

  VirusChart (this.seriesList, this.max, {this.animate});

  @override
  Widget build(BuildContext context) {
    int tick = (max/10).toInt();
    List<charts.TickSpec<num>> ticks = new List();
    for (int i=0; i<11; i++) {
      ticks.add(charts.TickSpec<num>(tick*i));
    }

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),

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
          tickProviderSpec: charts.DayTickProviderSpec(increments: [3]),
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


  factory VirusChart.fromDailyData (List<VirusDayData> series) {
    int max = 0;
    for (var d in series) {
      if (d.confirmedCases > max) {
        max = d.confirmedCases;
      }
    }

    List<charts.Series<VirusDayData, DateTime>> data = [
      new charts.Series<VirusDayData, DateTime>(
          id: 'Virus',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.confirmedCases,
          data: series
      )
    ];

    return new VirusChart (
      data,
      max,
      animate: true,
    );
  }
}
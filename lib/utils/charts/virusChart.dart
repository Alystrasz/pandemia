import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

/// Chart used to display virus progression in a given country.
class VirusChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  VirusChart (this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),

      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(10000),
            charts.TickSpec<num>(20000),
            charts.TickSpec<num>(30000),
            charts.TickSpec<num>(40000),
            charts.TickSpec<num>(50000),
            charts.TickSpec<num>(60000),
            charts.TickSpec<num>(70000),
            charts.TickSpec<num>(80000),
            charts.TickSpec<num>(90000),
            charts.TickSpec<num>(100000),
          ],
        ),
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


  factory VirusChart.fromRandomData () {
    List<VirusDayData> series = [];

    DateTime start = new DateTime(2020, 3, 3);

    for (var i=0, len=100; i<len; i++) {
      series.add(new VirusDayData(
          start.add(Duration(days: i)),
          new Random().nextInt(100000),
          new Random().nextInt(100000),
          new Random().nextInt(100000),
          new Random().nextInt(100000)
      ));
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
      animate: true,
    );
  }
}

/// Virus data sample
class VirusDayData {
  final DateTime time;
  final int confirmedCases;
  final int deathCases;
  final int recoveredCases;
  final int activeCases;

  VirusDayData(this.time, this.confirmedCases, this.deathCases,
      this.recoveredCases, this.activeCases);
}
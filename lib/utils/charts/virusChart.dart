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
    int tick = (max~/10).toInt();

    List<charts.TickSpec<num>> ticks = new List();
    for (int i=0; i<11; i++) {
      ticks.add(charts.TickSpec<num>(tick*i));
    }

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [new charts.SeriesLegend(
          desiredMaxColumns: 2,
          insideJustification: charts.InsideJustification.topEnd,
          outsideJustification: charts.OutsideJustification.end,
          position: charts.BehaviorPosition.top,
          entryTextStyle: charts.TextStyleSpec(
            color: charts.Color(r: 200, g: 200, b: 200),
            fontSize: 12,
          ),
        cellPadding: EdgeInsets.only(right: 15),
      )],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (e) {
            print(e.selectedDatum[0].datum as VirusDayData);
          },
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


  factory VirusChart.fromDailyData (List<VirusDayData> series) {
    int max = 0;
    for (var d in series) {
      if (d.confirmedCases > max) {
        max = d.confirmedCases;
      }
    }

    List<charts.Series<VirusDayData, DateTime>> data = [
      new charts.Series<VirusDayData, DateTime>(
          id: 'Confirmed cases',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.confirmedCases,
          data: series
      ),
      new charts.Series<VirusDayData, DateTime>(
          id: 'Death cases',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.deathCases,
          data: series
      ),
      new charts.Series<VirusDayData, DateTime>(
          id: 'Recovered cases',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.recoveredCases,
          data: series
      ),
      new charts.Series<VirusDayData, DateTime>(
          id: 'Active cases',
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.activeCases,
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
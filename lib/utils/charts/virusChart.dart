import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Chart used to display virus progression in a given country.
class VirusChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final int max;
  final Function changeCallback;
  final BuildContext context; // needed for translations

  VirusChart (this.seriesList, this.max, this.changeCallback,
      {this.animate, this.context});

  @override
  Widget build(BuildContext context) {
    int tick = max < 100 ? (max~/5).toInt() : (max~/10).toInt();

    List<charts.TickSpec<num>> ticks = [];
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

  factory VirusChart.fromDailyData (List<VirusDayData> series, Function changeCallback,
     {String selectedProvince, String selectedCity, BuildContext context}) {

    List<VirusDayData> graphSeries = VirusGraphModel.filterDataByProvince(series, selectedProvince, selectedCity);
    int max = 0;
    for (var d in graphSeries) {
      if (d.confirmedCases > max) {
        max = d.confirmedCases;
      }
    }

    List<charts.Series<VirusDayData, DateTime>> data = [
      new charts.Series<VirusDayData, DateTime>(
          id: FlutterI18n.translate(context, "virus_progression_confirmed_cases"),
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.confirmedCases,
          data: graphSeries
      ),
      new charts.Series<VirusDayData, DateTime>(
          id: FlutterI18n.translate(context, "virus_progression_death_cases"),
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.deathCases,
          data: graphSeries
      ),
      new charts.Series<VirusDayData, DateTime>(
          id: FlutterI18n.translate(context, "virus_progression_recovered_cases"),
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.recoveredCases,
          data: graphSeries
      ),
      new charts.Series<VirusDayData, DateTime>(
          id: FlutterI18n.translate(context, "virus_progression_active_cases"),
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
          domainFn: (VirusDayData exposition, _) => exposition.time,
          measureFn: (VirusDayData exposition, _) => exposition.activeCases,
          data: graphSeries
      )
    ];

    return new VirusChart (
      data,
      max,
      changeCallback,
      animate: true,
      context: context,
    );
  }
}
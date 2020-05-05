import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final int rate;
  final double pi = 3.14;

  GaugeChart(this.rate, this.seriesList, {this.animate});

  factory GaugeChart.fromRate(int rate) {
    return new GaugeChart(
      rate,
      _createData(rate),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container (
          width: 180,
          height: 150,
          margin: EdgeInsets.fromLTRB(0, 42, 0, 0),
          child: Stack (
            children: <Widget>[
              Container (
                transform: Matrix4.translationValues(58, 62, 0),
                child: Text("$rate%", style: TextStyle(fontSize: 20, color: CustomPalette.text[400])),
              ),

              Container (
                width: 150,
                height: 150,
                child: charts.PieChart(
                    seriesList,
                    animate: animate,
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 10, startAngle: pi, arcLength: 2*pi)),
              ),
            ],
          ),
        ),

        Expanded (
          child: Container (
            width: 200,
            // transform: Matrix4.translationValues(25, -15, 0),
            child: Text("I might have been exposed today",
                style: TextStyle(fontSize: 20, color: CustomPalette.text[400])),
          ),
        )
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createData(int rate) {
    final data = [
      new GaugeSegment('Contamination rate', rate),
      new GaugeSegment('Space', 100 - rate),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}
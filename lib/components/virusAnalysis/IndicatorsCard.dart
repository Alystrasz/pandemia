import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/activeCasesChart.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';

class IndicatorsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VirusGraphModel>(
        builder: (context, model, child) {
          if (model.currentData == null || model.currentData.length == 0) {
            return Container ();
          } else {
            Map<DateTime, int> activeCasesProgression =
              computeActiveCasesMobileAverage(model.currentData);
            double rate = getActiveCasesProgressionRate(activeCasesProgression);

            return Container (
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Stack (
                children: <Widget>[
                  Container(
                    color: CustomPalette.background[600],
                    width: 5000,
                    child: Stack (
                      children: <Widget>[
                        Container(
                          child: new Text(
                            'Indicators',
                            style: TextStyle(
                                color: CustomPalette.text[100],
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                        ),

                        Container(
                            child: new Text(
                              "Pandemic indicators for your region",
                              style: TextStyle(
                                  color: CustomPalette.text[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 70, left: 10),
                            child: model.isParsingData ? Center (
                              child: CircularProgressIndicator(),
                            ) : new Text(
                              "${model.currentData.last.activeCases} active cases now",
                              style: TextStyle(
                                color: CustomPalette.text[100],
                                fontSize: 20,
                              ),
                            ),
                            padding: EdgeInsets.only(bottom: 20)
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 95, left: 10),
                            child: model.isParsingData ? Center (
                              child: CircularProgressIndicator(),
                            ) : new Text(
                              "Active cases progression: ${rate.toStringAsFixed(3)}",
                              style: TextStyle(
                                color: CustomPalette.text[100],
                                fontSize: 20,
                              ),
                            ),
                            padding: EdgeInsets.only(bottom: 20)
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 118, left: 10),
                            child: model.isParsingData ? Center (
                              child: CircularProgressIndicator(),
                            ) : new Text(
                              rate > 1 ? "Pandemic is progressing" : "Pandemic is regressing",
                              style: TextStyle(
                                color: CustomPalette.text[100],
                                fontSize: 20,
                              ),
                            ),
                            padding: EdgeInsets.only(bottom: 20)
                        ),

                        Container (
                          margin: EdgeInsets.only(top: 150, left: 10),
                          padding: EdgeInsets.only(bottom: 10),
                          height: 200,
                          child: ActiveCasesChart.fromValues(
                              activeCasesProgression
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }

  double getActiveCasesProgressionRate (Map<DateTime, int> data) {
    List<DateTime> keys = data.keys.toList();
    int index = keys.length-1;

    while (data[keys[index]] == null) {
      index--;
    }

    int lastComputedAverage = data[keys[index]];
    int previousComputedAverage = data[keys[index-6]];
    return lastComputedAverage/previousComputedAverage;
  }

  Map<DateTime, int> computeActiveCasesMobileAverage (List<VirusDayData> series) {
    Map<DateTime, int> values = new Map();
    int windowSize = 11;
    int sideWindowSize = (windowSize/2).floor();

    for (int i=0, len=series.length; i<len; i++) {
      VirusDayData data = series[i];
      if (i<sideWindowSize || i>=len-sideWindowSize) {
        values.putIfAbsent(data.time, () => null);
      } else {
        int sum = 0;
        for (int j=i-sideWindowSize; j<=i+sideWindowSize; j++) {
          sum += series[j].activeCases;
        }
        values.putIfAbsent(data.time, () => (sum~/windowSize));
      }
    }

    return values;
  }
}
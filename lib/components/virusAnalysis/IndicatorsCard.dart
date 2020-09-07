import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
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
                              "Active cases progression: ${getActiveCasesProgressionRate(model.currentData)}"
                                  "${computeActiveCasesMobileAverage(model.currentData)}",
                              style: TextStyle(
                                color: CustomPalette.text[100],
                                fontSize: 20,
                              ),
                            ),
                            padding: EdgeInsets.only(bottom: 20)
                        ),
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

  /// Computes active cases progression rate with data from 5 days ago.
  String getActiveCasesProgressionRate (List<VirusDayData> data) {
    VirusDayData last = data.last;
    VirusDayData previous = data[data.length-6];
    return (last.activeCases/previous.activeCases).toStringAsFixed(4);
  }

  String computeActiveCasesMobileAverage (List<VirusDayData> series) {
    Map<String, int> values = new Map();
    int windowSize = 11;
    int sideWindowSize = (windowSize/2).floor();

    for (int i=0, len=series.length; i<len; i++) {
      VirusDayData data = series[i];
      if (i<sideWindowSize || i>=len-sideWindowSize) {
        values.putIfAbsent(data.time.toIso8601String(), () => null);
      } else {
        int sum = 0;
        for (int j=i-sideWindowSize; j<=i+sideWindowSize; j++) {
          sum += series[j].activeCases;
        }
        values.putIfAbsent(data.time.toIso8601String(), () => (sum~/windowSize));
      }
    }

    print(values.values);
    return "";
  }
}
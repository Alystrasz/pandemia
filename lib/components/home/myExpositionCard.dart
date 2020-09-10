import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/gaugeChart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Widget showing current day's exposition using the last report.
/// It displays the exposition rate as a circular graph with an associated
/// message.
class MyExpositionCard extends StatelessWidget {
  MyExpositionCard(String title);

  Widget build(BuildContext context) {
    return Container (
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Stack (
          children: <Widget>[
            Container(
              color: CustomPalette.background[600],
              child: Stack (
                children: <Widget>[
                  buildGraph(),

                  Container(
                    child: new Text(
                      FlutterI18n.translate(context, "home_myexposition_title"),
                      style: TextStyle(
                          color: CustomPalette.text[100],
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    padding: EdgeInsets.all(10.0),
                  ),

                  Container(
                      child: new Text(
                        new DateFormat("dd/MM/yyyy").format(new DateTime.now()),
                        style: TextStyle(
                            color: CustomPalette.text[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
                  ),

                  Container(
                      child: Center (
                        child: new Text(
                          FlutterI18n.translate(context, "virus_progression_touch_message"),
                          style: TextStyle(
                              color: CustomPalette.text[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 200, bottom: 10)
                  ),

                  Container (
                    height: 226,
                    width: 5000,
                    child: FlatButton(
                      child: Text(""),
                      onPressed: () {
                        // Let the animation roll before showing component
                        Timer(Duration(milliseconds: 175), () =>
                            Navigator.pushNamed(context, '/virus-analyze'));
                      },
                      splashColor: CustomPalette.background[100]
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget buildGraph() {
    return Consumer<AppModel>(
        builder: (context, model, child) {
          List<DailyReport> reports = model.reports;
          if (reports.length == 0) {
            return Container (
                color: CustomPalette.background[600],
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                height: 212,
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          }

          return Container (
            child: GaugeChart.fromRate(reports.last.expositionRate),
            margin: EdgeInsets.all(10),
          );
        }
    );
  }
}
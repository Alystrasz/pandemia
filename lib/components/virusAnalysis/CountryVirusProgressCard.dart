import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pandemia/components/virusAnalysis/CitySelectionDialog.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/virusChart.dart';
import 'package:pandemia/components/virusAnalysis/ProvinceSelectionDialog.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';

class CountryVirusProgressCard extends StatefulWidget {
  final BuildContext context;
  CountryVirusProgressCard({this.context});

  @override
  State<CountryVirusProgressCard> createState() => _CountryVirusProgressCardState();
}

class _CountryVirusProgressCardState extends State<CountryVirusProgressCard> {
  void _onSelectionChanged (dynamic data) {
    VirusDayData stats = data.selectedDatum[0].datum;
    String date = "${stats.time.day < 10 ? "0" + stats.time.day.toString() : stats.time.day}/"
        "${stats.time.month < 10 ?
          "0" + stats.time.month.toString() :
          stats.time.month}"
        "/${stats.time.year}";
    String message = "$date\n"
        "${FlutterI18n.translate(widget.context, "virus_progression_confirmed_cases")}: ${stats.confirmedCases}"
        "\n${FlutterI18n.translate(widget.context, "virus_progression_active_cases")}: ${stats.activeCases}"
        "\n${FlutterI18n.translate(widget.context, "virus_progression_recovered_cases")}: ${stats.recoveredCases}"
        "\n${FlutterI18n.translate(widget.context, "virus_progression_death_cases")}: ${stats.deathCases}";

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<VirusGraphModel>(
      builder: (context, model, child) {
        return Container (
          height: 300,
          color: CustomPalette.background[600],
          margin: EdgeInsets.only(bottom: 10),
          child: Stack (
            children: <Widget>[
              Container (
                child: Builder (
                  builder: (context) {
                    print(model);

                    if (model.isParsingData || model.selectedCountry == '') {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (model.currentData.length == 0) {
                        return Container (
                          child: Center (
                            child: Text (
                              "No data for this country.",
                              style: TextStyle(
                                  color: CustomPalette.text[100],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                        );
                      } else {
                        // checking if a province has been selected
                        if (model.province != null && model.city != null) {
                          return VirusChart.fromDailyData(
                            model.currentData, _onSelectionChanged,
                            selectedProvince: model.province,
                            context: context,
                          );
                        } else {
                          List<String> provinces = new List();
                          List<String> cities = new List();

                          for (var stat in model.currentData) {
                            if (!provinces.contains(stat.province))
                              provinces.add(stat.province);
                            if (!cities.contains(stat.city))
                              cities.add(stat.city);
                          }

                          if (provinces.length > 1) {
                            print("multiple provinces detected");
                            Timer(Duration(milliseconds: 1), () {
                              var dialog = ProvinceSelectionDialog (provinces);
                              dialog.show(context);
                            });
                          } else if (cities.length > 1) {
                            print('multiple cities detected');
                            Timer(Duration(milliseconds: 1), () {
                              var dialog = CitySelectionDialog (cities);
                              dialog.show(context);
                            });
                          } else {
                            return VirusChart.fromDailyData(
                              model.currentData, _onSelectionChanged,
                              selectedProvince: provinces.length > 1 ? provinces[0] : null,
                              context: context,
                            );
                          }

                          return Center (
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    }
                  }),
                margin: EdgeInsets.fromLTRB(10, 40, 0, 10),
              ),

              Container(
                child: new Text(
                  FlutterI18n.translate(context, "virus_progression_graph_title"),
                  style: TextStyle(
                      color: CustomPalette.text[100],
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                  ),
                ),
                padding: EdgeInsets.all(10.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
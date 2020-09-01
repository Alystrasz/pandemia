import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/virusChart.dart';
import 'package:pandemia/utils/countrySelection/ProvinceSelectionDialog.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';

class CountryVirusProgressCard extends StatelessWidget {
  void _onSelectionChanged (dynamic data) {
    VirusDayData stats = data.selectedDatum[0].datum;
    String date = "${stats.time.day < 10 ? "0" + stats.time.day.toString() : stats.time.day}/"
        "${stats.time.month < 10 ?
          "0" + stats.time.month.toString() :
          stats.time.month}"
        "/${stats.time.year}";
    String message = "$date\nConfirmed cases: ${stats.confirmedCases}"
        "\nActive cases: ${stats.activeCases}"
        "\nRecovered cases: ${stats.recoveredCases}"
        "\nDeath cases: ${stats.deathCases}";

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
          child: Stack (
            children: <Widget>[
              Container (
                child: FutureBuilder<List<VirusDayData>>(
                  future: Provider.of<VirusGraphModel>(context, listen: true)
                      .update(),
                  builder: (context, AsyncSnapshot<List<VirusDayData>> snapshot) {
                    print(model);

                    if (!snapshot.hasData || model.selectedCountry == '') {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data.length == 0) {
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
                        if (model.province != null) {
                          return VirusChart.fromDailyData(
                            snapshot.data, _onSelectionChanged,
                            selectedProvince: model.province
                          );
                        } else {
                          List<String> provinces = new List();
                          for (var stat in snapshot.data) {
                            if (!provinces.contains(stat.province))
                              provinces.add(stat.province);
                          }

                          if (provinces.length > 1) {
                            print("multiple provinces detected");
                            Timer(Duration(milliseconds: 1), () {
                              var dialog = ProvinceSelectionDialog (provinces);
                              dialog.show(context);
                            });
                          } else {
                            return VirusChart.fromDailyData(
                              snapshot.data, _onSelectionChanged,
                              selectedProvince: provinces.length > 1 ? provinces[0] : null,
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
                  "Virus progression",
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/virusChart.dart';
import 'package:pandemia/utils/countrySelection/Covid19ApiParser.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';

class CountryVirusProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Consumer<AppModel>(
      builder: (context, model, child) {
        Covid19ApiParser parser = new Covid19ApiParser();

        return Container (
          height: 300,
          color: CustomPalette.background[600],
          child: Stack (
            children: <Widget>[
              Container (
                child: FutureBuilder<List<VirusDayData>>(
                  future: parser.getCountryData(model.selectedCountry),
                  builder: (context, AsyncSnapshot<List<VirusDayData>> snapshot) {
                    if (!snapshot.hasData || model.selectedCountry == '') {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return snapshot.data.length == 0 ?
                        Container (
                            child: Center (
                              child: Text(
                                "No data for this country.",
                                style: TextStyle(
                                    color: CustomPalette.text[100],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            ),
                        ) :
                        VirusChart.fromDailyData(snapshot.data);
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
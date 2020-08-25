import 'package:flutter/cupertino.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/virusChart.dart';

class CountryVirusProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container (
      height: 300,
      color: CustomPalette.background[600],
      child: Stack (
        children: <Widget>[
          Container (
            child: VirusChart.fromRandomData(),
            margin: EdgeInsets.fromLTRB(10, 60, 0, 10),
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

          Container(
              child: Text(
                "Confirmed cases evolution",
                style: TextStyle(
                    color: CustomPalette.text[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
          ),
        ],
      ),
    );
  }

}
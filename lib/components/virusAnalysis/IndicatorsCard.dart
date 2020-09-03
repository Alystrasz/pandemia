import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class IndicatorsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

              ],
            ),
          ),
        ],
      ),
    );
  }
}
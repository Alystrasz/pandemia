import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:provider/provider.dart';

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

                Consumer<VirusGraphModel>(
                  builder: (context, model, child) {
                    return Container(
                        child: new Text(
                          "${model.currentData.last.activeCases} active cases now",
                          style: TextStyle(
                              color: CustomPalette.text[100],
                              fontSize: 20,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 70, left: 10.0, bottom: 10)
                    );
                  }
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
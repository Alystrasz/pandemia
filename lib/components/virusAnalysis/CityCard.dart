import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:provider/provider.dart';

class CityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VirusGraphModel>(
      builder: (context, model, widget) {
        if (['', null].contains(model.city)) {
          return Container();
        } else {
          return Container(
              color: CustomPalette.background[500],
              width: 5000,
              margin: EdgeInsets.only(bottom: 10),
              child: new Text(
                '${FlutterI18n.translate(context, "virus_progression_selected_city")}: '
                    '${model.city}',
                style: TextStyle(
                    color: CustomPalette.text[500],
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                ),
              ),
              padding: EdgeInsets.all(10.0),
          );
        }
      },
    );
  }
}
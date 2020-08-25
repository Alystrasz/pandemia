import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/home/expositionProgressionCard.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/information/countrySelection/CountrySelectionTile.dart';

class VirusAnalyzeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VirusAnalyzeViewState();
}

class _VirusAnalyzeViewState extends State<VirusAnalyzeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomPalette.background[700],
      appBar: AppBar(
        backgroundColor: CustomPalette.background[400],
        title: Text("Virus exposition analysis"),
      ),
      body: ListView(
          children: <Widget>[
            CountrySelectionTile()
          ]
      )
    );
  }
}
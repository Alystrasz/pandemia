import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/virusAnalysis/IndicatorsCard.dart';
import 'package:pandemia/components/virusAnalysis/ProvinceCard.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/components/virusAnalysis/CountrySelectionTile.dart';
import 'package:pandemia/components/virusAnalysis/CountryVirusProgressCard.dart';

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
            CountrySelectionTile(),
            ProvinceCard(),
            CountryVirusProgressCard(),
            IndicatorsCard()
          ]
      )
    );
  }
}
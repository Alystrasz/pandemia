import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:provider/provider.dart';

class CitySelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;

  CitySelectionDialog (List<String> cities) {
     cities.sort((a, b) => a.compareTo(b));
    _dialog = SimpleDialog(
      title: const Text('Choose a city', style: TextStyle(color: Color(0xFFDDDDDD))),
      backgroundColor: CustomPalette.background[500],
      children: cities.map((String city) => ListTile(
        title: Text(city == '' ? "Home country" : city, style: TextStyle(color: CustomPalette.text[400])),
        onTap: () {
          Provider.of<VirusGraphModel>(_context).setCity(city);
          Navigator.pop(_context);
        },
      )).toList()
    );
  }

  void show (BuildContext context) {
    this._context = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            // ignore: missing_return
            onWillPop: (){},
            child: _dialog
        );
      },
    );
  }
}
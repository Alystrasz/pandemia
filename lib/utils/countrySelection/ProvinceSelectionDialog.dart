import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/countrySelection/CountrySelectionTile.dart';
import 'package:provider/provider.dart';

class ProvinceSelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;
  final LocalStorage _storage = new LocalStorage('pandemia_app.json');

  ProvinceSelectionDialog (List<String> provinces) {
     provinces.sort((a, b) => a.compareTo(b));
    _dialog = SimpleDialog(
      title: const Text('Choose a province', style: TextStyle(color: Color(0xFFDDDDDD))),
      backgroundColor: CustomPalette.background[500],
      children: provinces.map((String p) => ListTile(
        title: Text(p == '' ? "Home country" : p, style: TextStyle(color: CustomPalette.text[400])),
        onTap: () {
          Provider.of<VirusGraphModel>(_context).setProvince(p);
          _storage.setItem(CountrySelectionTile.selectedProvinceKey, p);
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
        return _dialog;
      },
    );
  }
}
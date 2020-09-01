import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';

class ProvinceSelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;
  List<VirusDayData> _data;

  ProvinceSelectionDialog (List<String> provinces) {
     provinces.sort((a, b) => a.compareTo(b));
    _dialog = SimpleDialog(
      title: const Text('Choose a province', style: TextStyle(color: Color(0xFFDDDDDD))),
      backgroundColor: CustomPalette.background[500],
      children: provinces.map((String p) => ListTile(
        title: Text(p == '' ? "Home country" : p, style: TextStyle(color: CustomPalette.text[400])),
        onTap: () {
          Provider.of<VirusGraphModel>(_context).setProvince(p, _data);
          Navigator.pop(_context);
        },
      )).toList()
    );
  }

  void show (BuildContext context, List<VirusDayData> data) {
    this._context = context;
    this._data = data;

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
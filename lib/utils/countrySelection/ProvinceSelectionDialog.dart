import 'package:flutter/material.dart';

class ProvinceSelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;

  ProvinceSelectionDialog (List<String> provinces) {
    _dialog = SimpleDialog(
      title: const Text('Choose a province'),
      children: provinces.map((String p) => ListTile(
        title: Text(p),
        onTap: () {
          Navigator.pop(_context);
          print(p);
        },
      )).toList()
    );
  }

  void show (BuildContext context) {
    this._context = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _dialog;
      },
    );
  }
}
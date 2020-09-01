import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class ProvinceSelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;

  ProvinceSelectionDialog (List<String> provinces) {
    _dialog = SimpleDialog(
      title: const Text('Choose a province'),
      children: provinces.map((String p) => ListTile(
        title: Text(p),
        onTap: () {
          Provider.of<VirusGraphModel>(_context).setProvince(p);
          Navigator.pop(_context);
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
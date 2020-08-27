import 'package:flutter/material.dart';

class ProvinceSelectionDialog {
  SimpleDialog dialog;
  ProvinceSelectionDialog (List<String> provinces) {
    dialog = SimpleDialog(
      title: const Text('Choose a province'),
      children: provinces.map((String p) => SimpleDialogOption(
        child: Text(p),
      )).toList()
    );
  }

  void show (BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
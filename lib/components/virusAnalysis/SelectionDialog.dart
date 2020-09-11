import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

/// Fullscreen dialog enabling user to select an element among a list given
/// at the class constructor.
class SelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;
  Function _selectionCallback;

  SelectionDialog
      (String title, List<String> elements, {@required Function selectionCallback}) {

     elements.sort((a, b) => a.compareTo(b));
    _dialog = SimpleDialog(
      title: Text(title, style: TextStyle(color: Color(0xFFDDDDDD))),
      backgroundColor: CustomPalette.background[500],
      children: elements.map((String element) => ListTile(
        title: Text(element == '' ? "Home country" : element, style: TextStyle(color: CustomPalette.text[400])),
        onTap: () {
          this._selectionCallback(element);
          Navigator.pop(_context);
        },
      )).toList()
    );
    _selectionCallback = selectionCallback;
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
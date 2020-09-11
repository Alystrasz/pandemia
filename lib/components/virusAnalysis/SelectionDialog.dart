import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/utils/CustomPalette.dart';

/// Fullscreen dialog enabling user to select an element among a list given
/// at the class constructor.
class SelectionDialog {
  SimpleDialog _dialog;
  BuildContext _context;
  Function _selectionCallback;

  SelectionDialog
      ({@required String title, @required List<String> elements,
      @required Function selectionCallback, @required BuildContext context}) {

     elements.sort((a, b) => a.compareTo(b));
    _dialog = SimpleDialog(
      title: Text(title, style: TextStyle(color: Color(0xFFDDDDDD))),
      backgroundColor: CustomPalette.background[500],
      children: elements.map((String element) => ListTile(
        title: Text(element == '' ?
          FlutterI18n.translate(context, "virus_progression_home_country") :
          element, style: TextStyle(color: CustomPalette.text[400])),
        onTap: () {
          this._selectionCallback(element);
          Navigator.pop(_context);
        },
      )).toList()
    );
    _selectionCallback = selectionCallback;
    _context = context;
  }

  void show () {
    showDialog(
      context: _context,
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
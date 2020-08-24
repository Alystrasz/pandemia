import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

/// List tile allowing the user to update its country to ensure better virus
/// exposition computation results.
class CountrySelectionTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CountrySelectionTileState();
  }
}

class _CountrySelectionTileState extends State<CountrySelectionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _setNewCountryValue('hola'),
      leading: new Icon(Icons.map),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: new Text(
          "Country"
      ),
      subtitle: Text(
          "Please select your country to ensure better virus exposition computation results."
      ),
      //trailing: Switch(value: _value, onChanged: (bool newValue) => _setNewValue(newValue)),
    );
  }

  void _setNewCountryValue(String value) {
    print(value);
  }
}
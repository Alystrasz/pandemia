import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/utils/information/countrySelection/Covid19ApiParser.dart';

/// List tile allowing the user to update its country to ensure better virus
/// exposition computation results.
class CountrySelectionTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CountrySelectionTileState();
  }
}

class _CountrySelectionTileState extends State<CountrySelectionTile> {
  String _value = "fr_FR";
  Covid19ApiParser _parser = new Covid19ApiParser();

  @override
  Widget build(BuildContext context) {
    _parser.getCountries();

    return ListTile(
      leading: new Icon(Icons.map),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: new Text(
          "Country"
      ),
      subtitle: Text(
          "Please select your country to ensure better virus exposition computation results."
      ),
      trailing: DropdownButton(
          value: _value,
          items: [
            DropdownMenuItem(
              child: Text("France"),
              value: 'fr_FR',
            ),
            DropdownMenuItem(
              child: Text("United Kingdom"),
              value: 'UK',
            ),
          ],
          onChanged: (value) => _setNewCountryValue(value)
      ),
    );
  }

  void _setNewCountryValue (String value) {
    print(value);
    setState(() {
      _value = value;
    });
  }
}
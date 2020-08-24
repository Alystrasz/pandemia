import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/utils/information/countrySelection/Country.dart';
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
  String _value = "FR";
  Covid19ApiParser _parser = new Covid19ApiParser();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: new Icon(Icons.map),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: new Text(
          "Country"
      ),
      subtitle: Text(
          "Please select your country to ensure better virus exposition computation results."
      ),
      trailing: FutureBuilder<List<Country>>(
        future: _parser.getCountries(),
        builder: (context, AsyncSnapshot<List<Country>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            List<DropdownMenuItem> _items = new List();
            print('c' + snapshot.data.length.toString());
            for (Country c in snapshot.data) {
              // print(c.identifier);
              _items.add(DropdownMenuItem (
                child: Text(c.name),
                value: c.identifier
              ));
            }
            print(_items.length);
            return DropdownButton(
                value: _value,
                items: _items,
                onChanged: (value) => _setNewCountryValue(value)
            );
          }
        }
      )
    );
  }

  void _setNewCountryValue (String value) {
    setState(() {
      _value = value;
    });
  }
}
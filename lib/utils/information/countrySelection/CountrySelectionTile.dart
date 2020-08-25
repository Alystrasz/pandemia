import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/information/countrySelection/Country.dart';
import 'package:pandemia/utils/information/countrySelection/Covid19ApiParser.dart';

import '../../CustomPalette.dart';

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
    return Container (
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Stack (
        children: <Widget>[
          Container(
            color: CustomPalette.background[600],
            child: Stack (
              children: <Widget>[
                Container(
                  child: new Text(
                    'Country',
                    style: TextStyle(
                        color: CustomPalette.text[100],
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  padding: EdgeInsets.all(10.0),
                ),

                Container(
                    child: new Text(
                      "Please select your country to ensure better virus exposition computation results.",
                      style: TextStyle(
                          color: CustomPalette.text[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
                ),

                Container (
                  width: 5000,
                    padding: EdgeInsets.only(top: 100.0, bottom: 20),
                  child: FutureBuilder<List<dynamic>>(
                      future: _parser.getCountries(),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          List<DropdownMenuItem> _items = new List();
                          for (dynamic c in snapshot.data) {
                            _items.add(DropdownMenuItem (
                                child: Text(c['name']),
                                value: c['identifier']
                            ));
                          }
                          return Container (
                            width: 100,
                            child: Flex (
                              direction: Axis.vertical,
                              children: <Widget>[
                                DropdownButton(
                                    style: TextStyle(color: CustomPalette.text[400], fontSize: 14),
                                    dropdownColor: CustomPalette.background[500],
                                    value: _value,
                                    items: _items,
                                    isDense: true,
                                    onChanged: (value) => _setNewCountryValue(value),
                                )
                              ],),
                          );
                        }
                      }
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setNewCountryValue (String value) {
    setState(() {
      _value = value;
    });
  }
}
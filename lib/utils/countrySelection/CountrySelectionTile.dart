import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/Covid19ApiParser.dart';
import 'package:provider/provider.dart';


/// List tile allowing the user to update its country to ensure better virus
/// exposition computation results.
class CountrySelectionTile extends StatefulWidget {
  static String selectedProvinceKey = "fav-province";

  @override
  State<StatefulWidget> createState() {
    return _CountrySelectionTileState();
  }
}

class _CountrySelectionTileState extends State<CountrySelectionTile> {
  String _value = "";
  Covid19ApiParser _parser = new Covid19ApiParser();
  final LocalStorage _storage = new LocalStorage('pandemia_app.json');
  final String _selectedCountryKey = "fav-country";

  @override
  void initState() {
    super.initState();
    _loadFavoriteCountry();
  }

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
                        fontSize: 18,
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
                          fontSize: 16,
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

  void _setNewCountryValue (String value) async {
    setState(() {
      _value = value;
    });
    _storage.setItem(_selectedCountryKey, _value);
    _storage.setItem(CountrySelectionTile.selectedProvinceKey, null);
    Provider.of<VirusGraphModel>(context, listen: false).setSelectedCountry(value);
  }

  void _loadFavoriteCountry () async {
    await _storage.ready;
    String result = _storage.getItem(_selectedCountryKey);
    String province = _storage.getItem(CountrySelectionTile.selectedProvinceKey);
    setState(() {
      _value =  result == null ? 'united-kingdom' : result;
    });
    Provider.of<VirusGraphModel>(context, listen: false)
        .init(_value, province == null ? '' : province);
  }
}
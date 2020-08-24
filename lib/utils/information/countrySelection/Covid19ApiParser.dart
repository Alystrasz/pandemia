import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/information/countrySelection/Country.dart';

class Covid19ApiParser {
    List<Country> countries = new List();
    final LocalStorage _storage = new LocalStorage('pandemia_app.json');
    final String _countriesKey = 'countries';

    Future<bool> hasDownloadedCountries () async {
      await _storage.ready;
      var countries = _storage.getItem(_countriesKey);
      print(countries);
    }

    Future<void> getCountries () async {
      String url = "https://api.covid19api.com/countries";
      String encodedUrl = Uri.encodeFull(url);

      var response = await http.get(encodedUrl);
      var decoded = json.decode(response.body);
      for (var country in decoded) {
        countries.add( Country(name: country['Country'], identifier: country['ISO2']) );
      }

      await _storage.ready;
      _storage.setItem(_countriesKey, countries);
    }
}
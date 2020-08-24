import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/information/countrySelection/Country.dart';


/// This class allows to access information from a Covid-19 API.
/// https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest
class Covid19ApiParser {
    List<Country> countries = new List();
    final LocalStorage _storage = new LocalStorage('pandemia_app.json');
    final String _countriesKey = 'countries';

    /// Are countries locally stored or not?
    Future<bool> _hasDownloadedCountries () async {
      await _storage.ready;
      var countries = await _storage.getItem(_countriesKey);
      return countries != null;
    }

    /// Download all available countries and stores them locally.
    Future<List<Country>> _downloadCountries () async {
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

    /// Returns a list of all selectable countries from Covid-19 API.
    Future<List<Country>> getCountries () async {
      return [
        Country (name: 'France', identifier: 'FR'),
        Country (name: 'United Kingdom', identifier: 'GB')
      ];
    }
}
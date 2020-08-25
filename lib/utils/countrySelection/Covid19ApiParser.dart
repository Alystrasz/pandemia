import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/Country.dart';


/// This class allows to access information from a Covid-19 API.
/// https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest
class Covid19ApiParser {
    final LocalStorage _storage = new LocalStorage('pandemia_app.json');
    final String _countriesKey = 'countries';

    /// Are countries locally stored or not?
    Future<bool> _hasDownloadedCountries () async {
      var countries = await _storage.getItem(_countriesKey);
      return countries != null;
    }

    /// Download all available countries and stores them locally.
    Future<void> _downloadCountries () async {
      String url = "https://api.covid19api.com/countries";
      String encodedUrl = Uri.encodeFull(url);

      var response = await http.get(encodedUrl);
      var json = jsonDecode(response.body) as List;
      List<Country> countries = json.map((tagJson) =>
          Country.fromApi(tagJson)).toList();

      print(countries.length.toString() + ' countries stored');
      _storage.setItem(_countriesKey, countries);
    }

    /// Returns a list of all selectable countries from Covid-19 API.
    /// TODO type strongly
    Future<List<dynamic>> getCountries () async {
      await _storage.ready;

      if (!(await _hasDownloadedCountries())) {
        await _downloadCountries();
      }

      var countries = await _storage.getItem(_countriesKey);
      countries.sort((a, b) {
        return a['name'].toString().compareTo(b['name'].toString());
      });
      return countries;
    }


    /// Returns pandemia details for a given country.
    Future<void> getCountryData (String countrySlug) async {
      String url = "https://api.covid19api.com/dayone/country/$countrySlug";
      String encodedUrl = Uri.encodeFull(url);

      var response = await http.get(encodedUrl);
      var json = jsonDecode(response.body) as List;
      print(json);

      return null;
    }
}
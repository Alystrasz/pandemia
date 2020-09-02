import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/Country.dart';
import 'package:pandemia/utils/countrySelection/CountryCache.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';


/// This class allows to access information from a Covid-19 API.
/// https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest
class Covid19ApiParser {
    final CountryCache _cache = new CountryCache();
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
    Future<List<Country>> getCountries () async {
      await _storage.ready;

      if (!(await _hasDownloadedCountries())) {
        await _downloadCountries();
      }

      List<dynamic> countries = await _storage.getItem(_countriesKey);
      countries.sort((a, b) {
        return a['name'].toString().compareTo(b['name'].toString());
      });

      return countries.map((e) => Country.fromJson(e)).toList();
    }


    /// Returns pandemia details for a given country.
    Future<List<VirusDayData>> getCountryData (String countrySlug) async {
      if (countrySlug == '') {
        return null;
      }

      List<VirusDayData> data = await _cache.retrieveCountryData(countrySlug);
      if (data != null) {
        return data;
      }

      String url = "https://api.covid19api.com/dayone/country/$countrySlug";
      String encodedUrl = Uri.encodeFull(url);
      print('hitting $url');

      var response = await http.get(encodedUrl).timeout(Duration(seconds: 10), onTimeout: () {
        Fluttertoast.showToast(
            msg: "API connection failed. Please try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: 16.0
        );
        return new http.Response("timeout", 504);
      });
      var json = jsonDecode(response.body) as List;
      data = json.map((dataJson) =>
        VirusDayData.fromApi(dataJson)).toList();

      _cache.storeCountryData(countrySlug, data);
      return data;
    }
}
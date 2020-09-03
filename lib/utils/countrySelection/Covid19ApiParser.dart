import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/countrySelection/Country.dart';
import 'package:pandemia/utils/countrySelection/CountryCache.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';


/// This class allows to access information from a Covid-19 API.
/// https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest
class Covid19ApiParser {
    final CountryCache _cache = new CountryCache();
    final LocalStorage _storage = new LocalStorage('pandemia_app.json');

    /// Are countries locally stored or not?
    Future<bool> _hasDownloadedCountries () async {
      return await _cache.hasDownloadedCountryNames();
    }

    /// Download all available countries and stores them locally.
    Future<void> _downloadCountries () async {
      String url = "https://api.covid19api.com/countries";
      String encodedUrl = Uri.encodeFull(url);

      var response = await http.get(encodedUrl);
      var json = jsonDecode(response.body) as List;
      List<Country> countries = json.map((tagJson) =>
          Country.fromApi(tagJson)).toList();
      _cache.storeCountryNames(countries);
    }

    /// Returns a list of all selectable countries from Covid-19 API.
    Future<List<Country>> getCountries () async {
      await _storage.ready;

      if (!(await _hasDownloadedCountries())) {
        await _downloadCountries();
      }

      List<dynamic> data = await _cache.getCountryNames();
      data.sort((a, b) {
        return a['name'].toString().compareTo(b['name'].toString());
      });
      List<Country> countries = data.map((e) => Country.fromJson(e)).toList();

      // removing countries listed as province under another country
      List<String> duplicatedCountriesNames = [
        'Anguilla',
        'Aruba',
        'Bermuda',
        'British Virgin Islands',
        'Cayman Islands',
        'Falkland Islands (Malvinas)',
        'French Guiana',
        'French Polynesia',
        'Gibraltar',
        'Greenland',
        'Guadeloupe',
        'Isle of Man',
        'Martinique',
        'Mayotte',
        'Montserrat',
        'New Caledonia',
        'Réunion',
        'Saint-Barthélemy',
        'Saint Pierre and Miquelon',
        'Saint-Martin (French part)',
        'Turks and Caicos Islands'
      ];
      for (var i=0, len=countries.length; i<len; i++) {
        Country c = countries[i];
        if (duplicatedCountriesNames.contains(c.name)) {
          countries.remove(c);
          i -= 1;
          len -= 1;
        }
      }

      return countries;
    }


    /// Returns pandemia details for a given country.
    Future<List<VirusDayData>> getCountryData (BuildContext context) async {
      VirusGraphModel model = Provider.of<VirusGraphModel>(context);
      String countrySlug = model.selectedCountry;
      String province = model.province;

      if (countrySlug == null) {
        countrySlug = VirusGraphModel.defaultCountry;
        province = VirusGraphModel.defaultProvince;
      }

      if (countrySlug == '') {
        return null;
      }

      List<VirusDayData> data = await _cache.retrieveCountryData(countrySlug);
      if (data != null) {
        Provider.of<VirusGraphModel>(context).setData(data);
        return data;
      }

      Provider.of<VirusGraphModel>(context).startParsing();

      String url = "https://api.covid19api.com/dayone/country/$countrySlug";
      String encodedUrl = Uri.encodeFull(url);
      print('hitting $url');
      var request = http.get(encodedUrl);

      if (countrySlug != 'united-states') {
        request.timeout(Duration(seconds: 10), onTimeout: () {
          Fluttertoast.showToast(
              msg: "API connection failed. Please try again later.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              fontSize: 16.0
          );
          return new http.Response("timeout", 504);
        });
      } else {
        Fluttertoast.showToast(
            msg: "US data might take some time to download.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: 16.0
        );
      }

      var response = await request;
      var json = jsonDecode(response.body) as List;
      data = json.map((dataJson) =>
        VirusDayData.fromApi(dataJson)).toList();

      List<VirusDayData> graphSeries =
        province != null ?
        data.where((VirusDayData d) => d.province == province).toList() :
        data;

      _cache.storeCountryData(countrySlug, data);
      Provider.of<VirusGraphModel>(context).setData(data);
      return graphSeries;
    }
}
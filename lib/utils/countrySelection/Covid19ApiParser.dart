import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/data/state/DatasetDownloadModel.dart';
import 'package:pandemia/data/state/VirusGraphModel.dart';
import 'package:pandemia/utils/countrySelection/CacheDataPayload.dart';
import 'package:pandemia/utils/countrySelection/Country.dart';
import 'package:pandemia/utils/countrySelection/CountryCache.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';
import 'package:provider/provider.dart';


/// This class allows to access information from a Covid-19 API.
/// https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest
class Covid19ApiParser {
    final CountryCache _cache = new CountryCache();
    final LocalStorage _storage = new LocalStorage('pandemia_app.json');
    http.Client _client;

    Covid19ApiParser({http.Client client}) {
      this._client = client != null ? client : http.Client();
    }

    /// Are countries locally stored or not?
    Future<bool> _hasDownloadedCountries () async {
      return await _cache.hasDownloadedCountryNames();
    }

    /// Download all available countries and stores them locally.
    Future<void> _downloadCountries () async {
      String url = "https://api.covid19api.com/countries";
      String encodedUrl = Uri.encodeFull(url);

      var response = await this._client.get(encodedUrl);
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
        'Hong Kong, SAR China',
        'Isle of Man',
        'Macao',
        'Martinique',
        'Mayotte',
        'Montserrat',
        'New Caledonia',
        'Northern Mariana Islands',
        'Réunion',
        'Saint-Barthélemy',
        'Saint Pierre and Miquelon',
        'Saint-Martin (French part)',
        'Turks and Caicos Islands',
        'Virgin Islands, US'
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
      VirusGraphModel model = Provider.of<VirusGraphModel>(context, listen: false);
      Provider.of<VirusGraphModel>(context, listen: false).startParsing();
      String countrySlug = model.selectedCountry;

      // load default values at first start
      if (countrySlug == null) {
        Provider.of<VirusGraphModel>(context, listen: false).setSelectedCountry(VirusGraphModel.defaultCountry, context);
        Provider.of<VirusGraphModel>(context, listen: false).setProvince(VirusGraphModel.defaultProvince, true);
        return VirusGraphModel.parser.getCountryData(context);
      }

      if (countrySlug == '') {
        return null;
      }

      // checking if cache has valid data
      CacheDataPayload cacheData = await _cache.retrieveCountryData(countrySlug);
      if (cacheData.hasData && cacheData.isUpToDate) {
        Provider.of<VirusGraphModel>(context, listen: false).setData(cacheData.data);
        return cacheData.data;
      } else if (cacheData.hasData && !cacheData.isUpToDate) {
        return await this._getMissingData(countrySlug, cacheData, context);
      }

      if (countrySlug == 'united-states') {
        return _downloadUSData(context);
      }

      String url = "https://api.covid19api.com/dayone/country/$countrySlug";
      String encodedUrl = Uri.encodeFull(url);
      print('hitting $url');
      var request = this._client.get(encodedUrl);
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

      var response = await request;
      var json = jsonDecode(response.body) as List;
      List<VirusDayData> data = json.map((dataJson) =>
        VirusDayData.fromApi(dataJson)).toList();

      _cache.storeCountryData(countrySlug, data);
      Provider.of<VirusGraphModel>(context, listen: false).setData(data);
      return data;
    }

    Future<List<VirusDayData>> _getMissingData (
        String countrySlug,
        CacheDataPayload cached,
        BuildContext context) async {

      DateFormat formatter = DateFormat("yyyy-MM-dd");
      print('last known data is from ${cached.lastKnownDataTime}');
      String url = "https://api.covid19api.com/country/$countrySlug"
          "?from=${formatter.format(cached.lastKnownDataTime.add(Duration(days: 1)))}"
          "&to=${formatter.format(DateTime.now())}";
      String encodedUrl = Uri.encodeFull(url);
      print('hitting $encodedUrl');
      var request = this._client.get(encodedUrl);
      var response = await request;
      var json = jsonDecode(response.body) as List;

      List<VirusDayData> newData = json.map((dataJson) =>
          VirusDayData.fromApi(dataJson)).toList();
      List<VirusDayData> completeData = cached.data;
      completeData.addAll(newData);
      print('parsed and adding ${newData.length} new data elements');

      _cache.storeCountryData(countrySlug, completeData);
      Provider.of<VirusGraphModel>(context, listen: false).setData(completeData);
      return completeData;
    }

    Future<List<VirusDayData>> _downloadUSData (BuildContext context) async {
      print('downloading US data...');
      Provider.of<DatasetDownloadModel>(context).setValue(null);

      Fluttertoast.showToast(
          msg: "US data might take some time to download.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          fontSize: 16.0
      );

      DateTime
        firstDataDate = DateTime.parse("2020-01-22T00:00:00Z"),
        now = DateTime.now();
      int counter = 0;
      final int
        downloadsCount = 15,
        totalDaysCount = now.difference(firstDataDate).inDays,
        windowDaysLength = (totalDaysCount/downloadsCount).floor();

      DateFormat formatter = DateFormat("yyyy-MM-dd");
      String url = "";
      List<VirusDayData> results = [];

      for (int i=0; i<downloadsCount; i++) {
        DateTime
          fromDate = firstDataDate.add(Duration(days: i*windowDaysLength)),
          toDate = fromDate.add(Duration(days: windowDaysLength-1));
        url = "https://api.covid19api.com/country/united-states"
            "?from=${formatter.format(fromDate)}"
            "&to=${formatter.format(toDate)}";

        print("hitting $url");
        var request = this._client.get(Uri.parse(url));
        var response = await request;
        var json = jsonDecode(response.body) as List;
        results.addAll(json.map((dataJson) =>
            VirusDayData.fromApi(dataJson)).toList());
        Provider.of<DatasetDownloadModel>(context).setValue(++counter/downloadsCount);
      }

      // download last data window (which size is smaller than windowDaysLength)
      DateTime fromDate = firstDataDate.add(Duration(days: downloadsCount*windowDaysLength));
      url = "https://api.covid19api.com/country/united-states"
          "?from=${formatter.format(fromDate)}"
          "&to=${formatter.format(now)}";

      print("hitting $url");
      var request = this._client.get(Uri.parse(url));
      var response = await request;
      var json = jsonDecode(response.body) as List;
      results.addAll(json.map((dataJson) =>
          VirusDayData.fromApi(dataJson)).toList());
      Provider.of<DatasetDownloadModel>(context).setValue(2); //ending

      _cache.storeCountryData('united-states', results);
      Provider.of<VirusGraphModel>(context, listen: false).setData(results);
      return results;
    }
}
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/Covid19ApiParser.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";
  String province = "";
  static final defaultCountry = 'france';
  static final defaultProvince = '';

  final LocalStorage _storage = new LocalStorage('pandemia_app.json');
  final String _selectedCountryKey = "fav-country";
  final String _selectedProvinceKey = "fav-province";

  Covid19ApiParser parser = new Covid19ApiParser();
  // This field is used when a country have several provinces, to avoid doing
  // an additional http call to filter data.
  List<VirusDayData> _data;
  

  setSelectedCountry (String value) {
    this.selectedCountry = value;
    this.province = null;
    _storage.setItem(_selectedCountryKey, value);
    _storage.setItem(_selectedProvinceKey, null);
    notifyListeners();
  }

  setProvince (String value, List<VirusDayData> countryData) {
    this.province = value;
    this._data = countryData;

    _storage.setItem(_selectedProvinceKey, value);
    notifyListeners();
  }

  Future<String> init () async {
    await _storage.ready;
    String result = _storage.getItem(_selectedCountryKey);
    String province = _storage.getItem(_selectedProvinceKey);
    this.selectedCountry = result;
    this.province = province == null ? '' : province;

    this.selectedCountry = result;
    this.province = province;
    notifyListeners();

    return result;
  }

  /// Returns data for the current saved country+province.
  /// Is called each time a country is selected by the user.
  Future<List<VirusDayData>> update () async {
    // load default values at first start
    if (this.selectedCountry == null) {
      this.selectedCountry = defaultCountry;
      this.province = defaultProvince;
    }

    List<VirusDayData> series = _data != null ? _data : await parser.getCountryData(this.selectedCountry);
    _data = null;
    List<VirusDayData> graphSeries =
      this.province != null ?
        series.where((VirusDayData d) => d.province == province).toList() :
        series;

    // TODO US data is sorted by town, we don't need such a little level of granularity
    Map<String, VirusDayData> regroupedSeries = new Map();
    for (VirusDayData data in series) {
      String key = data.time.toIso8601String();
      if (!regroupedSeries.containsKey(key)) {
        regroupedSeries[key] = VirusDayData();
      }
      // TODO add current data to mapped data
    }

    return graphSeries;
  }

  String toString () {
    return "VirusGraphModel {selectedCountry: $selectedCountry, province: $province}";
  }
}
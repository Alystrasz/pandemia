import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/Covid19ApiParser.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";
  String province = "";

  final LocalStorage _storage = new LocalStorage('pandemia_app.json');
  final String _selectedCountryKey = "fav-country";
  final String _selectedProvinceKey = "fav-province";

  Covid19ApiParser parser = new Covid19ApiParser();
  

  setSelectedCountry (String value) {
    this.selectedCountry = value;
    this.province = null;
    _storage.setItem(_selectedCountryKey, value);
    _storage.setItem(_selectedProvinceKey, null);
    notifyListeners();
  }

  setProvince (String value) {
    this.province = value;
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
  Future<List<VirusDayData>> update () async {
    List<VirusDayData> series = await parser.getCountryData(this.selectedCountry);
    List<VirusDayData> graphSeries =
      this.province != null ?
        series.where((VirusDayData d) => d.province == province).toList() :
        series;
    return graphSeries;
  }

  String toString () {
    return "VirusGraphModel {selectedCountry: $selectedCountry, province: $province}";
  }
}
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";
  String province = "";

  final LocalStorage _storage = new LocalStorage('pandemia_app.json');
  final String _selectedCountryKey = "fav-country";
  final String _selectedProvinceKey = "fav-province";

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

  String toString () {
    return "VirusGraphModel {selectedCountry: $selectedCountry, province: $province}";
  }
}
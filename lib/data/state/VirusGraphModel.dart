import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/Covid19ApiParser.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";
  String province = "";
  String city;
  static final defaultCountry = 'france';
  static final defaultProvince = '';

  final LocalStorage _storage = new LocalStorage('pandemia_app.json');
  final String _selectedCountryKey = "fav-country";
  final String _selectedProvinceKey = "fav-province";

  static final Covid19ApiParser parser = new Covid19ApiParser();
  bool isParsingData = true;
  List<VirusDayData> currentData = List();
  bool isSilent = false;
  

  setSelectedCountry (String value, BuildContext context) {
    this.selectedCountry = value;
    this.province = null;
    this.city = null;
    _storage.setItem(_selectedCountryKey, value);
    _storage.setItem(_selectedProvinceKey, null);
    parser.getCountryData(context);
  }

  setProvince (String value, bool shouldNotifyListeners) {
    this.province = value;
    _storage.setItem(_selectedProvinceKey, value);
    this.currentData = filterDataByProvince(this.currentData, province);

    if (shouldNotifyListeners && !isSilent)
      notifyListeners();
  }

  setCity (String value) {
    this.city = value;
    if (!isSilent)
      notifyListeners();
  }

  startParsing () {
    this.isParsingData = true;
    this.currentData = null;
    if (!isSilent)
      notifyListeners();
  }

  setData (List<VirusDayData> data) {
    this.isParsingData = false;
    this.currentData = filterDataByProvince(data, province);
    if (!isSilent)
      notifyListeners();
  }

  static List<VirusDayData> filterDataByProvince (List<VirusDayData> data, String province) {
    if (data == null) {
      return null;
    }

    List<VirusDayData> tmp = province != null ?
      data.where((VirusDayData d) => d.province == province).toList() :
      data;

    List<String> cityNames = List();
    for (VirusDayData d in tmp) {
      if (!cityNames.contains(d.city)) {
        cityNames.add(d.city);
      }
    }

    if (cityNames.length > 1)
      print('need to be sorted by city');

    return tmp;
  }

  Future<String> init (BuildContext context) async {
    await _storage.ready;
    String result = _storage.getItem(_selectedCountryKey);
    String province = _storage.getItem(_selectedProvinceKey);
    this.selectedCountry = result;
    this.province = province == null ? '' : province;

    this.selectedCountry = result;
    this.province = province;
    if (!isSilent)
      notifyListeners();

    await parser.getCountryData(context);
    return result;
  }

  Future<List<VirusDayData>> silentInit (BuildContext context) async {
    this.isSilent = true;

    await _storage.ready;
    String result = _storage.getItem(_selectedCountryKey);
    String province = _storage.getItem(_selectedProvinceKey);
    this.selectedCountry = result;
    this.province = province == null ? '' : province;

    this.selectedCountry = result;
    this.province = province;

    var data = await parser.getCountryData(context);
    this.isSilent = false;

    return data;
  }

  String toString () {
    return "VirusGraphModel "
        "{selectedCountry: $selectedCountry, province: $province, isParsing: $isParsingData}";
  }
}
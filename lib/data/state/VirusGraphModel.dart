import 'package:flutter/cupertino.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";
  String province = "";

  setSelectedCountry (String value) {
    this.selectedCountry = value;
    this.province = null;
    notifyListeners();
  }

  setProvince (String value) {
    this.province = value;
    notifyListeners();
  }

  String toString () {
    return "VirusGraphModel {selectedCountry: $selectedCountry, province: $province}";
  }
}
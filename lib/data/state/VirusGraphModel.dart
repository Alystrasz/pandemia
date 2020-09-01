import 'package:flutter/cupertino.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";
  String province = "";

  setSelectedCountry (String value) {
    this.selectedCountry = value;
    notifyListeners();
  }

  setProvince (String value) {
    this.province = value;
    notifyListeners();
  }
}
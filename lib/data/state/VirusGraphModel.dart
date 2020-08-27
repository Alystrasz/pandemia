import 'package:flutter/cupertino.dart';

/// Holds data used while drawing virus progression graph.
class VirusGraphModel extends ChangeNotifier {
  String selectedCountry = "";

  setSelectedCountry (String value) {
    this.selectedCountry = value;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';

class DatasetDownloadModel extends ChangeNotifier {
  double downloadedValue;
  bool isDone = true;

  setValue (double value) {
    this.downloadedValue = value;
    this.isDone = value == 2;
    notifyListeners();
  }
}
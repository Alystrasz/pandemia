import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:provider/provider.dart';
import 'package:pandemia/data/database/models/Location.dart' as L;

import 'models/dataCollect.dart';
var database = new AppDatabase();

/// This is responsible for generating daily pandemia reports.
class IndicatorsComputer {
  // since generateRandomReport is called several times (because of builds),
  // we need to be able to block further calls
  var generated = false;

  // TODO what does this?
  // TODO work only on locations from last 24h
  Future<void> loadVisitedPlaces() async {
    List<L.Location> locations = await database.getLocations();
    for (L.Location location in locations){
      await Geolocator().placemarkFromCoordinates(location.lat, location.lng);
    }
  }

  /// is called several times a day to update today's report
  /// returns the exposition rate of the day
  Future<void> generateRandomReport (BuildContext context) async {
    if (generated) return;
    print('generating report');

    await loadVisitedPlaces();

    print("-------------------------------");
    print(DataCollect.result);
    var result = DataCollect.result <100 ? DataCollect.result.round() : 100;
    var report = new DailyReport(
        timestamp: DailyReport.getTodaysTimestamp(),
        broadcastRate: new Random().nextInt(100),
        expositionRate: result
    );
    await setTodaysReport(report);

    // putting all reports in app model, to share them among other components
    List<DailyReport> reports = await database.getReports();
    Provider.of<AppModel>(context, listen: false).storeReports(reports);

    generated = true;
  }


  Future<void> forceReportRecomputing (BuildContext context) async {
    generated = false;
    await generateRandomReport(context);
  }

  Future<void> setTodaysReport (DailyReport report) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(report.timestamp);

    // if not, insert the argument in db
    if (!exists) {
      await database.insertReport(report);
    }

    // if yes, update the report
    else {
      await database.updateExpositionRate(report);
    }
  }

  Future<bool> updateTodaysExpositionRate (int rate) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(DailyReport.getTodaysTimestamp());
    if (!exists) return false;

    // if yes, update it
    await database.updateTodaysExpositionRate(rate);
    return true;
  }

  Future<bool> updateTodaysBroadcastRate (int rate) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(DailyReport.getTodaysTimestamp());
    if (!exists) return false;

    // if yes, update it
    await database.updateTodaysBroadcastRate(rate);
    return true;
  }
}
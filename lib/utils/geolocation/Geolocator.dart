import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart';

class Geolocator {
  static const String _isolateName = "LocatorIsolate";
  static ReceivePort port = ReceivePort();

  static void launch () {
    init().then((value) {
      BackgroundLocator.registerLocationUpdate(
        Geolocator.callback,
        settings: LocationSettings(
          notificationIcon: 'ic_launcher',
          notificationTitle: "Pandemia",
          notificationMsg: "Registering locations",
          autoStop: false,
          wakeLockTime: 20,
          interval: 60,
        ),
      );
    });
  }

  static Future<void> init () async {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    AppDatabase db = new AppDatabase();
    port.listen((dynamic data) {
      db.insertLocation(
          new Location(
              lat: data.latitude,
              lng: data.longitude,
              timestamp: new DateTime.fromMillisecondsSinceEpoch(data.time.toInt())));
      print('received new location at ${DateTime.fromMillisecondsSinceEpoch(data.time.toInt())}');
    });
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }
}
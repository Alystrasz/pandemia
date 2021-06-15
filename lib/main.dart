import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/data/state/DatasetDownloadModel.dart';
import 'package:pandemia/views/VirusAnalyzeView.dart';
import 'package:pandemia/data/state/MapModel.dart';
import 'package:pandemia/views/home/navigator.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/state/VirusGraphModel.dart';


void main() async {
  await DotEnv().load('lib/.env.generated');
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded<Future<void>>(() async {
    runApp(
      MultiProvider (
        providers: [
          ChangeNotifierProvider(create: (context) => AppModel()),
          ChangeNotifierProvider(create: (context) => VirusGraphModel()),
          ChangeNotifierProvider(create: (context) => MapModel()),
          ChangeNotifierProvider(create: (context) => DatasetDownloadModel())
        ],
        child: MyApp(),
      )
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    new IndicatorsComputer().generateRandomReport(context);

    return MaterialApp(
      title: 'Pandemia',
      home: MyHomePage(),
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            useCountryCode: false
          )
        )
      ],
      routes: <String, WidgetBuilder> {
        '/virus-analyze': (BuildContext context) => VirusAnalyzeView()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}

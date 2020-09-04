import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/navigator.dart';
import 'package:pandemia/views/VirusAnalyzeView.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/state/VirusGraphModel.dart';

void main() async {
  await DotEnv().load('lib/.env.generated');
  runApp(
    MultiProvider (
      providers: [
        ChangeNotifierProvider(create: (context) => AppModel()),
        ChangeNotifierProvider(create: (context) => VirusGraphModel())
      ],
      child: MyApp(),
    )
  );
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

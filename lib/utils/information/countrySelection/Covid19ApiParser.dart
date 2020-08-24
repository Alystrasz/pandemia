import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pandemia/utils/information/countrySelection/Country.dart';

class Covid19ApiParser {
    List<Country> countries = new List();

    Future<void> getCountries () async {
      String url = "https://api.covid19api.com/countries";
      String encodedUrl = Uri.encodeFull(url);

      var response = await http.get(encodedUrl);
      var decoded = json.decode(response.body);
      for (var country in decoded) {
        countries.add( Country(name: country['Country'], identifier: country['ISO2']) );
      }
    }
}
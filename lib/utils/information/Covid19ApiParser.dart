import 'package:http/http.dart' as http;

class Covid19ApiParser {
    Future<void> getCountries () async {
      String url = "https://api.covid19api.com/countries";
      String encodedUrl = Uri.encodeFull(url);

      var response = await http.get(encodedUrl);
      print(response.body);
    }
}
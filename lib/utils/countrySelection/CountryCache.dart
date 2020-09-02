import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Stores country data in a json file locally.
/// TODO transfer countries names handling here
class CountryCache {
  final LocalStorage _storage = new LocalStorage('pandemia_app.json');
  final String _countriesDataPrefix = 'country_data_';

  // returns stored data if it's up to date (= if yesterday is the last day
  // present in data)
  Future<List<VirusDayData>> retrieveCountryData (String countrySlug) async {
    await _storage.ready;
    String key = "$_countriesDataPrefix$countrySlug";
    return _storage.getItem(key);
  }

  storeCountryData (String countrySlug, List<VirusDayData> data) {
    String key = "$_countriesDataPrefix$countrySlug";
    _storage.setItem(key, data);
    print(_storage.getItem(key));
  }
}
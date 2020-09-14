import 'package:localstorage/localstorage.dart';
import 'package:pandemia/utils/countrySelection/CacheDataPayload.dart';
import 'package:pandemia/utils/countrySelection/Country.dart';
import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

/// Stores country data in a json file locally.
class CountryCache {
  LocalStorage _storage;
  LocalStorage _usStorage;
  final String _countriesDataPrefix = 'country_data_';
  final String _countriesKey = 'countries';

  CountryCache([String fileName = 'pandemia_app.json']) {
    this._storage = new LocalStorage('pandemia_app.json');
    this._usStorage = new LocalStorage('us_pandemia_app.json');
  }


  // names handling
  Future<bool> hasDownloadedCountryNames () async {
    await _storage.ready;
    var countries = await _storage.getItem(_countriesKey);
    return countries != null;
  }

  void storeCountryNames (List<Country> countries) {
    _storage.setItem(_countriesKey, countries);
    print(countries.length.toString() + ' countries stored');
  }

  Future<List<dynamic>> getCountryNames () async {
    return await _storage.getItem(_countriesKey);
  }


  // returns stored data if it's up to date (= if yesterday is the last day
  // present in data)
  Future<CacheDataPayload> retrieveCountryData (String countrySlug) async {
    await _storage.ready;
    await _usStorage.ready;
    String key = "$_countriesDataPrefix$countrySlug";
    List<dynamic> data = countrySlug == 'united-states' ?
      _usStorage.getItem(key) : _storage.getItem(key);

    // check if no data is stored or if API does not give data for the country
    if (data == null) {
      print('no data stored for $countrySlug');
      return CacheDataPayload(hasData: false);
    } else if (data.length == 0) {
      print('$countrySlug has no data available from API');
      return CacheDataPayload(hasData: true, data: []);
    }

    VirusDayData lastDateData = VirusDayData.fromJson(data.last);
    final now = DateTime.now();
    DateTime lastKnown =
      DateTime(lastDateData.time.year, lastDateData.time.month-1, lastDateData.time.day);
    int deltaT = lastKnown
        .difference(DateTime(now.year, now.month, now.day)).inDays;

    if (deltaT == -1) {
      print('cached data for $countrySlug is up to date, returning it');
      return CacheDataPayload(
          hasData: true,
          data: data.map((e) => VirusDayData.fromJson(e)).toList(),
          isUpToDate: true
      );
    } else {
      print('cached data for $countrySlug is not valid, need to download it');
      return CacheDataPayload(
          hasData: true,
          data: data.map((e) => VirusDayData.fromJson(e)).toList(),
          isUpToDate: false,
          lastKnownDataTime: lastKnown
      );
    }
  }

  storeCountryData (String countrySlug, List<VirusDayData> data) async {
    await _storage.ready;
    String key = "$_countriesDataPrefix$countrySlug";
    countrySlug == 'united-states' ?
      _usStorage.setItem(key, data) : _storage.setItem(key, data);
  }
}
import 'package:pandemia/utils/countrySelection/CountryCache.dart';
import 'package:test/test.dart';

void main () {
  test('Cache should be empty at start', () async {
    final CountryCache cache = CountryCache();
    expect(
      await cache.hasDownloadedCountryNames(),
      false
    );
  });

  test('Cache should not have data if empty', () async {
    final CountryCache cache = CountryCache();
    expect(await cache.hasDownloadedCountryNames(), false);
    expect(await cache.getCountryNames(), null);
  });
}
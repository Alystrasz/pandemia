import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/utils/countrySelection/Country.dart';

void main () {
  test('Country should be built from API', () {
    final String apiAnswer = '{"Country":"Argentina","Slug":"argentina","ISO2":"AR"}';
    final dynamic json = jsonDecode(apiAnswer);

    final Country c = Country.fromApi(json);
    expect(c.name, 'Argentina');
    expect(c.identifier, 'argentina');
  });

  test('Country should be built from json', () {
    final String stored = '{"name": "Mexico", "identifier": "mexico"}';
    final dynamic json = jsonDecode(stored);

    final Country c = Country.fromJson(json);
    expect(c.name, 'Mexico');
    expect(c.identifier, 'mexico');
  });

  test('Country should convert to json', () {
    final Country c = new Country(name: 'France', identifier: 'france');
    Map json = c.toJson();

    expect(json.keys.length, 2);
    expect(json.containsKey('name'), true);
    expect(json.containsKey('identifier'), true);
    expect(json['name'], 'France');
    expect(json['identifier'], 'france');
  });
}
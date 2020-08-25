class Country {
  final String name;
  final String identifier;  // = API slug

  Country ({this.name, this.identifier});

  Map toJson () => {
    'name': name,
    'identifier': identifier,
  };

  /// Custom builder to keep only needed information
  factory Country.fromApi(dynamic json) {
    return Country(name: json['Country'] as String,
        identifier: json['Slug'] as String);
  }

  factory Country.fromJson(dynamic json) {
    return Country(name: json['name'] as String,
        identifier: json['identifier'] as String);
  }

  String toString () {
    return 'Country {name: $name, identifier: $identifier}';
  }
}
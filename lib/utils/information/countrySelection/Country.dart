class Country {
  final String name;
  final String identifier;

  Country ({this.name, this.identifier});

  Map toJson () => {
    'name': name,
    'identifier': identifier,
  };

  factory Country.fromJson(dynamic json) {
    return Country(name: json['name'] as String,
        identifier: json['identifier'] as String);
  }

  String toString () {
    return 'Country {name: $name, identifier: $identifier}';
  }
}
class VirusDayData {
  final DateTime time;
  final String province;

  final int confirmedCases;
  final int deathCases;
  final int recoveredCases;
  final int activeCases;

  VirusDayData({this.time, this.province, this.confirmedCases, this.deathCases,
      this.recoveredCases, this.activeCases});
  
  factory VirusDayData.fromApi (dynamic data) {
    return new VirusDayData(
      time: DateTime.parse(data['Date']),
      province: data['Province'] as String,
      confirmedCases: data['Confirmed'] as int,
      deathCases: data['Deaths'] as int,
      recoveredCases: data['Recovered'] as int,
      activeCases: data['Active'] as int
    );
  }

  String toString () {
    return "VirusDayData (province: $province, time: $time, confirmedCases: $confirmedCases, "
        "deathCases: $deathCases, recoveredCases: $recoveredCases, "
        "activeCases: $activeCases)";
  }

  factory VirusDayData.fromJson(Map<String, dynamic> json) => VirusDayData(
    time: DateTime.parse(json['time'] as String),
    province: json['province'] as String,
    confirmedCases: json['confirmedCases'] as int,
    deathCases: json['deathCases'] as int,
    recoveredCases: json['recoveredCases'] as int,
    activeCases: json['activeCases'] as int
  );

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'province': province,
    'confirmedCases': confirmedCases,
    'deathCases': deathCases,
    'recoveredCases': recoveredCases,
    'activeCases': activeCases
  };
}
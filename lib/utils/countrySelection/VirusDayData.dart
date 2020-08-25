class VirusDayData {
  final DateTime time;
  final String province;

  final int confirmedCases;
  final int deathCases;
  final int recoveredCases;
  final int activeCases;

  VirusDayData({this.time, this.province, this.confirmedCases, this.deathCases,
      this.recoveredCases, this.activeCases});
}
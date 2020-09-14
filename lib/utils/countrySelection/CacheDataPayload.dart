import 'package:pandemia/utils/countrySelection/VirusDayData.dart';

class CacheDataPayload {
  final bool hasData;
  final List<VirusDayData> data;
  final bool isUpToDate;

  CacheDataPayload({this.hasData, this.data, this.isUpToDate});
}
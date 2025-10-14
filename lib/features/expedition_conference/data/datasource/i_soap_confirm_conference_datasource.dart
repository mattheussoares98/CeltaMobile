abstract class ISoapConfirmConferenceDatasource {
  Future<void> confirm({
    required String baseUrl,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  });
}

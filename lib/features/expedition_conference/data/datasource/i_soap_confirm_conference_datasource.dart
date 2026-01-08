abstract class ISoapConfirmConferenceDatasource {
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  });
}

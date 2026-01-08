abstract class ISoapConfirmConferenceRepository {
  Future<void> confirm({
    required String urlInUse,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  });
}

abstract class ISoapSendToPrintRepository {
  Future<void> send({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String productPackingCode,
    required bool newValue,
  });
}

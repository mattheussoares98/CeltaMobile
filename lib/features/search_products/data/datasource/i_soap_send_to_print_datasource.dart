abstract class ISoapSendToPrintDatasource {
  Future<void> send({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String productPackingCode,
    required bool newValue,
  });
}

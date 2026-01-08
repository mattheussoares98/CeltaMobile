abstract class ISoapSendToPrintDatasource {
  Future<void> send({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productPackingCode,
    required bool newValue,
  });
}

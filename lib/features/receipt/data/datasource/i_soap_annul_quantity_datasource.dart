abstract class ISoapAnnulQuantityDatasource {
  Future<void> annul({
    required String baseUrl,
    required String crossIdentity,
    required int grDocCode,
    required int productgCode,
    required int productPackingCode,
  });
}

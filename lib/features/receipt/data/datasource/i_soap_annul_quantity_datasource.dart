abstract class ISoapAnnulQuantityDatasource {
  Future<void> annul({
    required String workingUrl,
    required String crossIdentity,
    required int grDocCode,
    required int productgCode,
    required int productPackingCode,
  });
}

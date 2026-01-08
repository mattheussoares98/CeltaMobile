abstract class ISoapUpdateProductDatasource {
  Future<void> update({
    required String workingUrl,
    required String crossIdentity,
    required int grDocCode,
    required int productCode,
    required int productPackingCode,
    required double newQuantity,
    required DateTime? newValidityDate,
  });
}

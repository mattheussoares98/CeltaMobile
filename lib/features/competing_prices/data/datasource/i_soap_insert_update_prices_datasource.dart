abstract class ISoapInsertUpdatePricesDatasource {
  Future<void> insert({
    required String baseUrl,
    required String crossIdentity,
    required int researchCode,
    required int concurrentCode,
    required int productPackingCode,
    required String priceLookUp,
    required Map<String, double> pricesMap,
  });
}

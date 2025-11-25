abstract class ISoapInsertUpdatePricesDatasource {
  Future<void> insert({
    required String baseUrl,
    required String crossIdentity,
    required int researchCode,
    required int concurrentCode,
    required int productPackingCode,
    required String priceLookUp,
    required double priceRetail,
    required double offerRetail,
    required double priceWhole,
    required double offerWhole,
    required double priceECommerce,
    required double offerECommerce,
  });
}

import '../../models/models.dart';

abstract class ISoapProductsDataSource {
  Future<List<ProductModel>> getProductsJson({
    required String searchValue,
    required Routine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    int? lastBuyEntranceQuantity,
  });
}

enum Routine {
  generic(0),
  saleRequest(1),
  buyRequest(2),
  transferRequest(3),
  priceConference(4),
  adjustStock(5),
  goodsReceiving(6),
  researchOfPrice(7),
  adjustSalePrice(8),
  buyQuotation(9);

  final int code;
  const Routine(this.code);
}

enum SearchType {
  //* Products
  dynamic(0),
  approximatePersonalizedCode(5),
  approximateLegacyCode(11),
  // exactPriceLookUp(2),
  // exactEan(4),
  // approximateName(6),

  //* Buy quotation
  allProductsFromGoodsReceiving(19),
  allProductsFromGoodsReceivingGoesForBalance(20);

  final int code;
  const SearchType(this.code);
}

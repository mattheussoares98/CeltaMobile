enum SearchType {
  //* Products
  dynamic(0),
  approximatePersonalizedCode(5),
  approximateLegacyCode(11),
  ean(4),
  // exactPriceLookUp(2),
  // exactEan(4),
  // approximateName(6),

  //* Buy quotation
  allProductsFromGoodsReceiving(19),
  allProductsFromGoodsReceivingGoesForBalance(20),
  allCountedProductsFromGoodsReceiving(21);

  final int code;
  const SearchType(this.code);
}

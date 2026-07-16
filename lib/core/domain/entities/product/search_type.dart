enum SearchType {
  dynamic(0),
  exactCode(1),
  exactPriceLookUp(2),
  exactPersonalizedCode(3),
  ean(4),
  approximatePersonalizedCode(5),
  approximateName(6),
  approximateReducedName(7),
  approximateSupplierReference(8),
  approximatePersonalizedCodeOrReducedName(9),
  exactProductPackingChildCode(10),
  approximateLegacyCode(11),
  approximatePersonalizedCodeOfProduct(12),
  exactProductPackingCode(13),
  exactCustomerReference(14),
  exactLegacyCodeOfProduct(15),
  exactProductPackingFatherGrateCode(16),
  exactEanOfProduct(17),
  exactProductFatherGrateCode(18),

  //* Buy quotation
  allProductsFromGR(19),
  allProductsFromGRGoesForBalance(20),
  allCountedProductsFromGR(21);

  final int code;
  const SearchType(this.code);
}

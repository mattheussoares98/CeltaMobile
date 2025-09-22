enum BsRoutine {
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
  const BsRoutine(this.code);
}

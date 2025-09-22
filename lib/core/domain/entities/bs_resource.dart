enum BsResource {
  adjustSalePrice(609, "Ajuste de preços"),
  adjustStock(523, "Ajuste de estoque"),
  buyQuotation(1183, "Cotação de compras"),
  buyRequest(1150, "Pedido de compras"),
  goodsReceiving(1143, "Recebimento de mercadorias"),
  priceConference(611, "Pesquisa de preços"),
  researchOfPrice(585, "Preços concorrentes"),
  saleRequest(739, "Pedido de vendas"),
  transferRequest(582, "Pedido de transferência");

  final int code;
  final String name;
  const BsResource(this.code, this.name);
}

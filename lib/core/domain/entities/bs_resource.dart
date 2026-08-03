// ignore_for_file: library_private_types_in_public_api

enum BsResource {
  adjustStock(523, "Ajuste de estoque"),
  adjustSalePrice(609, "Ajuste de preços"),
  changeSaleRequestPrices(666, "Alterar preços no pedido de vendas"),
  buyQuotation(1183, "Cotação de compras"),
  buyRequest(1150, "Pedido de compras"),
  transferRequest(582, "Pedido de transferência"),
  saleRequest(739, "Pedido de vendas"),
  saleRequestChangeTPrice(666, "Pedido de vendas (alterar preços)"),
  priceConference(611, "Pesquisa de preços"),
  researchOfPrice(585, "Preços concorrentes"),
  synchronizer(632, "Monitor dos serviços de sincronização"),
  synchronizerDelete(633, "Monitor dos serviços de sincronização (exclusão)"),
  goodsReceiving(1143, "Recebimento de mercadorias"),
  processAuthorizationRules(971, "Regras para autorização de processos");

  final int code;
  final String name;
  const BsResource(this.code, this.name);
}

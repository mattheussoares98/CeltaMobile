// ignore_for_file: library_private_types_in_public_api

enum BsResource {
  adjustSalePrice(609, "Ajuste de preços", _Type.module),
  adjustStock(523, "Ajuste de estoque", _Type.module),
  buyQuotation(1183, "Cotação de compras", _Type.module),
  buyRequest(1150, "Pedido de compras", _Type.module),
  changeSaleRequestPrices(
    666,
    "Alterar preços no pedido de vendas",
    _Type.action,
  ),
  goodsReceiving(1143, "Recebimento de mercadorias", _Type.module),
  priceConference(611, "Pesquisa de preços", _Type.module),
  researchOfPrice(585, "Preços concorrentes", _Type.module),
  saleRequest(739, "Pedido de vendas", _Type.module),
  saleRequestChangeTPrice(
    666,
    "Pedido de vendas (alterar preços)",
    _Type.action,
  ),
  transferRequest(582, "Pedido de transferência", _Type.module);

  final int code;
  final String name;
  final _Type permissionType;
  const BsResource(this.code, this.name, this.permissionType);
}

enum _Type { action, module }

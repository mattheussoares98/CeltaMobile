// lib/features/sale_request/domain/entities/bsf/sanitization/bsf_sale_request_sanitization_type.dart

enum BSFSaleRequestSanitizationType {
  paymentsCleared(message: 'As formas de pagamento atuais serão removidas'),
  discountsReset(message: 'Os descontos serão removidos'),
  incrementsReset(message: 'Os acréscimos serão removidos'),
  deliveryTaxReset(message: 'As taxas de entrega serão removidas'),
  customerBlocked(message: 'O cliente selecionado possui bloqueio para vendas'),
  productAutomaticDiscountsRemoved(message: 'Os descontos automáticos do produto serão removidos');

  final String message;

  const BSFSaleRequestSanitizationType({required this.message});
}

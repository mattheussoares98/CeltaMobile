// lib/features/sale_request/domain/entities/bsf/sanitization/bsf_sale_request_sanitization_type.dart

enum BSFSaleRequestSanitizationType {
  paymentsCleared(message: 'As formas de pagamento atuais serão removidas'),
  discountsReset(message: 'Os descontos serão removidos'),
  incrementsReset(message: 'Os acréscimos serão removidos'),
  deliveryTaxReset(message: 'As taxas de entrega serão removidas'),
  resetPrices(message: 'Os preços dos produtos serão recalculados'),
  customerBlocked(message: 'O cliente selecionado possui bloqueio para vendas');

  final String message;

  const BSFSaleRequestSanitizationType({required this.message});
}

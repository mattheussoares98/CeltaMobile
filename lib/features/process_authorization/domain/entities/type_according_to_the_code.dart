import 'dart:developer' as console;

enum TypeAccordingToTheCode {
  goodsReceivingValueDocument(1, 'Valor do documento no recebimento'),
  goodsReceivingCancelDocument(2, 'Cancelamento de documento no recebimento'),
  goodsReceivingLiberateDocument(3, 'Liberação de documento no recebimento'),
  goodsReceivingValidateDocumentXml(
    5,
    'Validação de documento XML no recebimento',
  ),
  goodsReceivingValidatePaymentCondition(
    8,
    'Validação de condição de pagamento no recebimento',
  ),
  saleRequestLucrativity(4, 'Pedido de venda com preço abaixo do mínimo'),
  saleRequestDiscount(7, 'Pedido de venda com desconto acima do permitido');

  final int code;
  final String label;
  const TypeAccordingToTheCode(this.code, this.label);

  static TypeAccordingToTheCode? fromCode(int code) {
    try {
      return TypeAccordingToTheCode.values.firstWhere((e) => e.code == code);
    } catch (error) {
      console.log(
        "######################"
        "Tipo de erro não encontrado para o código: $code"
        "######################",
      );
      return null;
    }
  }
}

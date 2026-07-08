import 'dart:developer' as console;

enum BSFProcessAuthorizationCategoryType {
  receipt(1, 'Recebimento'),
  saleRequest(2, 'Pedido de Venda'),
  expedition(5, 'Expedição'),
  delivery(6, 'Entrega');

  final int code;
  final String label;
  const BSFProcessAuthorizationCategoryType(this.code, this.label);

  static BSFProcessAuthorizationCategoryType? fromCode(int code) {
    try {
      return BSFProcessAuthorizationCategoryType.values.firstWhere(
        (e) => e.code == code,
      );
    } catch (error) {
      console.log(
        "######################"
        "Categoria não encontrada para o código: $code"
        "######################",
      );
      return null;
    }
  }
}

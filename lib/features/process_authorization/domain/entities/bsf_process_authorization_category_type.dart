import 'dart:developer' as console;

import 'package:celta_inventario/utils/extensions/extensions.dart';

enum BSFProcessAuthorizationCategoryType {
  receipt(1),
  saleRequest(2),
  expedition(5),
  delivery(6);

  final int code;

  const BSFProcessAuthorizationCategoryType(this.code);

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

  @override
  String toString() => name.addBrazilianCoin();
}

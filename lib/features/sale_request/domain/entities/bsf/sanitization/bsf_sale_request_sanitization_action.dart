// lib/features/sale_request/domain/entities/bsf/sanitization/bsf_sale_request_sanitization_action.dart

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFSaleRequestSanitizationAction extends Equatable {
  final BSFSaleRequestSanitizationType type;
  final List<String> details;

  const BSFSaleRequestSanitizationAction({
    required this.type,
    this.details = const [],
  });

  String get message {
    if (type == BSFSaleRequestSanitizationType.paymentsCleared &&
        details.isNotEmpty) {
      return 'As seguintes formas de pagamento serão removidas: ${details.join(", ")}';
    }
    if (type == BSFSaleRequestSanitizationType.customerBlocked &&
        details.isNotEmpty) {
      return 'O cliente possui bloqueio para vendas: ${details.join(", ")}';
    }
    return type.message;
  }

  static const discountsReset = BSFSaleRequestSanitizationAction(
    type: BSFSaleRequestSanitizationType.discountsReset,
  );

  static const incrementsReset = BSFSaleRequestSanitizationAction(
    type: BSFSaleRequestSanitizationType.incrementsReset,
  );

  static const deliveryTaxReset = BSFSaleRequestSanitizationAction(
    type: BSFSaleRequestSanitizationType.deliveryTaxReset,
  );

  static const paymentsCleared = BSFSaleRequestSanitizationAction(
    type: BSFSaleRequestSanitizationType.paymentsCleared,
  );

  static const resetPrices = BSFSaleRequestSanitizationAction(
    type: BSFSaleRequestSanitizationType.resetPrices,
  );

  @override
  List<Object?> get props => [type, details];
}

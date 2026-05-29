// lib/features/sale_request/domain/entities/bsf/bsf_sale_request_sanitizer.dart

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

enum BSFSaleRequestSanitizationAction {
  paymentsCleared(message: 'As formas de pagamento atuais serão removidas'),
  discountsReset(message: 'Os descontos serão removidos'),
  incrementsReset(message: 'Os acréscimos serão removidos'),
  deliveryTaxReset(message: 'As taxas de entrega serão removidas');

  final String message;

  const BSFSaleRequestSanitizationAction({required this.message});
}

class BSFSaleRequestSanitizer {
  /// Sanitizes state changes when the request type changes.
  /// Currently just returns the skeleton structure without applying changes.
  static (BSFSaleRequestEntity, List<BSFSaleRequestSanitizationAction>)
  sanitizeRequestTypeChange(
    BSFSaleRequestEntity current,
    BSFRequestTypeEntity newRequestType,
  ) {
    var updatedState = current.copyWith(requestType: newRequestType);

    final salePayments = current.financials?.firstOrNull?.paymentFinalizations;
    final requestTypePayments = newRequestType.paymentFinalizations;

    // Correctly check if wrapper's internal paymentFinalization is not allowed in requestTypePayments
    final paymentsThatMustBeCleaned = salePayments?.where(
      (e) =>
          e.paymentFinalization != null &&
          !(requestTypePayments?.contains(e.paymentFinalization) ?? false),
    ).toList();

    final List<BSFSaleRequestSanitizationAction> actions = [];

    // 1. Sanitize Payments (clear only incompatible ones)
    if (paymentsThatMustBeCleaned?.isNotEmpty ?? false) {
      actions.add(BSFSaleRequestSanitizationAction.paymentsCleared);
      final financials = List<BSFFinancialEntity>.from(updatedState.financials ?? []);
      if (financials.isNotEmpty) {
        financials[0] = financials[0].copyWith(
          paymentFinalizations: salePayments
              ?.where((e) => !paymentsThatMustBeCleaned!.contains(e))
              .toList(),
        );
      }
      updatedState = updatedState.copyWith(financials: financials);
    }

    // 2. Sanitize Discounts
    if (newRequestType.allowUseDiscount != true && current.totalDiscount > 0) {
      actions.add(BSFSaleRequestSanitizationAction.discountsReset);
      updatedState = updatedState.copyWith(discounts: const []);
    }

    // 3. Sanitize Increments
    if (newRequestType.allowUseIncrement != true && current.totalIncrement > 0) {
      actions.add(BSFSaleRequestSanitizationAction.incrementsReset);
      updatedState = updatedState.copyWith(annulIncrement: true);
    }

    // 4. Sanitize Delivery Tax (Freight)
    if (newRequestType.allowUseDeliveryTax != true && current.totalFreight > 0) {
      actions.add(BSFSaleRequestSanitizationAction.deliveryTaxReset);
      updatedState = updatedState.copyWith(annulDeliveryTax: true);
    }

    return (updatedState, actions);
  }
}

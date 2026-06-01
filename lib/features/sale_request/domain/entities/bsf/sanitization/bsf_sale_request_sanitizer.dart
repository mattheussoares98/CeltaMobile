// lib/features/sale_request/domain/entities/bsf/sanitization/bsf_sale_request_sanitizer.dart

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:collection/collection.dart';

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

    // 1. Unified allowed finalization and action codes
    final allowedFinalizationCodes = {
      ...?newRequestType.paymentFinalizations?.map((e) => e.code),
      ...?current.customer?.paymentFinalizations?.map((e) => e.code),
    };

    final hasPaymentRestrictions =
        newRequestType.paymentFinalizations?.isNotEmpty == true ||
        current.customer?.paymentFinalizations?.isNotEmpty == true;

    final paymentsThatMustBeCleaned = hasPaymentRestrictions
        ? salePayments?.where((e) {
            final payment = e.paymentFinalization;
            if (payment == null) return true;

            return !allowedFinalizationCodes.contains(payment.code);
          }).toList()
        : <BSFPaymentFinalizationWrapperEntity>[];

    final List<BSFSaleRequestSanitizationAction> actions = [];

    // 1. Sanitize Payments (clear only incompatible ones)
    if (paymentsThatMustBeCleaned?.isNotEmpty ?? false) {
      final names = paymentsThatMustBeCleaned!
          .map((e) => e.paymentFinalization?.Description ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      actions.add(
        BSFSaleRequestSanitizationAction(
          type: BSFSaleRequestSanitizationType.paymentsCleared,
          details: names,
        ),
      );
      final financials = List<BSFFinancialEntity>.from(
        updatedState.financials ?? [],
      );
      if (financials.isNotEmpty) {
        financials[0] = financials[0].copyWith(
          paymentFinalizations: salePayments
              ?.where((e) => !paymentsThatMustBeCleaned.contains(e))
              .toList(),
        );
      }
      updatedState = updatedState.copyWith(financials: financials);
    }

    // 2. Sanitize Discounts
    if (newRequestType.allowUseDiscount != true && current.totalDiscount > 0) {
      actions.add(BSFSaleRequestSanitizationAction.discountsReset);
      updatedState = updatedState.copyWith(
        discounts: const [],
        products: updatedState.products
            ?.map((p) => p.copyWith(discounts: const []))
            .toList(),
      );
    }

    // 3. Sanitize Increments
    if (newRequestType.allowUseIncrement != true &&
        current.totalIncrement > 0) {
      actions.add(BSFSaleRequestSanitizationAction.incrementsReset);
      updatedState = updatedState.copyWith(
        annulIncrement: true,
        products: updatedState.products
            ?.map((p) => p.copyWith(annulIncrement: true))
            .toList(),
      );
    }

    // 4. Sanitize Delivery Tax (Freight)
    if (newRequestType.allowUseDeliveryTax != true &&
        current.totalFreight > 0) {
      actions.add(BSFSaleRequestSanitizationAction.deliveryTaxReset);
      updatedState = updatedState.copyWith(
        annulDeliveryTax: true,
        products: updatedState.products
            ?.map((p) => p.copyWith(annulDeliveryTax: true))
            .toList(),
      );
    }

    //5. Sanitize changed prices
    if (newRequestType.unitValueType != null &&
        newRequestType.unitValueType != current.requestType?.unitValueType) {
      actions.add(BSFSaleRequestSanitizationAction.resetPrices);
      updatedState = updatedState.copyWith(
        products: updatedState.products
            ?.map(
              (p) => p.copyWith(
                value: p.getPriceAccordingToUnitValueTypeAndQuantities(
                  newRequestType.unitValueType!,
                ),
              ),
            )
            .toList(),
      );
    }

    return (updatedState, actions);
  }

  /// Sanitizes state changes when the customer changes.
  static (BSFSaleRequestEntity, List<BSFSaleRequestSanitizationAction>)
  sanitizeCustomerChange(
    BSFSaleRequestEntity current,
    BSFCustomerEntity? newCustomer,
  ) {
    var updatedState = current.copyWith(
      customer: newCustomer,
      annulCustomer: newCustomer == null,
    );

    final salePayments = current.financials?.firstOrNull?.paymentFinalizations;

    // 1. Allowed finalization codes for the new customer
    final allowedFinalizationCodes =
        newCustomer?.paymentFinalizations?.map((e) => e.code).toSet() ?? {};

    final hasCustomerRestrictions = allowedFinalizationCodes.isNotEmpty;
    final paymentsThatMustBeCleaned =
        salePayments?.where((e) {
          final payment = e.paymentFinalization;
          if (payment == null) return true;

          // Rule 1: Validate payment method finalization restrictions from customer
          if (hasCustomerRestrictions &&
              !allowedFinalizationCodes.contains(payment.code)) {
            return true;
          }

          // Rule 2: If it is a covenant payment and the new customer has no selected covenant, it must be cleaned!
          final isCovenant =
              payment.action?.type == PaymentFinalizationActionType.covenant;
          if (isCovenant && newCustomer?.selectedCovenant == null) {
            return true;
          }

          return false;
        }).toList() ??
        <BSFPaymentFinalizationWrapperEntity>[];

    final List<BSFSaleRequestSanitizationAction> actions = [];

    // Rule 3: Validate customer blockade status (hard block)
    if (newCustomer?.saleBlockade?.allowSaleRequest == false &&
        newCustomer?.saleBlockade?.code != 0) {
      final desc = newCustomer?.saleBlockadeInstruction?.description;
      actions.add(
        BSFSaleRequestSanitizationAction(
          type: BSFSaleRequestSanitizationType.customerBlocked,
          details: [if (desc?.isNotEmpty ?? false) desc!],
        ),
      );
    }

    // Sanitize Payments (clear incompatible ones and update covenant codes for remaining ones)
    final financials = List<BSFFinancialEntity>.from(
      updatedState.financials ?? [],
    );
    if (financials.isNotEmpty) {
      final remainingPayments = salePayments
          ?.where((e) => !paymentsThatMustBeCleaned.contains(e))
          .toList();

      financials[0] = financials[0].copyWith(
        paymentFinalizations: remainingPayments,
      );
      updatedState = updatedState.copyWith(financials: financials);
    }

    if (paymentsThatMustBeCleaned.isNotEmpty) {
      final names = paymentsThatMustBeCleaned
          .map((e) => e.paymentFinalization?.Description ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      actions.add(
        BSFSaleRequestSanitizationAction(
          type: BSFSaleRequestSanitizationType.paymentsCleared,
          details: names,
        ),
      );
    }

    return (updatedState, actions);
  }
}

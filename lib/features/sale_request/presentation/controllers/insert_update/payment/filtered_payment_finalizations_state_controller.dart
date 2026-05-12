import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_payment_finalizations_state_controller.g.dart';

@Riverpod(keepAlive: true)
class FilteredPaymentFinalizationsStateController
    extends _$FilteredPaymentFinalizationsStateController {
  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestCode,
  }) async {
    // Watch the current sale request to get the customer and request type
    final (requestType, customerPaymentCodes) = await ref.watch(
      insertUpdateStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestId: saleRequestCode,
      ).selectAsync(
        (s) => (
          s.requestType,
          s.customer?.paymentFinalizations?.map((e) => e.code).toSet(),
        ),
      ),
    );

    // Fetch all available finalizations for the enterprise (Cached)
    final paymentFinalizations = await ref.watch(
      allPaymentFinalizationsControllerProvider(
        enterpriseCode: enterpriseCode,
      ).future,
    );

    // Start with all active finalizations
    List<BSFPaymentFinalizationEntity> activePayments = paymentFinalizations
        .where((e) => e.isDeactivate != true)
        .toList();

    // 1. Filter by Request Type restrictions (if any)
    final requestTypePaymentCodes = requestType?.paymentFinalizations
        ?.map((x) => x.code)
        .toSet();

    if (requestTypePaymentCodes != null && requestTypePaymentCodes.isNotEmpty) {
      activePayments = activePayments
          .where((e) => requestTypePaymentCodes.contains(e.code))
          .toList();
    }

    // 2. Filter by Customer restrictions (if any)
    if (customerPaymentCodes != null && customerPaymentCodes.isNotEmpty) {
      activePayments = activePayments
          .where((e) => customerPaymentCodes.contains(e.code))
          .toList();
    }

    return activePayments;
  }
}

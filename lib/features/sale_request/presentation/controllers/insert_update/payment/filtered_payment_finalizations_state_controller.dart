import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_payment_finalizations_state_controller.g.dart';

@Riverpod(dependencies: [saleRequestArgs, InsertUpdateStateController])
class FilteredPaymentFinalizationsStateController
    extends _$FilteredPaymentFinalizationsStateController {
  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build() async {
    final args = ref.watch(saleRequestArgsProvider);

    // Watch the current sale request to get the customer and request type
    final insertUpdateState = await ref.watch(
      insertUpdateStateControllerProvider.future,
    );
    final (requestType, customerPaymentCodes) = (
      insertUpdateState.requestType,
      insertUpdateState.customer?.paymentFinalizations
          ?.map((e) => e.code)
          .toSet(),
    );

    // Fetch all available finalizations for the enterprise (Cached)
    final paymentFinalizations = await ref.watch(
      allPaymentFinalizationsControllerProvider(
        enterpriseCode: args.enterpriseCode,
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

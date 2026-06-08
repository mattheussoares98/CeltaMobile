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

    // Capture futures synchronously before any async gaps to avoid
    // using a disposed ref after the provider is invalidated/disposed.
    final insertUpdateStateFuture = ref.watch(
      insertUpdateStateControllerProvider.future,
    );

    final allPaymentFinalizationsFuture = ref.watch(
      allPaymentFinalizationsControllerProvider(
        enterpriseCode: args.enterpriseCode,
      ).future,
    );

    if (!ref.mounted) return [];

    final insertUpdateState = await insertUpdateStateFuture;

    if (!ref.mounted) return [];

    final (requestType, customerPaymentCodes) = (
      insertUpdateState.requestType,
      insertUpdateState.customer?.paymentFinalizations
          ?.map((e) => e.code)
          .toSet(),
    );

    final paymentFinalizations = await allPaymentFinalizationsFuture;

    if (!ref.mounted) return [];

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

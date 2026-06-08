import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_payment_conditions_state_controller.g.dart';

@Riverpod(
  keepAlive: true,
  dependencies: [saleRequestArgs, InsertUpdateStateController],
)
class FilteredPaymentConditionsStateController
    extends _$FilteredPaymentConditionsStateController {
  @override
  FutureOr<List<BSFPaymentConditionEntity>> build() async {
    final args = ref.watch(saleRequestArgsProvider);

    // Capture futures synchronously before any async gaps to avoid
    // using a disposed ref after the provider is invalidated.
    final insertUpdateStateFuture = ref.watch(
      insertUpdateStateControllerProvider.future,
    );

    if (!ref.mounted) return [];

    final insertUpdateState = await insertUpdateStateFuture;

    if (!ref.mounted) return [];

    final customerPaymentConditions =
        insertUpdateState.customer?.paymentConditions;

    // Fetch all available conditions for the enterprise
    final allConditionsFuture = ref.watch(
      allPaymentConditionsControllerProvider(
        enterpriseCode: args.enterpriseCode,
      ).future,
    );

    if (!ref.mounted) return [];

    final allConditions = await allConditionsFuture;

    if (!ref.mounted) return [];

    // Filter by restricted payment conditions if the customer has any defined
    List<BSFPaymentConditionEntity> filteredConditions = allConditions;

    if (customerPaymentConditions != null &&
        customerPaymentConditions.isNotEmpty) {
      final allowedCodes = customerPaymentConditions.map((e) => e.code).toSet();
      filteredConditions = allConditions
          .where((condition) => allowedCodes.contains(condition.code))
          .toList();
    }

    return filteredConditions;
  }
}

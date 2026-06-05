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

    // Watch the current sale request to get the customer's restrictions
    final insertUpdateState = await ref.watch(
      insertUpdateStateControllerProvider.future,
    );
    final customerPaymentConditions =
        insertUpdateState.customer?.paymentConditions;

    // Fetch all available conditions for the enterprise
    final allConditions = await ref.watch(
      allPaymentConditionsControllerProvider(
        enterpriseCode: args.enterpriseCode,
      ).future,
    );

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

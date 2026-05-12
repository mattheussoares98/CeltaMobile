import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/entities/entities.dart';

part 'filtered_payment_conditions_state_controller.g.dart';

@Riverpod(keepAlive: true)
class FilteredPaymentConditionsStateController
    extends _$FilteredPaymentConditionsStateController {
  @override
  FutureOr<List<BSFPaymentConditionEntity>> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestId,
  }) async {
    // Watch the current sale request to get the customer's restrictions
    final customerPaymentConditions = await ref.watch(
      insertUpdateStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestId: saleRequestId,
      ).selectAsync((value) => value.customer?.paymentConditions),
    );

    // Fetch all available conditions for the enterprise
    final allConditions = await ref.watch(
      allPaymentConditionsControllerProvider(
        enterpriseCode: enterpriseCode,
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

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_conditions_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PaymentConditionsStateController
    extends _$PaymentConditionsStateController {
  @override
  FutureOr<List<BSFPaymentConditionEntity>> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestId,
  }) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    // Watch the current sale request to get the customer's restrictions
    final customerPaymentConditions = await ref.watch(
      insertUpdateStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestId: saleRequestId,
      ).selectAsync((value) => value.customer?.paymentConditions),
    );

    // Fetch all available conditions for the enterprise
    final allConditions = await ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentConditions(
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
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

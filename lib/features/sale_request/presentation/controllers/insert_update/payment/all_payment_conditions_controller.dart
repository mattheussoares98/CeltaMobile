import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_payment_conditions_controller.g.dart';

@Riverpod(keepAlive: true)
class AllPaymentConditionsController extends _$AllPaymentConditionsController {
  @override
  FutureOr<List<BSFPaymentConditionEntity>> build({
    required int enterpriseCode,
  }) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentConditions(
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
        );
  }
}

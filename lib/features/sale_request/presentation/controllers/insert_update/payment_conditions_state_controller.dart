import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers.dart';

part 'payment_conditions_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PaymentConditionsStateController extends _$PaymentConditionsStateController {
  @override
  FutureOr<List<BSFPaymentConditionEntity>> build() async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final paymentConditions = await ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentConditions(
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
        );

    return paymentConditions;
  }
}

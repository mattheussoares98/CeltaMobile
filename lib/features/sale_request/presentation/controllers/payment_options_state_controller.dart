import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'payment_options_state_controller.g.dart';

@riverpod
class PaymentOptionsStateController extends _$PaymentOptionsStateController {
  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build(int enterpriseCode) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(ecSaleRequestsRepositoryProvider)
        .getPaymentOptions(
          enterpriseCode: enterpriseCode,
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
        );
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers.dart';
import 'insert_update.dart';

part 'payment_finalizations_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PaymentFinalizationsStateController
    extends _$PaymentFinalizationsStateController {
  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestCode,
  }) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final requestType = await ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestCode,
      ).selectAsync((data) => data.requestType),
    );

    final paymentFinalizations = await ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentFinalizations(
          enterpriseCode: enterpriseCode,
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
        );

    final requestTypePaymentCodes = requestType?.paymentFinalizations
        ?.map((x) => x.code)
        .toList();

    final activatedPayments = paymentFinalizations
        .where((e) => e.isDeactivate != true)
        .toList();

    if (requestTypePaymentCodes?.isEmpty ?? true) {
      //if there is no payment finalization set in request type, then
      //all payments are allowed
      return activatedPayments;
    }

    return activatedPayments
        .where((e) => requestTypePaymentCodes!.contains(e.code))
        .toList();
  }
}

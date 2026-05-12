import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_payment_finalizations_controller.g.dart';

@Riverpod(keepAlive: true)
class AllPaymentFinalizationsController
    extends _$AllPaymentFinalizationsController {
  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build({
    required int enterpriseCode,
  }) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentFinalizations(
          enterpriseCode: enterpriseCode,
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
        );
  }
}

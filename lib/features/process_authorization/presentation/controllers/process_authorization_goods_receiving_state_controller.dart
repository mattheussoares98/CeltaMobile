import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_authorization_goods_receiving_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ProcessAuthorizationGoodsReceivingStateController
    extends _$ProcessAuthorizationGoodsReceivingStateController {
  @override
  FutureOr<dynamic> build(int processCode) async {
    //TODO create tests
    // final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    // final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    // final ecParams = EcRequestParams(
    //   workingUrl: validatedUser!.enterprise!.workingUrl!,
    //   user: validatedUser.user.name!,
    //   accessKey: validatedUser.user.AccessKey!,
    // );

    ref.invalidate(judgmentDetailsStateControllerProvider(processCode));
    final details = await ref.read(
      judgmentDetailsStateControllerProvider(processCode).future,
    );
    final defendant = details.defendants
        ?.cast<BSFSaleRequestDefendantEntity?>()
        .firstOrNull;

    if (defendant == null) {
      throw AppException(
        'Não foi possível carregar os dados do recebimento'.hardcoded,
      );
    }

    return defendant.toString();
  }
}

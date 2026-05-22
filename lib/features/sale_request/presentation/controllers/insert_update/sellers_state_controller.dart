import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sellers_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SellersStateController extends _$SellersStateController {
  @override
  FutureOr<List<EcSellerEntity>> build() async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final params = EcRequestParams(
      workingUrl: userSession!.enterprise!.workingUrl!,
      user: userSession.user.name!,
      accessKey: userSession.user.AccessKey!,
    );

    return await ref.read(ecSellerRepositoryProvider).get(params);
  }
}

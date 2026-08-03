import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/buyer/buyer.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buyers_state_controller.g.dart';

@Riverpod(keepAlive: true)
class BuyersStateController extends _$BuyersStateController {
  @override
  FutureOr<List<BuyerEntity>> build() async {
    ref.cache(60);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadBuyersRepositoryProvider)
        .load(
          workingUrl: userSession!.enterprise!.workingUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
        );
  }
}

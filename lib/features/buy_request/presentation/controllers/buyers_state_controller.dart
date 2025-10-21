import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'buyers_state_controller.g.dart';

@Riverpod(keepAlive: true)
class BuyersStateController extends _$BuyersStateController {
  @override
  FutureOr<List<BuyerEntity>?> build() async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadBuyersRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
        );
  }
}

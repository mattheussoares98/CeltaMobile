import 'package:celta_inventario/features/customer_register/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';

part 'covenants_state_controller.g.dart';

@Riverpod(keepAlive: true)
class CovenantsStateController extends _$CovenantsStateController {
  @override
  FutureOr<List<CovenantEntity>?> build() async {
    final repository = ref.read(soapLoadCovenantsRepositoryProvider);
    final validatedUserSession = await ref.watch(
      validatedUserSessionProvider.future,
    );

    return await repository.load(
      workingUrl: validatedUserSession!.enterprise!.workingUrl!,
      crossIdentity: validatedUserSession.user.CrossIdentity_Usuario!,
      searchCovenantType: SearchCovenantType.approximateName,
      searchValue: "%",
    );
  }
}

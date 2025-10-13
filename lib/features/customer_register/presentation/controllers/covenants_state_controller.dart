import 'dart:async';

import 'package:celta_intelligence/features/customer_register/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';

part 'covenants_state_controller.g.dart';

@riverpod
class CovenantsStateController extends _$CovenantsStateController {
  @override
  FutureOr<List<CovenantEntity>?> build(String enterpriseName) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final repository = ref.read(soapLoadCovenantsRepositoryProvider);
    final validatedUserSession = await ref.read(
      validatedUserSessionProvider.future,
    );

    return await repository.load(
      baseUrl: validatedUserSession!.enterprise!.baseUrl!,
      crossIdentity: validatedUserSession.user.CrossIdentity_Usuario!,
      searchCovenantType: SearchCovenantType.approximateName,
      searchValue: "%",
    );
  }
}

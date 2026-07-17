import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_state_controller.g.dart';

@Riverpod(keepAlive: true)
class StatisticsStateController extends _$StatisticsStateController {
  @override
  FutureOr<BsfProcessAuthorizationStatisticEntity> build() async {
    final canAccess = ref.watch(
      canAccessResourceStateControllerProvider(
        .generic,
        .processAuthorizationRules,
      ),
      //! automatically reloading the permission when the user tap the button to access the module
    );

    if (canAccess.value != true) {
      throw AppException(
        'Usuário sem permissão para acessar este módulo'.hardcoded,
      );
    }

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = EcRequestParams(
      workingUrl: validatedUser!.enterprise!.workingUrl!,
      user: validatedUser.user.name!,
      accessKey: validatedUser.user.AccessKey!,
    );

    // Setup periodic timer to refresh the statistics silently every 2 minutes
    final timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      try {
        final newData = await repository.getStatistics(ecParams);
        state = AsyncData(newData);
      } catch (_) {
        // Silently ignore errors and keep the previous state
      }
    });

    ref.onDispose(timer.cancel);

    return await repository.getStatistics(ecParams);
  }
}

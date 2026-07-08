import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/services/services.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_state_controller.g.dart';

bool alreadyLoaded = false;

@Riverpod(keepAlive: true)
class StatisticsStateController extends _$StatisticsStateController {
  @override
  FutureOr<BsfProcessAuthorizationStatisticEntity> build() async {
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

    final statistics = await repository.getStatistics(ecParams);
    final openedJudgments = statistics.openedJudgements ?? 0;
    if (openedJudgments > 0 && !alreadyLoaded) {
      ref
          .read(notificationsServiceProvider)
          .showNotification(
            title: 'Processos de autorização pendentes'.hardcoded,
            body:
                'Existem $openedJudgments processos de autorização pendentes para serem analisados.'
                    .hardcoded,
          );
      alreadyLoaded = true;
    }
    return statistics;
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';

part 'confirm_conference_controller.g.dart';

@riverpod
class ConfirmConferenceController extends _$ConfirmConferenceController {
  @override
  FutureOr<void> build() {}

  Future<bool> confirm({
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    bool succeeds = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final repository = ref.read(soapConfirmConferenceRepositoryProvider);

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.finishedExpedition);

      await repository.confirm(
        workingUrl: userSession!.enterprise!.workingUrl!,
        crossIdentity: userSession.user.CrossIdentity_Usuario!,
        expeditionControlCode: expeditionControlCode,
        stepCode: stepCode,
      );
      succeeds = true;
    });

    return succeeds;
  }
}

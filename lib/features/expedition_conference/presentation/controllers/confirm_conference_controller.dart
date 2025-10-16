import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      final userSession = await ref.read(validatedUserSessionProvider.future);
      final repository = ref.read(soapConfirmConferenceRepositoryProvider);

      await repository.confirm(
        baseUrl: userSession!.enterprise!.baseUrl!,
        crossIdentity: userSession.user.CrossIdentity_Usuario!,
        expeditionControlCode: expeditionControlCode,
        stepCode: stepCode,
      );
      succeeds = true;
    });

    return succeeds;
  }
}

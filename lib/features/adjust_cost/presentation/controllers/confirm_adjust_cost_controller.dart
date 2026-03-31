import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entity/entity.dart';
import '../../providers.dart';

part 'confirm_adjust_cost_controller.g.dart';

@riverpod
class ConfirmAdjustCostController extends _$ConfirmAdjustCostController {
  @override
  FutureOr<void> build() {}

  Future<void> confirm(AdjustCostParametersEntity parameters) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);

      await ref
          .read(ecAdjustCostRepositoryProvider)
          .adjust(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
            parameters: parameters,
          );
    });
  }
}

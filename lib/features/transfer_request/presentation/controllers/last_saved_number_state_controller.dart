import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';

part 'last_saved_number_state_controller.g.dart';

@Riverpod(keepAlive: true)
class LastSavedNumberStateController extends _$LastSavedNumberStateController {
  @override
  Future<String?> build() async {
    ref.watch(validatedUserSessionProvider);
    return await ref.read(localLastSavedNumberRepositoryProvider).load();
  }

  Future<void> save(String number) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(localLastSavedNumberRepositoryProvider).save(number);
      return number;
    });
  }
}

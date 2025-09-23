import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';

part 'preferred_search_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PreferredSearchTypeStateController
    extends _$PreferredSearchTypeStateController {
  @override
  Future<UserPreferredSearchType?> build() async {
    return await ref.watch(preferredSearchTypeRepositoryProvider).loadDefault();
  }

  Future<void> changeDefault(
    UserPreferredSearchType userPreferredSearchType,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(preferredSearchTypeRepositoryProvider)
          .changeDefault(userPreferredSearchType);

      return userPreferredSearchType;
    });
  }
}

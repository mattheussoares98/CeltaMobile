import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/home/providers.dart';

part 'favorite_modules_state_controller.g.dart';

@Riverpod(keepAlive: true)
class FavoriteModulesStateController extends _$FavoriteModulesStateController {
  @override
  FutureOr<List<Modules>> build() async {
    return await ref.read(localFavoriteModulesRepositoryProvider).load();
  }

  Future<void> toggle(Modules module) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(localFavoriteModulesRepositoryProvider)
          .toggle(module);
    });
  }
}

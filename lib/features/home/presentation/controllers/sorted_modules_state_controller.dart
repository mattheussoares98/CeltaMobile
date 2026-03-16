import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../pages/models/models.dart';
import 'controllers.dart';

part 'sorted_modules_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SortedModulesStateController extends _$SortedModulesStateController {
  @override
  SortedModulesData build() {
    final favoriteModules = ref.watch(
      favoriteModulesStateControllerProvider.select(
        (s) => s.value ?? const <Modules>[],
      ),
    );

    // PERFORMANCE: Pre-allocate the list with fixed length for better memory efficiency.
    final modules = List<Modules>.of(Modules.values);
    final favIndex = {
      for (int i = 0; i < favoriteModules.length; i++) favoriteModules[i]: i,
    };

    modules.sort((a, b) {
      final ia = favIndex[a];
      final ib = favIndex[b];

      // 1. If both are favorites, maintain the favorite list order (usually LIFO)
      if (ia != null && ib != null) return ib.compareTo(ia);

      // 2. Favorites always come before non-favorites
      if (ia != null) return -1;
      if (ib != null) return 1;

      // 3. PERFORMANCE: Alphabetical sorting for non-favorites.
      // We use lowercase comparison to ensure the sort is lexicographically correct
      // regardless of the enum casing.
      return a.description.toLowerCase().compareTo(b.description.toLowerCase());
    });

    final indexMap = {for (int i = 0; i < modules.length; i++) modules[i]: i};
    return SortedModulesData(modules, indexMap);
  }
}

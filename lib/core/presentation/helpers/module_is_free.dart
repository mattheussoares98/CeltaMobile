import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract final class ModuleIsFreeUntil {
  static final now = DateTime.now();

  static bool isFree(Modules module) => switch (module) {
    Modules.synchronizer => _synchronizerIsFree,
    _ => false,
  };

  static DateTime get synchronizerLimit => DateTime(2026, 9, 11);
  static bool get _synchronizerIsFree =>
      now.isBefore(synchronizerLimit.add(const Duration(days: 1)));
}

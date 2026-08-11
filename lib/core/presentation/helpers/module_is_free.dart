import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract final class ModuleIsFreeUntil {
  static final now = DateTime.now();

  static bool isFree(Modules module) => switch (module) {
    Modules.synchronizer => synchronizerIsFree,
    _ => false,
  };

  static DateTime get _synchronizerDate => DateTime(2026, 9, 11);
  static bool get synchronizerIsFree =>
      now.isBefore(_synchronizerDate.add(const Duration(days: 1)));
}

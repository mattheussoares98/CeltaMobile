import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

@immutable
class SortedModulesData {
  final List<Modules> list;
  final Map<Modules, int> indexMap;

  const SortedModulesData(this.list, this.indexMap);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortedModulesData &&
          const ListEquality().equals(list, other.list);

  @override
  int get hashCode => const ListEquality().hash(list);
}

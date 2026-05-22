import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/inventory/domain/entities/entities.dart';

class InventoryEntity extends Equatable {
  final List<FrozenProcessEntity> frozenProcesses;
  final List<CountingEntity> countings;

  const InventoryEntity({
    required this.frozenProcesses,
    required this.countings,
  });

  @override
  List<Object?> get props => [frozenProcesses, countings];
}

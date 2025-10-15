import 'package:equatable/equatable.dart';

import 'entities.dart';

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

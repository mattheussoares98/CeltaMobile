import 'package:equatable/equatable.dart';

import 'entities.dart';

class InventoryEntity extends Equatable {
  final FrozenProcessEntity frozenProcess;
  final CountingEntity counting;

  const InventoryEntity({required this.frozenProcess, required this.counting});

  @override
  List<Object?> get props => [frozenProcess, counting];
}

import 'package:equatable/equatable.dart';

import 'entities.dart';

class InventoryEntity extends Equatable {
  final FrozenProcessEntity frozenProces;
  final CountingEntity counting;

  const InventoryEntity({required this.frozenProces, required this.counting});

  @override
  List<Object?> get props => [frozenProces, counting];
}

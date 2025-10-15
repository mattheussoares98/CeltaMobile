import 'package:equatable/equatable.dart';

import 'models.dart';

class InventoryModel extends Equatable {
  final FrozenProcessModel frozenProcess;
  final CountingModel counting;

  const InventoryModel({required this.frozenProcess, required this.counting});

  @override
  List<Object?> get props => [frozenProcess, counting];
}

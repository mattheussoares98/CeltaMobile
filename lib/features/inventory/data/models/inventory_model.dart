import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class InventoryModel extends Equatable {
  final FrozenProcessModel frozenProcess;
  final CountingModel counting;

  const InventoryModel({required this.frozenProcess, required this.counting});

  @override
  List<Object?> get props => [frozenProcess, counting];

  factory InventoryModel.fromJson(Map json) => InventoryModel(
    frozenProcess: FrozenProcessModel.fromJson(json['Inventarios'] ?? {}),
    counting: CountingModel.fromJson(json['InventariosContagens'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'Inventarios': frozenProcess.toJson(),
    'InventariosContagens': counting.toJson(),
  };

  InventoryEntity toEntity() => InventoryEntity(
    frozenProces: frozenProcess.toEntity(),
    counting: counting.toEntity(),
  );

  factory InventoryModel.fromEntity(InventoryEntity entity) => InventoryModel(
    frozenProcess: FrozenProcessModel.fromEntity(entity.frozenProces),
    counting: CountingModel.fromEntity(entity.counting),
  );
}

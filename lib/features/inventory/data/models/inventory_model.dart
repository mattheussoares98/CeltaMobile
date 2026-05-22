import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/inventory/domain/entities/entities.dart';
import 'package:celta_inventario/features/inventory/data/models/models.dart';

class InventoryModel extends Equatable {
  final List<FrozenProcessModel> frozenProcesses;
  final List<CountingModel> countings;

  const InventoryModel({
    required this.frozenProcesses,
    required this.countings,
  });

  @override
  List<Object?> get props => [frozenProcesses, countings];

  factory InventoryModel.fromJson(Map json) => InventoryModel(
    frozenProcesses:
        (json['Inventarios']
                    is Map //when has only one, return a Map. When has more, return list
                ? [json['Inventarios']]
                : json['Inventarios'] as List?)
            ?.map((e) => FrozenProcessModel.fromJson(e))
            .toList() ??
        [],
    countings:
        (json['InventariosContagens']
                    is Map //when has only one, return a Map. When has more, return list
                ? [json['InventariosContagens']]
                : json['InventariosContagens'] as List?)
            ?.map((e) => CountingModel.fromJson(e))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'Inventarios': frozenProcesses.map((e) => e.toJson()).toList(),
    'InventariosContagens': countings.map((e) => e.toJson()).toList(),
  };

  InventoryEntity toEntity() => InventoryEntity(
    frozenProcesses: frozenProcesses.map((e) => e.toEntity()).toList(),
    countings: countings.map((e) => e.toEntity()).toList(),
  );

  factory InventoryModel.fromEntity(InventoryEntity entity) => InventoryModel(
    frozenProcesses: entity.frozenProcesses
        .map((e) => FrozenProcessModel.fromEntity(e))
        .toList(),
    countings: entity.countings
        .map((e) => CountingModel.fromEntity(e))
        .toList(),
  );
}

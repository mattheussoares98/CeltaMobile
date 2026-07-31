import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFScheduleSynchronizerErrorDetailModel
    extends BSFScheduleSynchronizerErrorDetailEntity {
  const BSFScheduleSynchronizerErrorDetailModel({
    required super.serverName,
    required super.enterpriseName,
    required super.executionDate,
    required super.description,
  });

  factory BSFScheduleSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFScheduleSynchronizerErrorDetailModel(
        serverName: json['serverName'] as String,
        enterpriseName: json['enterpriseName'] as String,
        executionDate: DateTime.parse(json['executionDate'] as String),
        description: json['description'] as String,
      );

  Map toJson() => {
    'serverName': serverName,
    'enterpriseName': enterpriseName,
    'executionDate': executionDate.toIso8601String(),
    'description': description,
  };

  factory BSFScheduleSynchronizerErrorDetailModel.fromEntity(
    BSFScheduleSynchronizerErrorDetailEntity entity,
  ) => BSFScheduleSynchronizerErrorDetailModel(
    serverName: entity.serverName,
    enterpriseName: entity.enterpriseName,
    executionDate: entity.executionDate,
    description: entity.description,
  );

  BSFScheduleSynchronizerErrorDetailEntity toEntity() =>
      BSFScheduleSynchronizerErrorDetailEntity(
        serverName: serverName,
        enterpriseName: enterpriseName,
        executionDate: executionDate,
        description: description,
      );
}

import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

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
        serverName: json['ServerName'] as String,
        enterpriseName: json['EnterpriseName'] as String,
        executionDate: DateTime.parse(json['ExecutionDate'] as String),
        description: json['Description'] as String,
      );

  Map toJson() => {
    'ServerName': serverName,
    'EnterpriseName': enterpriseName,
    'ExecutionDate': executionDate.toIso8601String(),
    'Description': description,
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

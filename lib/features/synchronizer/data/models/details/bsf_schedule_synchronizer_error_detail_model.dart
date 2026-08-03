import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFScheduleSynchronizerErrorDetailModel
    extends BSFScheduleSynchronizerErrorDetailEntity {
  const BSFScheduleSynchronizerErrorDetailModel({
    required super.code,
    required super.serverName,
    required super.enterpriseName,
    required super.executionDate,
    required super.description,
  });

  factory BSFScheduleSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFScheduleSynchronizerErrorDetailModel(
        code: json['Code'] as int,
        serverName: json['ServerName'] as String,
        enterpriseName: json['EnterpriseName'] as String,
        executionDate: DateTime.parse(json['ExecutionDate'] as String),
        description: json['Description'] as String,
      );

  Map toJson() => {
    'Code': code,
    'ServerName': serverName,
    'EnterpriseName': enterpriseName,
    'ExecutionDate': executionDate.toIso8601String(),
    'Description': description,
  };

  factory BSFScheduleSynchronizerErrorDetailModel.fromEntity(
    BSFScheduleSynchronizerErrorDetailEntity entity,
  ) => BSFScheduleSynchronizerErrorDetailModel(
    code: entity.code,
    serverName: entity.serverName,
    enterpriseName: entity.enterpriseName,
    executionDate: entity.executionDate,
    description: entity.description,
  );

  BSFScheduleSynchronizerErrorDetailEntity toEntity() =>
      BSFScheduleSynchronizerErrorDetailEntity(
        code: code,
        serverName: serverName,
        enterpriseName: enterpriseName,
        executionDate: executionDate,
        description: description,
      );
}

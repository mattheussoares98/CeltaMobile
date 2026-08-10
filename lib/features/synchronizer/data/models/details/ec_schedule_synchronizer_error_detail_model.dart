import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcScheduleSynchronizerErrorDetailModel
    extends EcScheduleSynchronizerErrorDetailEntity {
  const EcScheduleSynchronizerErrorDetailModel({
    required super.code,
    required super.serverName,
    required super.enterpriseName,
    required super.executionDate,
    required super.description,
  });

  factory EcScheduleSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcScheduleSynchronizerErrorDetailModel(
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

  factory EcScheduleSynchronizerErrorDetailModel.fromEntity(
    EcScheduleSynchronizerErrorDetailEntity entity,
  ) => EcScheduleSynchronizerErrorDetailModel(
    code: entity.code,
    serverName: entity.serverName,
    enterpriseName: entity.enterpriseName,
    executionDate: entity.executionDate,
    description: entity.description,
  );

  EcScheduleSynchronizerErrorDetailEntity toEntity() =>
      EcScheduleSynchronizerErrorDetailEntity(
        code: code,
        serverName: serverName,
        enterpriseName: enterpriseName,
        executionDate: executionDate,
        description: description,
      );
}

import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ExpeditionDocumentModel extends Equatable {
  final int? EnterpriseCode;
  final int? ExpeditionControlCode;
  final int? OriginCode;
  final int? OriginType;
  final int? StepCode;
  final String? DocumentNumber;
  final String? StepName;
  final String? OriginTypeString;

  const ExpeditionDocumentModel({
    required this.EnterpriseCode,
    required this.ExpeditionControlCode,
    required this.OriginCode,
    required this.OriginType,
    required this.StepCode,
    required this.DocumentNumber,
    required this.StepName,
    required this.OriginTypeString,
  });

  @override
  List<Object?> get props => [
    EnterpriseCode,
    ExpeditionControlCode,
    OriginCode,
    OriginType,
    StepCode,
    DocumentNumber,
    StepName,
    OriginTypeString,
  ];

  factory ExpeditionDocumentModel.fromJson(Map json) => ExpeditionDocumentModel(
    EnterpriseCode: json["EnterpriseCode"],
    ExpeditionControlCode: json["ExpeditionControlCode"],
    OriginCode: json["OriginCode"],
    OriginType: json["OriginType"],
    StepCode: json["StepCode"],
    DocumentNumber: json["DocumentNumber"],
    StepName: json["StepName"],
    OriginTypeString: json["OriginTypeString"],
  );

  Map<String, dynamic> toJson() => {
    "EnterpriseCode": EnterpriseCode,
    "ExpeditionControlCode": ExpeditionControlCode,
    "OriginCode": OriginCode,
    "OriginType": OriginType,
    "StepCode": StepCode,
    "DocumentNumber": DocumentNumber,
    "StepName": StepName,
    "OriginTypeString": OriginTypeString,
  };

  factory ExpeditionDocumentModel.fromEntity(ExpeditionDocumentEntity entity) =>
      ExpeditionDocumentModel(
        EnterpriseCode: entity.EnterpriseCode,
        ExpeditionControlCode: entity.ExpeditionControlCode,
        OriginCode: entity.OriginCode,
        OriginType: entity.OriginType,
        StepCode: entity.StepCode,
        DocumentNumber: entity.DocumentNumber,
        StepName: entity.StepName,
        OriginTypeString: entity.OriginTypeString,
      );

  ExpeditionDocumentEntity toEntity() => ExpeditionDocumentEntity(
    EnterpriseCode: EnterpriseCode,
    ExpeditionControlCode: ExpeditionControlCode,
    OriginCode: OriginCode,
    OriginType: OriginType,
    StepCode: StepCode,
    DocumentNumber: DocumentNumber,
    StepName: StepName,
    OriginTypeString: OriginTypeString,
  );
}

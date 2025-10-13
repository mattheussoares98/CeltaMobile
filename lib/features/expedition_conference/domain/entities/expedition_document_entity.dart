import 'package:equatable/equatable.dart';

class ExpeditionDocumentEntity extends Equatable {
  final int? EnterpriseCode;
  final int? ExpeditionControlCode;
  final int? OriginCode;
  final int? OriginType;
  final int? StepCode;
  final String? DocumentNumber;
  final String? StepName;
  final String? OriginTypeString;

  const ExpeditionDocumentEntity({
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
}

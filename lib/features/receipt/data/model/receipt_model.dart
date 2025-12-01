import 'package:equatable/equatable.dart';

import '../../domain/entity/entity.dart';

class ReceiptModel extends Equatable {
  final int CodigoInterno_ProcRecebDoc;
  final int CodigoInterno_Empresa;
  final int Numero_ProcRecebDoc;
  final String? EmitterName;
  final String? Grupo;
  final String? Observacoes_ProcRecebDoc;
  final String? DefaultObservations;
  final int Status;

  const ReceiptModel({
    required this.CodigoInterno_ProcRecebDoc,
    required this.CodigoInterno_Empresa,
    required this.Numero_ProcRecebDoc,
    required this.EmitterName,
    required this.Grupo,
    required this.Observacoes_ProcRecebDoc,
    required this.DefaultObservations,
    required this.Status,
  });

  @override
  List<Object?> get props => [
    CodigoInterno_ProcRecebDoc,
    CodigoInterno_Empresa,
    Numero_ProcRecebDoc,
    EmitterName,
    Grupo,
    Observacoes_ProcRecebDoc,
    DefaultObservations,
    Status,
  ];

  factory ReceiptModel.fromJson(Map map) => ReceiptModel(
    CodigoInterno_ProcRecebDoc: int.parse(map["CodigoInterno_ProcRecebDoc"]),
    CodigoInterno_Empresa: int.parse(map["CodigoInterno_Empresa"]),
    Numero_ProcRecebDoc: int.parse(map["Numero_ProcRecebDoc"]),
    EmitterName: map["EmitterName"],
    Grupo: map["Grupo"],
    Status: int.parse(map["Status"]),
    Observacoes_ProcRecebDoc: map["Observacoes_ProcRecebDoc"],
    DefaultObservations: map["DefaultObservations"],
  );

  Map<String, dynamic> toJson() => {
    "CodigoInterno_ProcRecebDoc": CodigoInterno_ProcRecebDoc.toString(),
    "CodigoInterno_Empresa": CodigoInterno_Empresa.toString(),
    "Numero_ProcRecebDoc": Numero_ProcRecebDoc.toString(),
    "EmitterName": EmitterName,
    "Grupo": Grupo,
    "Status": Status.toString(),
    "Observacoes_ProcRecebDoc": Observacoes_ProcRecebDoc,
    "DefaultObservations": DefaultObservations,
  };

  factory ReceiptModel.fromEntity(ReceiptEntity entity) => ReceiptModel(
    CodigoInterno_ProcRecebDoc: entity.CodigoInterno_ProcRecebDoc,
    CodigoInterno_Empresa: entity.CodigoInterno_Empresa,
    Numero_ProcRecebDoc: entity.Numero_ProcRecebDoc,
    EmitterName: entity.EmitterName,
    Grupo: entity.Grupo,
    Status: entity.Status,
    Observacoes_ProcRecebDoc: entity.Observacoes_ProcRecebDoc,
    DefaultObservations: entity.DefaultObservations,
  );

  ReceiptEntity toEntity() => ReceiptEntity(
    CodigoInterno_ProcRecebDoc: CodigoInterno_ProcRecebDoc,
    CodigoInterno_Empresa: CodigoInterno_Empresa,
    Numero_ProcRecebDoc: Numero_ProcRecebDoc,
    EmitterName: EmitterName,
    Grupo: Grupo,
    Status: Status,
    Observacoes_ProcRecebDoc: Observacoes_ProcRecebDoc,
    DefaultObservations: DefaultObservations,
  );
}

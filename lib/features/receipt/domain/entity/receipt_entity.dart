// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'entity.dart';

class ReceiptEntity extends Equatable {
  final int CodigoInterno_ProcRecebDoc;
  final int CodigoInterno_Empresa;
  final int Numero_ProcRecebDoc;
  final String? EmitterName;
  final String? Grupo;
  final String? Observacoes_ProcRecebDoc;
  final String? DefaultObservations;
  final Status status;

  const ReceiptEntity({
    required this.CodigoInterno_ProcRecebDoc,
    required this.CodigoInterno_Empresa,
    required this.Numero_ProcRecebDoc,
    required this.EmitterName,
    required this.Grupo,
    required this.Observacoes_ProcRecebDoc,
    required this.DefaultObservations,
    required this.status,
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
    status,
  ];

  ReceiptEntity copyWith({
    int? CodigoInterno_ProcRecebDoc,
    int? CodigoInterno_Empresa,
    int? Numero_ProcRecebDoc,
    String? EmitterName,
    String? Grupo,
    String? Observacoes_ProcRecebDoc,
    String? DefaultObservations,
    Status? status,
  }) {
    return ReceiptEntity(
      CodigoInterno_ProcRecebDoc:
          CodigoInterno_ProcRecebDoc ?? this.CodigoInterno_ProcRecebDoc,
      CodigoInterno_Empresa:
          CodigoInterno_Empresa ?? this.CodigoInterno_Empresa,
      Numero_ProcRecebDoc: Numero_ProcRecebDoc ?? this.Numero_ProcRecebDoc,
      EmitterName: EmitterName ?? this.EmitterName,
      Grupo: Grupo ?? this.Grupo,
      Observacoes_ProcRecebDoc:
          Observacoes_ProcRecebDoc ?? this.Observacoes_ProcRecebDoc,
      DefaultObservations: DefaultObservations ?? this.DefaultObservations,
      status: status ?? this.status,
    );
  }
}

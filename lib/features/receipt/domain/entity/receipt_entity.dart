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
}

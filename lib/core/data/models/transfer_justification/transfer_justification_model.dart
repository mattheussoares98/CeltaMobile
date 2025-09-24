import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'transfer_justification.dart';

class TransferJustificationModel extends Equatable {
  final int CodigoInterno_JustMov; /*  37, */
  final String Descricao_JustMov; /*  "SUBTRAIR", */
  final String FlagTipo_JustMov; /*  "Saída", */
  final String TypeOperator; /*  "(-)", */
  final String Nome_TipoEstoque; /*  "", */
  final TransferJustificationStockTypeModel? CodigoInterno_TipoEstoque;

  const TransferJustificationModel({
    required this.CodigoInterno_JustMov,
    required this.Descricao_JustMov,
    required this.FlagTipo_JustMov,
    required this.TypeOperator,
    required this.Nome_TipoEstoque,
    required this.CodigoInterno_TipoEstoque,
  });

  @override
  List<Object?> get props => [
    CodigoInterno_JustMov,
    Descricao_JustMov,
    FlagTipo_JustMov,
    TypeOperator,
    Nome_TipoEstoque,
    CodigoInterno_TipoEstoque,
  ];

  factory TransferJustificationModel.fromJson(Map<String, dynamic> json) =>
      TransferJustificationModel(
        CodigoInterno_JustMov: json["CodigoInterno_JustMov"],
        Descricao_JustMov: json["Descricao_JustMov"],
        FlagTipo_JustMov: json["FlagTipo_JustMov"],
        TypeOperator: json["TypeOperator"],
        Nome_TipoEstoque: json["Nome_TipoEstoque"],
        CodigoInterno_TipoEstoque: json["CodigoInterno_TipoEstoque"] == null
            ? null
            : TransferJustificationStockTypeModel.fromJson(
                json["CodigoInterno_TipoEstoque"],
              ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'CodigoInterno_JustMov': CodigoInterno_JustMov,
    'Descricao_JustMov': Descricao_JustMov,
    'FlagTipo_JustMov': FlagTipo_JustMov,
    'TypeOperator': TypeOperator,
    'Nome_TipoEstoque': Nome_TipoEstoque,
    'CodigoInterno_TipoEstoque': CodigoInterno_TipoEstoque?.toJson(),
  };

  factory TransferJustificationModel.fromEntity(
    TransferJustificationsEntity entity,
  ) => TransferJustificationModel(
    CodigoInterno_JustMov: entity.CodigoInterno_JustMov,
    Descricao_JustMov: entity.Descricao_JustMov,
    FlagTipo_JustMov: entity.FlagTipo_JustMov,
    TypeOperator: entity.TypeOperator,
    Nome_TipoEstoque: entity.Nome_TipoEstoque,
    CodigoInterno_TipoEstoque: entity.CodigoInterno_TipoEstoque == null
        ? null
        : TransferJustificationStockTypeModel.fromEntity(
            entity.CodigoInterno_TipoEstoque!,
          ),
  );

  TransferJustificationsEntity toEntity() => TransferJustificationsEntity(
    CodigoInterno_JustMov: CodigoInterno_JustMov,
    Descricao_JustMov: Descricao_JustMov,
    FlagTipo_JustMov: FlagTipo_JustMov,
    TypeOperator: TypeOperator,
    Nome_TipoEstoque: Nome_TipoEstoque,
    CodigoInterno_TipoEstoque: CodigoInterno_TipoEstoque?.toEntity(),
  );
}

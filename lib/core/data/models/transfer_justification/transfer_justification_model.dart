import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class TransferJustificationModel extends Equatable {
  final int CodigoInterno_JustMov; /*  37, */
  final String Descricao_JustMov; /*  "SUBTRAIR", */
  final OperationType operationType; /*  "Saída", */
  final bool? FlagInterno_TipoEstoque; /*  "(-)", */
  final String? Nome_TipoEstoque; /*  "", */
  final int? CodigoInterno_TipoEstoque;

  const TransferJustificationModel({
    required this.CodigoInterno_JustMov,
    required this.Descricao_JustMov,
    required this.operationType,
    required this.FlagInterno_TipoEstoque,
    required this.Nome_TipoEstoque,
    required this.CodigoInterno_TipoEstoque,
  });

  @override
  List<Object?> get props => [
    CodigoInterno_JustMov,
    Descricao_JustMov,
    operationType,
    FlagInterno_TipoEstoque,
    Nome_TipoEstoque,
    CodigoInterno_TipoEstoque,
  ];

  factory TransferJustificationModel.fromJson(Map json) =>
      TransferJustificationModel(
        CodigoInterno_JustMov: json["CodigoInterno_JustMov"],
        Descricao_JustMov: json["Descricao_JustMov"],
        operationType: OperationType.values.firstWhere(
          (element) => element.name == json["FlagTipo_JustMov"],
        ),
        FlagInterno_TipoEstoque: json["FlagInterno_TipoEstoque"],
        Nome_TipoEstoque: json["Nome_TipoEstoque"],
        CodigoInterno_TipoEstoque: json["CodigoInterno_TipoEstoque"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'CodigoInterno_JustMov': CodigoInterno_JustMov,
    'Descricao_JustMov': Descricao_JustMov,
    'FlagTipo_JustMov': operationType.value,
    'FlagInterno_TipoEstoque': FlagInterno_TipoEstoque,
    'Nome_TipoEstoque': Nome_TipoEstoque,
    'CodigoInterno_TipoEstoque': CodigoInterno_TipoEstoque,
  };

  factory TransferJustificationModel.fromEntity(
    TransferJustificationEntity entity,
  ) => TransferJustificationModel(
    CodigoInterno_JustMov: entity.CodigoInterno_JustMov,
    Descricao_JustMov: entity.Descricao_JustMov,
    operationType: entity.operationType,
    FlagInterno_TipoEstoque: entity.FlagInterno_TipoEstoque,
    Nome_TipoEstoque: entity.Nome_TipoEstoque,
    CodigoInterno_TipoEstoque: entity.CodigoInterno_TipoEstoque,
  );

  TransferJustificationEntity toEntity() => TransferJustificationEntity(
    CodigoInterno_JustMov: CodigoInterno_JustMov,
    Descricao_JustMov: Descricao_JustMov,
    operationType: operationType,
    FlagInterno_TipoEstoque: FlagInterno_TipoEstoque,
    Nome_TipoEstoque: Nome_TipoEstoque,
    CodigoInterno_TipoEstoque: CodigoInterno_TipoEstoque,
  );
}

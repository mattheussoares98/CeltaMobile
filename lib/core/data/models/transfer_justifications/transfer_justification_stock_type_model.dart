import 'package:equatable/equatable.dart';

import '../../../domain/entities/transfer_justifications/justifications.dart';

class TransferJustificationStockTypeModel extends Equatable {
  final int CodigoInterno_TipoEstoque;
  final String Nome_TipoEstoque;
  final bool FlagInterno_TipoEstoque;

  const TransferJustificationStockTypeModel({
    required this.CodigoInterno_TipoEstoque,
    required this.Nome_TipoEstoque,
    required this.FlagInterno_TipoEstoque,
  });

  @override
  List<Object?> get props => [
    CodigoInterno_TipoEstoque,
    Nome_TipoEstoque,
    FlagInterno_TipoEstoque,
  ];

  factory TransferJustificationStockTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransferJustificationStockTypeModel(
      CodigoInterno_TipoEstoque: json['CodigoInterno_TipoEstoque'],
      Nome_TipoEstoque: json['Nome_TipoEstoque'],
      FlagInterno_TipoEstoque: json['FlagInterno_TipoEstoque'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'CodigoInterno_TipoEstoque': CodigoInterno_TipoEstoque,
    'Nome_TipoEstoque': Nome_TipoEstoque,
    'FlagInterno_TipoEstoque': FlagInterno_TipoEstoque,
  };

  factory TransferJustificationStockTypeModel.fromEntity(
    TransferJustificationStockTypeEntity entity,
  ) => TransferJustificationStockTypeModel(
    CodigoInterno_TipoEstoque: entity.CodigoInterno_TipoEstoque,
    Nome_TipoEstoque: entity.Nome_TipoEstoque,
    FlagInterno_TipoEstoque: entity.FlagInterno_TipoEstoque,
  );

  TransferJustificationStockTypeEntity toEntity() =>
      TransferJustificationStockTypeEntity(
        CodigoInterno_TipoEstoque: CodigoInterno_TipoEstoque,
        Nome_TipoEstoque: Nome_TipoEstoque,
        FlagInterno_TipoEstoque: FlagInterno_TipoEstoque,
      );
}

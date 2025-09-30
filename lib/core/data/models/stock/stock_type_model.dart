import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class StockTypeModel extends Equatable {
  final int? CodigoInterno_TipoEstoque; /* : 1, */
  final String Nome_TipoEstoque; /* : "Estoque Atual", */
  final bool FlagInterno_TipoEstoque; /* : true */

  const StockTypeModel({
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

  factory StockTypeModel.fromJson(Map<String, dynamic> json) {
    return StockTypeModel(
      CodigoInterno_TipoEstoque: json['CodigoInterno_TipoEstoque'],
      Nome_TipoEstoque: json['Nome_TipoEstoque'],
      FlagInterno_TipoEstoque: json['FlagInterno_TipoEstoque'],
    );
  }

  Map<String, dynamic> toJson() => {
    "CodigoInterno_TipoEstoque": CodigoInterno_TipoEstoque,
    "Nome_TipoEstoque": Nome_TipoEstoque,
    "FlagInterno_TipoEstoque": FlagInterno_TipoEstoque,
  };

  factory StockTypeModel.fromEntity(StockTypeEntity entity) => StockTypeModel(
    CodigoInterno_TipoEstoque: entity.CodigoInterno_TipoEstoque,
    Nome_TipoEstoque: entity.Nome_TipoEstoque,
    FlagInterno_TipoEstoque: entity.FlagInterno_TipoEstoque,
  );

  StockTypeEntity toEntity() => StockTypeEntity(
    CodigoInterno_TipoEstoque: CodigoInterno_TipoEstoque,
    Nome_TipoEstoque: Nome_TipoEstoque,
    FlagInterno_TipoEstoque: FlagInterno_TipoEstoque,
  );
}

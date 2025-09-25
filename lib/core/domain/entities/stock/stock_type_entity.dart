import 'package:equatable/equatable.dart';

class StockTypeEntity extends Equatable {
  final int CodigoInterno_TipoEstoque; /* : 1, */
  final String Nome_TipoEstoque; /* : "Estoque Atual", */
  final bool FlagInterno_TipoEstoque; /* : true */

  const StockTypeEntity({
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
}

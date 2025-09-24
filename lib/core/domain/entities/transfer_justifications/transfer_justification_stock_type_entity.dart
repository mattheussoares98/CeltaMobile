import 'package:equatable/equatable.dart';

class TransferJustificationStockTypeEntity extends Equatable {
  final int CodigoInterno_TipoEstoque;
  final String Nome_TipoEstoque;
  final bool FlagInterno_TipoEstoque;

  const TransferJustificationStockTypeEntity({
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

import 'package:equatable/equatable.dart';

import 'transfer_justification.dart';

class TransferJustificationsEntity extends Equatable {
  final int CodigoInterno_JustMov; /*  37, */
  final String Descricao_JustMov; /*  "SUBTRAIR", */
  final String FlagTipo_JustMov; /*  "Saída", */
  final String TypeOperator; /*  "(-)", */
  final String Nome_TipoEstoque; /*  "", */
  final TransferJustificationStockTypeEntity? CodigoInterno_TipoEstoque;

  const TransferJustificationsEntity({
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
}

import 'package:equatable/equatable.dart';

enum OperationType {
  exit(2),
  entrance(1);

  final int value;
  const OperationType(this.value);
}

class TransferJustificationEntity extends Equatable {
  final int CodigoInterno_JustMov; /*  37, */
  final String Descricao_JustMov; /*  "SUBTRAIR", */
  final OperationType operationType; /*  "2 == Saída", */
  final bool? FlagInterno_TipoEstoque; /*  "(-)", */
  final String? Nome_TipoEstoque; /*  "", */
  final int? CodigoInterno_TipoEstoque;

  const TransferJustificationEntity({
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

  TransferJustificationEntity annulValues({
    bool? annulCodigoInterno_TipoEstoque,
  }) {
    return TransferJustificationEntity(
      CodigoInterno_JustMov: CodigoInterno_JustMov,
      Descricao_JustMov: Descricao_JustMov,
      operationType: operationType,
      FlagInterno_TipoEstoque: FlagInterno_TipoEstoque,
      Nome_TipoEstoque: Nome_TipoEstoque,
      CodigoInterno_TipoEstoque: annulCodigoInterno_TipoEstoque == true
          ? null
          : CodigoInterno_TipoEstoque,
    );
  }
}

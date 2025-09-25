import 'package:equatable/equatable.dart';

class TransferJustificationEntity extends Equatable {
  final int CodigoInterno_JustMov; /*  37, */
  final String Descricao_JustMov; /*  "SUBTRAIR", */
  final int FlagTipo_JustMov; /*  "Saída", */
  final bool? FlagInterno_TipoEstoque; /*  "(-)", */
  final String? Nome_TipoEstoque; /*  "", */
  final int? CodigoInterno_TipoEstoque;

  const TransferJustificationEntity({
    required this.CodigoInterno_JustMov,
    required this.Descricao_JustMov,
    required this.FlagTipo_JustMov,
    required this.FlagInterno_TipoEstoque,
    required this.Nome_TipoEstoque,
    required this.CodigoInterno_TipoEstoque,
  });

  @override
  List<Object?> get props => [
    CodigoInterno_JustMov,
    Descricao_JustMov,
    FlagTipo_JustMov,
    FlagInterno_TipoEstoque,
    Nome_TipoEstoque,
    CodigoInterno_TipoEstoque,
  ];
}

import 'package:equatable/equatable.dart';

class FrozenProcessEntity extends Equatable {
  final int CodigoInternoInventario;
  final DateTime CataCriacaoInventario;
  final DateTime DataCongelamentoInventario;
  final int CodigoInternoEmpresa;
  final String NomeTipoEstoque;
  final String ObsInventario;
  final String NomeFuncionario;
  final String NomeEmpresa;
  final String CodigoEmpresa;

  const FrozenProcessEntity({
    required this.CodigoInternoInventario,
    required this.CataCriacaoInventario,
    required this.DataCongelamentoInventario,
    required this.NomeTipoEstoque,
    required this.ObsInventario,
    required this.NomeFuncionario,
    required this.NomeEmpresa,
    required this.CodigoInternoEmpresa,
    required this.CodigoEmpresa,
  });

  @override
  List<Object?> get props => [
    CodigoInternoInventario,
    CataCriacaoInventario,
    DataCongelamentoInventario,
    NomeTipoEstoque,
    ObsInventario,
    NomeFuncionario,
    NomeEmpresa,
    CodigoInternoEmpresa,
    CodigoEmpresa,
  ];
}

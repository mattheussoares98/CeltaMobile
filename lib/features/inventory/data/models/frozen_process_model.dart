import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class FrozenProcessModel extends Equatable {
  final int CodigoInternoInventario;
  final DateTime CataCriacaoInventario;
  final DateTime DataCongelamentoInventario;
  final int CodigoInternoEmpresa;
  final String NomeTipoEstoque;
  final String? ObsInventario;
  final String NomeFuncionario;
  final String NomeEmpresa;
  final String CodigoEmpresa;

  const FrozenProcessModel({
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

  factory FrozenProcessModel.fromJson(Map json) {
    return FrozenProcessModel(
      CataCriacaoInventario: DateTime.parse(json['DataCriacao_Inventario']),
      DataCongelamentoInventario: DateTime.parse(
        json['DataCongelamento_Inventario'],
      ),
      CodigoInternoInventario: int.parse(json['CodigoInterno_Inventario']),
      CodigoInternoEmpresa: int.parse(json['CodigoInterno_Empresa1']),
      CodigoEmpresa: json['Codigo_Empresa'],
      NomeTipoEstoque: json['Nome_TipoEstoque'],
      ObsInventario: json['Obs_Inventario'],
      NomeFuncionario: json['Nome_Funcionario'],
      NomeEmpresa: json['Nome_Empresa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodigoInterno_Inventario': CodigoInternoInventario.toString(),
      'CodigoInterno_Empresa1': CodigoInternoEmpresa.toString(),
      'DataCriacao_Inventario': CataCriacaoInventario.toIso8601String(),
      'DataCongelamento_Inventario':
          DataCongelamentoInventario.toIso8601String(),
      'Nome_TipoEstoque': NomeTipoEstoque,
      'Obs_Inventario': ObsInventario,
      'Nome_Funcionario': NomeFuncionario,
      'Nome_Empresa': NomeEmpresa,
      'Codigo_Empresa': CodigoEmpresa,
    };
  }

  FrozenProcessEntity toEntity() => FrozenProcessEntity(
    CodigoInternoInventario: CodigoInternoInventario,
    CataCriacaoInventario: CataCriacaoInventario,
    DataCongelamentoInventario: DataCongelamentoInventario,
    NomeTipoEstoque: NomeTipoEstoque,
    ObsInventario: ObsInventario,
    NomeFuncionario: NomeFuncionario,
    NomeEmpresa: NomeEmpresa,
    CodigoInternoEmpresa: CodigoInternoEmpresa,
    CodigoEmpresa: CodigoEmpresa,
  );

  factory FrozenProcessModel.fromEntity(FrozenProcessEntity entity) =>
      FrozenProcessModel(
        CodigoInternoInventario: entity.CodigoInternoInventario,
        CataCriacaoInventario: entity.CataCriacaoInventario,
        DataCongelamentoInventario: entity.DataCongelamentoInventario,
        NomeTipoEstoque: entity.NomeTipoEstoque,
        ObsInventario: entity.ObsInventario,
        NomeFuncionario: entity.NomeFuncionario,
        NomeEmpresa: entity.NomeEmpresa,
        CodigoInternoEmpresa: entity.CodigoInternoEmpresa,
        CodigoEmpresa: entity.CodigoEmpresa,
      );
}

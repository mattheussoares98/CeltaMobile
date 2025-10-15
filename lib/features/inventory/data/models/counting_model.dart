import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class CountingModel extends Equatable {
  final int CodigoInternoInvCont;
  final int NumeroContagemInvCont;
  final int FlagTipoContagemInvCont;
  final int CodigoInternoInventario;
  final String? ObsInvCont;

  const CountingModel({
    required this.CodigoInternoInvCont,
    required this.FlagTipoContagemInvCont,
    required this.CodigoInternoInventario,
    required this.NumeroContagemInvCont,
    required this.ObsInvCont,
  });

  @override
  List<Object?> get props => [
    CodigoInternoInvCont,
    FlagTipoContagemInvCont,
    CodigoInternoInventario,
    NumeroContagemInvCont,
    ObsInvCont,
  ];

  factory CountingModel.fromJson(Map json) => CountingModel(
    CodigoInternoInvCont: json['CodigoInterno_InvCont'],
    FlagTipoContagemInvCont: json['FlagTipoContagem_InvCont'],
    CodigoInternoInventario: json['CodigoInterno_Inventario'],
    NumeroContagemInvCont: json['NumeroContagem_InvCont'],
    ObsInvCont: json['Obs_InvCont'],
  );

  Map<String, dynamic> toJson() => {
    'CodigoInterno_InvCont': CodigoInternoInvCont,
    'FlagTipoContagem_InvCont': FlagTipoContagemInvCont,
    'CodigoInterno_Inventario': CodigoInternoInventario,
    'NumeroContagem_InvCont': NumeroContagemInvCont,
    'Obs_InvCont': ObsInvCont,
  };

  CountingEntity toEntity() => CountingEntity(
    CodigoInternoInvCont: CodigoInternoInvCont,
    FlagTipoContagemInvCont: FlagTipoContagemInvCont,
    CodigoInternoInventario: CodigoInternoInventario,
    NumeroContagemInvCont: NumeroContagemInvCont,
    ObsInvCont: ObsInvCont,
  );

  factory CountingModel.fromEntity(CountingEntity entity) => CountingModel(
    CodigoInternoInvCont: entity.CodigoInternoInvCont,
    FlagTipoContagemInvCont: entity.FlagTipoContagemInvCont,
    CodigoInternoInventario: entity.CodigoInternoInventario,
    NumeroContagemInvCont: entity.NumeroContagemInvCont,
    ObsInvCont: entity.ObsInvCont,
  );
}

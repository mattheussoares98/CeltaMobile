import 'package:equatable/equatable.dart';

class CountingEntity extends Equatable {
  final int CodigoInternoInvCont;
  final int NumeroContagemInvCont;
  final int FlagTipoContagemInvCont;
  final int CodigoInternoInventario;
  final String? ObsInvCont;

  const CountingEntity({
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
}

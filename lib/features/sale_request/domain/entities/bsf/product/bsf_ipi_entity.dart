import 'package:equatable/equatable.dart';

class BSFIpiEntity extends Equatable {
  final double? aliquot;
  final int? type;
  final String? tributarySituation;
  final String? fiscalObservation;
  final bool? isValid;

  const BSFIpiEntity({
    required this.aliquot,
    required this.type,
    required this.tributarySituation,
    required this.fiscalObservation,
    required this.isValid,
  });

  @override
  List<Object?> get props => [
    aliquot,
    type,
    tributarySituation,
    fiscalObservation,
    isValid,
  ];
}

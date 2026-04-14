import 'package:equatable/equatable.dart';

class BSFTributarySituationEntity extends Equatable {
  final String? code;
  final String? codeCSOSN;
  final String? description;
  final String? fiscalBenefitCodeStatesRequired;
  final int? tributation;
  final int? originType;
  final bool? isSubstitution;
  final bool? isImported;

  const BSFTributarySituationEntity({
    required this.code,
    required this.codeCSOSN,
    required this.description,
    required this.fiscalBenefitCodeStatesRequired,
    required this.tributation,
    required this.originType,
    required this.isSubstitution,
    required this.isImported,
  });

  @override
  List<Object?> get props => [
    code,
    codeCSOSN,
    description,
    fiscalBenefitCodeStatesRequired,
    tributation,
    originType,
    isSubstitution,
    isImported,
  ];
}

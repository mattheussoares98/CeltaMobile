import 'package:equatable/equatable.dart';

class BsfSaleBlockadeInstructionEntity extends Equatable {
  final int? code;
  final String? personalizedCode;
  final String? legacyCode;
  final String? description;

  const BsfSaleBlockadeInstructionEntity({
    required this.code,
    required this.personalizedCode,
    required this.legacyCode,
    required this.description,
  });

  @override
  List<Object?> get props => [
        code,
        personalizedCode,
        legacyCode,
        description,
      ];

  BsfSaleBlockadeInstructionEntity copyWith({
    int? code,
    String? personalizedCode,
    String? legacyCode,
    String? description,
  }) {
    return BsfSaleBlockadeInstructionEntity(
      code: code ?? this.code,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      legacyCode: legacyCode ?? this.legacyCode,
      description: description ?? this.description,
    );
  }
}

import 'package:equatable/equatable.dart';

class CustomerSaleBlockadeInstructionEntity extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String LegacyCode;
  final String Description;
  const CustomerSaleBlockadeInstructionEntity({
    required this.Code,
    required this.PersonalizedCode,
    required this.LegacyCode,
    required this.Description,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, LegacyCode, Description];

  CustomerSaleBlockadeInstructionEntity copyWith({
    int? Code,
    String? PersonalizedCode,
    String? LegacyCode,
    String? Description,
  }) {
    return CustomerSaleBlockadeInstructionEntity(
      Code: Code ?? this.Code,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      LegacyCode: LegacyCode ?? this.LegacyCode,
      Description: Description ?? this.Description,
    );
  }
}

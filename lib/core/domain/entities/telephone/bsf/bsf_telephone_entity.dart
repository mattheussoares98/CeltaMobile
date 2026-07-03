// lib/core/domain/entities/telephone/bsf/bsf_telephone_entity.dart
import 'package:equatable/equatable.dart';

class BSFTelephoneEntity extends Equatable {
  final int? code;
  final int? customerCode;
  final String? areaCode;
  final String? phoneNumber;
  final String? phoneComplement;
  final String? telephoneExtension;
  final String? name;
  final bool? mainPhone;
  final int? phoneType;
  final bool? isValid;
  final bool? isWellFormatted;
  final bool? areaCodeIsRequired;

  const BSFTelephoneEntity({
    this.code,
    this.customerCode,
    this.areaCode,
    this.phoneNumber,
    this.phoneComplement,
    this.telephoneExtension,
    this.name,
    this.mainPhone,
    this.phoneType,
    this.isValid,
    this.isWellFormatted,
    this.areaCodeIsRequired,
  });

  @override
  List<Object?> get props => [
        code,
        customerCode,
        areaCode,
        phoneNumber,
        phoneComplement,
        telephoneExtension,
        name,
        mainPhone,
        phoneType,
        isValid,
        isWellFormatted,
        areaCodeIsRequired,
      ];
}

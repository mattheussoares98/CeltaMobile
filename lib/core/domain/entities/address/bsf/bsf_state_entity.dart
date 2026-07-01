import 'package:equatable/equatable.dart';

class BSFStateEntity extends Equatable {
  final String? code;
  final String? acronym;
  final String? description;
  final Map<String, dynamic>? extensions;
  final double? nationalSimpleLimitByStateForSmallCompany;
  final bool? containsValidNationalStateCode;
  final int? nationalStateCode;
  final bool? isSignatoryDIFAL;
  final bool? isDoubleBaseDIFAL;
  final bool? isDIFALInOperationValue;
  final bool? icmsIncludedInPrice;
  final bool? icmsSubtractedInPrice;
  final bool? allowEmissionNFeByNFCe;

  const BSFStateEntity({
    this.code,
    required this.acronym,
    required this.description,
    this.extensions,
    this.nationalSimpleLimitByStateForSmallCompany,
    this.containsValidNationalStateCode,
    this.nationalStateCode,
    this.isSignatoryDIFAL,
    this.isDoubleBaseDIFAL,
    this.isDIFALInOperationValue,
    this.icmsIncludedInPrice,
    this.icmsSubtractedInPrice,
    this.allowEmissionNFeByNFCe,
  });

  @override
  List<Object?> get props => [
        code,
        acronym,
        description,
        extensions,
        nationalSimpleLimitByStateForSmallCompany,
        containsValidNationalStateCode,
        nationalStateCode,
        isSignatoryDIFAL,
        isDoubleBaseDIFAL,
        isDIFALInOperationValue,
        icmsIncludedInPrice,
        icmsSubtractedInPrice,
        allowEmissionNFeByNFCe,
      ];
}

import 'package:equatable/equatable.dart';

import 'entities.dart';

class BsfFiscalClassificationEntity extends Equatable {
  final int code;
  final String personalizedCode;
  final String complement;
  final String description;
  final String observations;
  final String legacyCode;
  final String natureOperationRecipeCodePISCOFINS;
  final int spedType;
  final int pisCofinsApurationType;
  final bool possessIpiTypeInformation;
  final bool possessPisCofinsTypeInformation;
  final BsfFiscalClassificationIpiEntity ipi;
  final int pisType;
  final int cofinsType;
  final double aliquotCredPresumedOfPis;
  final double aliquotCredPresumedOfCofins;
  final double aliquotImportPis;
  final double aliquotImportCofins;
  final double aliquotImportTax;
  final double percentageReducionBenefitPisCofins;
  final double aliquotIcmsInterState;
  final int pisCofinsTypeScheduling;
  final String natureOperationRecipeCodePISCOFINSScheduling;
  final String datePisCofinsTypeScheduling;
  final String dateTimeOfImport;
  final bool isIncludeInAccordingIcmsSpecialRegimeForWholesale;
  final bool isPetroleumDerivative;
  final String cest;
  final String internalImportCadasterCode;
  final bool isIncludeInIcmsSpecialRegimeForMeasure;
  final bool isPresumedPis;
  final bool isPresumedCofins;
  final bool isEspecialRegimeCadaster;
  final double cbsAliquot;
  final double cbsReduction;
  final String cbsCst;
  final String cbsCodeClassification;
  final String hash;

  const BsfFiscalClassificationEntity({
    required this.code,
    required this.personalizedCode,
    required this.complement,
    required this.description,
    required this.observations,
    required this.legacyCode,
    required this.natureOperationRecipeCodePISCOFINS,
    required this.spedType,
    required this.pisCofinsApurationType,
    required this.possessIpiTypeInformation,
    required this.possessPisCofinsTypeInformation,
    required this.ipi,
    required this.pisType,
    required this.cofinsType,
    required this.aliquotCredPresumedOfPis,
    required this.aliquotCredPresumedOfCofins,
    required this.aliquotImportPis,
    required this.aliquotImportCofins,
    required this.aliquotImportTax,
    required this.percentageReducionBenefitPisCofins,
    required this.aliquotIcmsInterState,
    required this.pisCofinsTypeScheduling,
    required this.natureOperationRecipeCodePISCOFINSScheduling,
    required this.datePisCofinsTypeScheduling,
    required this.dateTimeOfImport,
    required this.isIncludeInAccordingIcmsSpecialRegimeForWholesale,
    required this.isPetroleumDerivative,
    required this.cest,
    required this.internalImportCadasterCode,
    required this.isIncludeInIcmsSpecialRegimeForMeasure,
    required this.isPresumedPis,
    required this.isPresumedCofins,
    required this.isEspecialRegimeCadaster,
    required this.cbsAliquot,
    required this.cbsReduction,
    required this.cbsCst,
    required this.cbsCodeClassification,
    required this.hash,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    complement,
    description,
    observations,
    legacyCode,
    natureOperationRecipeCodePISCOFINS,
    spedType,
    pisCofinsApurationType,
    possessIpiTypeInformation,
    possessPisCofinsTypeInformation,
    ipi,
    pisType,
    cofinsType,
    aliquotCredPresumedOfPis,
    aliquotCredPresumedOfCofins,
    aliquotImportPis,
    aliquotImportCofins,
    aliquotImportTax,
    percentageReducionBenefitPisCofins,
    aliquotIcmsInterState,
    pisCofinsTypeScheduling,
    natureOperationRecipeCodePISCOFINSScheduling,
    datePisCofinsTypeScheduling,
    dateTimeOfImport,
    isIncludeInAccordingIcmsSpecialRegimeForWholesale,
    isPetroleumDerivative,
    cest,
    internalImportCadasterCode,
    isIncludeInIcmsSpecialRegimeForMeasure,
    isPresumedPis,
    isPresumedCofins,
    isEspecialRegimeCadaster,
    cbsAliquot,
    cbsReduction,
    cbsCst,
    cbsCodeClassification,
    hash,
  ];
}

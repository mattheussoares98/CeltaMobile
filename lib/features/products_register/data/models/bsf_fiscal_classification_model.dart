import 'package:celta_inventario/features/products_register/data/models/bsf_fiscal_classification_ipi_model.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';

class BsfFiscalClassificationModel extends BsfFiscalClassificationEntity {
  const BsfFiscalClassificationModel({
    required super.code,
    required super.personalizedCode,
    required super.complement,
    required super.description,
    required super.observations,
    required super.legacyCode,
    required super.natureOperationRecipeCodePISCOFINS,
    required super.spedType,
    required super.pisCofinsApurationType,
    required super.possessIpiTypeInformation,
    required super.possessPisCofinsTypeInformation,
    required super.ipi,
    required super.pisType,
    required super.cofinsType,
    required super.aliquotCredPresumedOfPis,
    required super.aliquotCredPresumedOfCofins,
    required super.aliquotImportPis,
    required super.aliquotImportCofins,
    required super.aliquotImportTax,
    required super.percentageReducionBenefitPisCofins,
    required super.aliquotIcmsInterState,
    required super.pisCofinsTypeScheduling,
    required super.natureOperationRecipeCodePISCOFINSScheduling,
    required super.datePisCofinsTypeScheduling,
    required super.dateTimeOfImport,
    required super.isIncludeInAccordingIcmsSpecialRegimeForWholesale,
    required super.isPetroleumDerivative,
    required super.cest,
    required super.internalImportCadasterCode,
    required super.isIncludeInIcmsSpecialRegimeForMeasure,
    required super.isPresumedPis,
    required super.isPresumedCofins,
    required super.isEspecialRegimeCadaster,
    required super.cbsAliquot,
    required super.cbsReduction,
    required super.cbsCst,
    required super.cbsCodeClassification,
    required super.hash,
  });

  factory BsfFiscalClassificationModel.fromJson(Map json) {
    return BsfFiscalClassificationModel(
      code: json['Code'] as int,
      personalizedCode: json['PersonalizedCode'] as String,
      complement: json['Complement'] as String,
      description: json['Description'] as String,
      observations: json['Observations'] as String,
      legacyCode: json['LegacyCode'] as String,
      natureOperationRecipeCodePISCOFINS:
          json['NatureOperationRecipeCodePISCOFINS'] as String,
      spedType: json['SPEDType'] as int,
      pisCofinsApurationType: json['PisCofinsApurationType'] as int,
      possessIpiTypeInformation: json['PossessIpiTypeInformation'] as bool,
      possessPisCofinsTypeInformation:
          json['PossessPisCofinsTypeInformation'] as bool,
      ipi: BsfFiscalClassificationIpiModel.fromJson(json['Ipi'] as Map),
      pisType: json['PisType'] as int,
      cofinsType: json['CofinsType'] as int,
      aliquotCredPresumedOfPis: (json['AliquotCredPresumedOfPis'] as num)
          .toDouble(),
      aliquotCredPresumedOfCofins: (json['AliquotCredPresumedOfCofins'] as num)
          .toDouble(),
      aliquotImportPis: (json['AliquotImportPis'] as num).toDouble(),
      aliquotImportCofins: (json['AliquotImportCofins'] as num).toDouble(),
      aliquotImportTax: (json['AliquotImportTax'] as num).toDouble(),
      percentageReducionBenefitPisCofins:
          (json['PercentageReducionBenefitPisCofins'] as num).toDouble(),
      aliquotIcmsInterState: (json['AliquotIcmsInterState'] as num).toDouble(),
      pisCofinsTypeScheduling: json['PisCofinsTypeScheduling'] as int,
      natureOperationRecipeCodePISCOFINSScheduling:
          json['NatureOperationRecipeCodePISCOFINSScheduling'] as String,
      datePisCofinsTypeScheduling:
          json['DatePisCofinsTypeScheduling'] as String,
      dateTimeOfImport: json['DateTimeOfImport'] as String,
      isIncludeInAccordingIcmsSpecialRegimeForWholesale:
          json['IsIncludeInAccordingIcmsSpecialRegimeForWholesale'] as bool,
      isPetroleumDerivative: json['IsPetroleumDerivative'] as bool,
      cest: json['Cest'] as String,
      internalImportCadasterCode: json['InternalImportCadasterCode'] as String,
      isIncludeInIcmsSpecialRegimeForMeasure:
          json['IsIncludeInIcmsSpecialRegimeForMeasure'] as bool,
      isPresumedPis: json['IsPresumedPis'] as bool,
      isPresumedCofins: json['IsPresumedCofins'] as bool,
      isEspecialRegimeCadaster: json['IsEspecialRegimeCadaster'] as bool,
      cbsAliquot: (json['CBSAliquot'] as num).toDouble(),
      cbsReduction: (json['CBSReduction'] as num).toDouble(),
      cbsCst: json['CBSCst'] as String,
      cbsCodeClassification: json['CBSCodeClassification'] as String,
      hash: json['Hash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'PersonalizedCode': personalizedCode,
      'Complement': complement,
      'Description': description,
      'Observations': observations,
      'LegacyCode': legacyCode,
      'NatureOperationRecipeCodePISCOFINS': natureOperationRecipeCodePISCOFINS,
      'SPEDType': spedType,
      'PisCofinsApurationType': pisCofinsApurationType,
      'PossessIpiTypeInformation': possessIpiTypeInformation,
      'PossessPisCofinsTypeInformation': possessPisCofinsTypeInformation,
      'Ipi': BsfFiscalClassificationIpiModel.fromEntity(ipi).toJson(),
      'PisType': pisType,
      'CofinsType': cofinsType,
      'AliquotCredPresumedOfPis': aliquotCredPresumedOfPis,
      'AliquotCredPresumedOfCofins': aliquotCredPresumedOfCofins,
      'AliquotImportPis': aliquotImportPis,
      'AliquotImportCofins': aliquotImportCofins,
      'AliquotImportTax': aliquotImportTax,
      'PercentageReducionBenefitPisCofins': percentageReducionBenefitPisCofins,
      'AliquotIcmsInterState': aliquotIcmsInterState,
      'PisCofinsTypeScheduling': pisCofinsTypeScheduling,
      'NatureOperationRecipeCodePISCOFINSScheduling':
          natureOperationRecipeCodePISCOFINSScheduling,
      'DatePisCofinsTypeScheduling': datePisCofinsTypeScheduling,
      'DateTimeOfImport': dateTimeOfImport,
      'IsIncludeInAccordingIcmsSpecialRegimeForWholesale':
          isIncludeInAccordingIcmsSpecialRegimeForWholesale,
      'IsPetroleumDerivative': isPetroleumDerivative,
      'Cest': cest,
      'InternalImportCadasterCode': internalImportCadasterCode,
      'IsIncludeInIcmsSpecialRegimeForMeasure':
          isIncludeInIcmsSpecialRegimeForMeasure,
      'IsPresumedPis': isPresumedPis,
      'IsPresumedCofins': isPresumedCofins,
      'IsEspecialRegimeCadaster': isEspecialRegimeCadaster,
      'CBSAliquot': cbsAliquot,
      'CBSReduction': cbsReduction,
      'CBSCst': cbsCst,
      'CBSCodeClassification': cbsCodeClassification,
      'Hash': hash,
    };
  }

  factory BsfFiscalClassificationModel.fromEntity(
    BsfFiscalClassificationEntity entity,
  ) {
    return BsfFiscalClassificationModel(
      code: entity.code,
      personalizedCode: entity.personalizedCode,
      complement: entity.complement,
      description: entity.description,
      observations: entity.observations,
      legacyCode: entity.legacyCode,
      natureOperationRecipeCodePISCOFINS:
          entity.natureOperationRecipeCodePISCOFINS,
      spedType: entity.spedType,
      pisCofinsApurationType: entity.pisCofinsApurationType,
      possessIpiTypeInformation: entity.possessIpiTypeInformation,
      possessPisCofinsTypeInformation: entity.possessPisCofinsTypeInformation,
      ipi: BsfFiscalClassificationIpiModel.fromEntity(entity.ipi),
      pisType: entity.pisType,
      cofinsType: entity.cofinsType,
      aliquotCredPresumedOfPis: entity.aliquotCredPresumedOfPis,
      aliquotCredPresumedOfCofins: entity.aliquotCredPresumedOfCofins,
      aliquotImportPis: entity.aliquotImportPis,
      aliquotImportCofins: entity.aliquotImportCofins,
      aliquotImportTax: entity.aliquotImportTax,
      percentageReducionBenefitPisCofins:
          entity.percentageReducionBenefitPisCofins,
      aliquotIcmsInterState: entity.aliquotIcmsInterState,
      pisCofinsTypeScheduling: entity.pisCofinsTypeScheduling,
      natureOperationRecipeCodePISCOFINSScheduling:
          entity.natureOperationRecipeCodePISCOFINSScheduling,
      datePisCofinsTypeScheduling: entity.datePisCofinsTypeScheduling,
      dateTimeOfImport: entity.dateTimeOfImport,
      isIncludeInAccordingIcmsSpecialRegimeForWholesale:
          entity.isIncludeInAccordingIcmsSpecialRegimeForWholesale,
      isPetroleumDerivative: entity.isPetroleumDerivative,
      cest: entity.cest,
      internalImportCadasterCode: entity.internalImportCadasterCode,
      isIncludeInIcmsSpecialRegimeForMeasure:
          entity.isIncludeInIcmsSpecialRegimeForMeasure,
      isPresumedPis: entity.isPresumedPis,
      isPresumedCofins: entity.isPresumedCofins,
      isEspecialRegimeCadaster: entity.isEspecialRegimeCadaster,
      cbsAliquot: entity.cbsAliquot,
      cbsReduction: entity.cbsReduction,
      cbsCst: entity.cbsCst,
      cbsCodeClassification: entity.cbsCodeClassification,
      hash: entity.hash,
    );
  }

  BsfFiscalClassificationEntity toEntity() {
    return BsfFiscalClassificationEntity(
      code: code,
      personalizedCode: personalizedCode,
      complement: complement,
      description: description,
      observations: observations,
      legacyCode: legacyCode,
      natureOperationRecipeCodePISCOFINS: natureOperationRecipeCodePISCOFINS,
      spedType: spedType,
      pisCofinsApurationType: pisCofinsApurationType,
      possessIpiTypeInformation: possessIpiTypeInformation,
      possessPisCofinsTypeInformation: possessPisCofinsTypeInformation,
      ipi: ipi,
      pisType: pisType,
      cofinsType: cofinsType,
      aliquotCredPresumedOfPis: aliquotCredPresumedOfPis,
      aliquotCredPresumedOfCofins: aliquotCredPresumedOfCofins,
      aliquotImportPis: aliquotImportPis,
      aliquotImportCofins: aliquotImportCofins,
      aliquotImportTax: aliquotImportTax,
      percentageReducionBenefitPisCofins: percentageReducionBenefitPisCofins,
      aliquotIcmsInterState: aliquotIcmsInterState,
      pisCofinsTypeScheduling: pisCofinsTypeScheduling,
      natureOperationRecipeCodePISCOFINSScheduling:
          natureOperationRecipeCodePISCOFINSScheduling,
      datePisCofinsTypeScheduling: datePisCofinsTypeScheduling,
      dateTimeOfImport: dateTimeOfImport,
      isIncludeInAccordingIcmsSpecialRegimeForWholesale:
          isIncludeInAccordingIcmsSpecialRegimeForWholesale,
      isPetroleumDerivative: isPetroleumDerivative,
      cest: cest,
      internalImportCadasterCode: internalImportCadasterCode,
      isIncludeInIcmsSpecialRegimeForMeasure:
          isIncludeInIcmsSpecialRegimeForMeasure,
      isPresumedPis: isPresumedPis,
      isPresumedCofins: isPresumedCofins,
      isEspecialRegimeCadaster: isEspecialRegimeCadaster,
      cbsAliquot: cbsAliquot,
      cbsReduction: cbsReduction,
      cbsCst: cbsCst,
      cbsCodeClassification: cbsCodeClassification,
      hash: hash,
    );
  }
}

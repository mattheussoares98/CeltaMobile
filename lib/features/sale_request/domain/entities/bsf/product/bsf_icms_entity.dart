import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/bsf/product/bsf_tributary_situation_entity.dart';

class BSFIcmsEntity extends Equatable {
  final dynamic taxOnState;
  final bool? haveCovenantBetweenStates;
  final bool? utilizeIVASTAdjusted;
  final bool? simplifiedEstimationScheme;
  final double? reductionMargin;
  final double? iVAMargin;
  final double? reductionIVAMarginForFederalSimple;
  final double? aliquot;
  final double? aditionalIcmsAliquotFEM;
  final double? stave;
  final double? taxeAliquotNational;
  final double? taxeAliquotImport;
  final double? taxeAliquotState;
  final double? taxeAliquotMunicipal;
  final double? taxeAliquotFederal;
  final int? reductionType;
  final bool? allowReductionMargin;
  final bool? allowIVAMargin;
  final bool? allowIcmsAliquot;
  final bool? reductionMarginIsRequired;
  final bool? icmsAliquotIsRequired;
  final bool? isValidReductionMargin;
  final bool? isValidIVAMargin;
  final bool? isValidIcmsAliquot;
  final bool? isValidAditionalIcmsAliquotFEM;
  final bool? isValidReductionType;
  final bool? containsFiscalAdjuste;
  final bool? isValidFiscalAdjuste;
  final bool? isImporter;
  final bool? isImporterAcquiredDomestic;
  final double? originalAliquot;
  final String? fiscalAdjustCode;
  final String? fiscalBenefitCode;
  final BSFTributarySituationEntity? tributarySituation;
  final String? fiscalObservation;
  final String? fiscalAdjustObservation;
  final dynamic stateInternalIcms;

  const BSFIcmsEntity({
    required this.taxOnState,
    required this.haveCovenantBetweenStates,
    required this.utilizeIVASTAdjusted,
    required this.simplifiedEstimationScheme,
    required this.reductionMargin,
    required this.iVAMargin,
    required this.reductionIVAMarginForFederalSimple,
    required this.aliquot,
    required this.aditionalIcmsAliquotFEM,
    required this.stave,
    required this.taxeAliquotNational,
    required this.taxeAliquotImport,
    required this.taxeAliquotState,
    required this.taxeAliquotMunicipal,
    required this.taxeAliquotFederal,
    required this.reductionType,
    required this.allowReductionMargin,
    required this.allowIVAMargin,
    required this.allowIcmsAliquot,
    required this.reductionMarginIsRequired,
    required this.icmsAliquotIsRequired,
    required this.isValidReductionMargin,
    required this.isValidIVAMargin,
    required this.isValidIcmsAliquot,
    required this.isValidAditionalIcmsAliquotFEM,
    required this.isValidReductionType,
    required this.containsFiscalAdjuste,
    required this.isValidFiscalAdjuste,
    required this.isImporter,
    required this.isImporterAcquiredDomestic,
    required this.originalAliquot,
    required this.fiscalAdjustCode,
    required this.fiscalBenefitCode,
    required this.tributarySituation,
    required this.fiscalObservation,
    required this.fiscalAdjustObservation,
    required this.stateInternalIcms,
  });

  @override
  List<Object?> get props => [
    taxOnState,
    haveCovenantBetweenStates,
    utilizeIVASTAdjusted,
    simplifiedEstimationScheme,
    reductionMargin,
    iVAMargin,
    reductionIVAMarginForFederalSimple,
    aliquot,
    aditionalIcmsAliquotFEM,
    stave,
    taxeAliquotNational,
    taxeAliquotImport,
    taxeAliquotState,
    taxeAliquotMunicipal,
    taxeAliquotFederal,
    reductionType,
    allowReductionMargin,
    allowIVAMargin,
    allowIcmsAliquot,
    reductionMarginIsRequired,
    icmsAliquotIsRequired,
    isValidReductionMargin,
    isValidIVAMargin,
    isValidIcmsAliquot,
    isValidAditionalIcmsAliquotFEM,
    isValidReductionType,
    containsFiscalAdjuste,
    isValidFiscalAdjuste,
    isImporter,
    isImporterAcquiredDomestic,
    originalAliquot,
    fiscalAdjustCode,
    fiscalBenefitCode,
    tributarySituation,
    fiscalObservation,
    fiscalAdjustObservation,
    stateInternalIcms,
  ];
}

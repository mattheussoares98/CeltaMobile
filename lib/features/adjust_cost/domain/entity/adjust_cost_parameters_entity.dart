import 'package:equatable/equatable.dart';

import 'entity.dart';

class AdjustCostParametersEntity extends Equatable {
  final int ProductCode;
  final int EnterpriseCode;
  final int PackingCode;
  final double ReplacementCost;
  final double LiquidCost;
  final double LastUnitValue;
  final double BaseCalcIcmsSubstUnit;
  final double ValueOfIcmsSubstUnit;
  final double ValueOfIcmsOwnerUnit;
  final double FiscalBaseCalcSubstitute;
  final double ReplacementCostReal;
  final double LiquidCostReal;
  final double ReplacementCostFiscal;
  final double LiquidCostFiscal;
  final AdjustCostActualizationType? ActualizationType;
  final bool? ActualizeDataAfterUpdate;
  final bool? UpdateEnterpriseGroup;
  final bool? UpdateCostClass;
  final bool? UpdateChildCost;

  const AdjustCostParametersEntity({
    this.ActualizeDataAfterUpdate,
    this.UpdateChildCost,
    this.UpdateCostClass,
    this.UpdateEnterpriseGroup,
    this.ActualizationType,
    required this.ProductCode,
    required this.EnterpriseCode,
    required this.PackingCode,
    required this.ReplacementCost,
    required this.LiquidCost,
    required this.LastUnitValue,
    required this.BaseCalcIcmsSubstUnit,
    required this.ValueOfIcmsSubstUnit,
    required this.ValueOfIcmsOwnerUnit,
    required this.FiscalBaseCalcSubstitute,
    required this.ReplacementCostReal,
    required this.LiquidCostReal,
    required this.ReplacementCostFiscal,
    required this.LiquidCostFiscal,
  });

  @override
  List<Object?> get props => [
    ProductCode,
    EnterpriseCode,
    PackingCode,
    UpdateCostClass,
    UpdateChildCost,
    ReplacementCost,
    LiquidCost,
    LastUnitValue,
    BaseCalcIcmsSubstUnit,
    ValueOfIcmsSubstUnit,
    ValueOfIcmsOwnerUnit,
    FiscalBaseCalcSubstitute,
    ReplacementCostReal,
    LiquidCostReal,
    ReplacementCostFiscal,
    LiquidCostFiscal,
    ActualizationType,
    ActualizeDataAfterUpdate,
    UpdateEnterpriseGroup,
  ];

  AdjustCostParametersEntity copyWith({
    int? ProductCode,
    int? EnterpriseCode,
    int? PackingCode,
    bool? UpdateCostClass,
    bool? UpdateChildCost,
    double? ReplacementCost,
    double? LiquidCost,
    double? LastUnitValue,
    double? BaseCalcIcmsSubstUnit,
    double? ValueOfIcmsSubstUnit,
    double? ValueOfIcmsOwnerUnit,
    double? FiscalBaseCalcSubstitute,
    double? ReplacementCostReal,
    double? LiquidCostReal,
    double? ReplacementCostFiscal,
    double? LiquidCostFiscal,
    AdjustCostActualizationType? ActualizationType,
    bool? ActualizeDataAfterUpdate,
    bool? UpdateEnterpriseGroup,
  }) {
    return AdjustCostParametersEntity(
      ProductCode: ProductCode ?? this.ProductCode,
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      PackingCode: PackingCode ?? this.PackingCode,
      UpdateCostClass: UpdateCostClass ?? this.UpdateCostClass,
      UpdateChildCost: UpdateChildCost ?? this.UpdateChildCost,
      ReplacementCost: ReplacementCost ?? this.ReplacementCost,
      LiquidCost: LiquidCost ?? this.LiquidCost,
      LastUnitValue: LastUnitValue ?? this.LastUnitValue,
      BaseCalcIcmsSubstUnit:
          BaseCalcIcmsSubstUnit ?? this.BaseCalcIcmsSubstUnit,
      ValueOfIcmsSubstUnit: ValueOfIcmsSubstUnit ?? this.ValueOfIcmsSubstUnit,
      ValueOfIcmsOwnerUnit: ValueOfIcmsOwnerUnit ?? this.ValueOfIcmsOwnerUnit,
      FiscalBaseCalcSubstitute:
          FiscalBaseCalcSubstitute ?? this.FiscalBaseCalcSubstitute,
      ReplacementCostReal: ReplacementCostReal ?? this.ReplacementCostReal,
      LiquidCostReal: LiquidCostReal ?? this.LiquidCostReal,
      ReplacementCostFiscal:
          ReplacementCostFiscal ?? this.ReplacementCostFiscal,
      LiquidCostFiscal: LiquidCostFiscal ?? this.LiquidCostFiscal,
      ActualizationType: ActualizationType ?? this.ActualizationType,
      ActualizeDataAfterUpdate:
          ActualizeDataAfterUpdate ?? this.ActualizeDataAfterUpdate,
      UpdateEnterpriseGroup:
          UpdateEnterpriseGroup ?? this.UpdateEnterpriseGroup,
    );
  }
}

import 'package:equatable/equatable.dart';

import 'entity.dart';

class AdjustCostParametersEntity extends Equatable {
  final int ProductCode;
  final int EnterpriseCode;
  final int PackingCode;
  final bool UpdateCostClass;
  final bool UpdateChildCost;
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
  final AdjustCostActualizationType ActualizationType;
  final bool ActualizeDataAfterUpdate;
  final bool UpdateEnterpriseGroup;

  const AdjustCostParametersEntity({
    required this.ProductCode,
    required this.EnterpriseCode,
    required this.PackingCode,
    required this.UpdateCostClass,
    required this.UpdateChildCost,
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
    required this.ActualizationType,
    required this.ActualizeDataAfterUpdate,
    required this.UpdateEnterpriseGroup,
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
}

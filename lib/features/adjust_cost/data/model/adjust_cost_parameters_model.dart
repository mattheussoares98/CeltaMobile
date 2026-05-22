import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';

class AdjustCostParametersModel extends AdjustCostParametersEntity {
  const AdjustCostParametersModel({
    required super.ProductCode,
    required super.EnterpriseCode,
    required super.PackingCode,
    required super.UpdateCostClass,
    required super.UpdateChildCost,
    required super.ReplacementCost,
    required super.LiquidCost,
    required super.LastUnitValue,
    required super.BaseCalcIcmsSubstUnit,
    required super.ValueOfIcmsSubstUnit,
    required super.ValueOfIcmsOwnerUnit,
    required super.FiscalBaseCalcSubstitute,
    required super.ReplacementCostReal,
    required super.LiquidCostReal,
    required super.ReplacementCostFiscal,
    required super.LiquidCostFiscal,
    required super.ActualizationType,
    required super.ActualizeDataAfterUpdate,
    required super.UpdateEnterpriseGroup,
  });

  factory AdjustCostParametersModel.fromJson(Map<String, dynamic> json) {
    return AdjustCostParametersModel(
      ProductCode: json['ProductCode'],
      EnterpriseCode: json['EnterpriseCode'],
      PackingCode: json['PackingCode'],
      UpdateCostClass: json['UpdateCostClass'],
      UpdateChildCost: json['UpdateChildCost'],
      ReplacementCost: json['ReplacementCost'],
      LiquidCost: json['LiquidCost'],
      LastUnitValue: json['LastUnitValue'],
      BaseCalcIcmsSubstUnit: json['BaseCalcIcmsSubstUnit'],
      ValueOfIcmsSubstUnit: json['ValueOfIcmsSubstUnit'],
      ValueOfIcmsOwnerUnit: json['ValueOfIcmsOwnerUnit'],
      FiscalBaseCalcSubstitute: json['FiscalBaseCalcSubstitute'],
      ReplacementCostReal: json['ReplacementCostReal'],
      LiquidCostReal: json['LiquidCostReal'],
      ReplacementCostFiscal: json['ReplacementCostFiscal'],
      LiquidCostFiscal: json['LiquidCostFiscal'],
      ActualizationType: AdjustCostActualizationType.values.firstWhere(
        (e) => e == json['ActualizationType'],
      ),
      ActualizeDataAfterUpdate: json['ActualizeDataAfterUpdate'] ?? false,
      UpdateEnterpriseGroup: json['UpdateEnterpriseGroup'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductCode': ProductCode,
      'EnterpriseCode': EnterpriseCode,
      'PackingCode': PackingCode,
      'UpdateCostClass': UpdateCostClass,
      'UpdateChildCost': UpdateChildCost,
      'ReplacementCost': ReplacementCost,
      'LiquidCost': LiquidCost,
      'LastUnitValue': LastUnitValue,
      'BaseCalcIcmsSubstUnit': BaseCalcIcmsSubstUnit,
      'ValueOfIcmsSubstUnit': ValueOfIcmsSubstUnit,
      'ValueOfIcmsOwnerUnit': ValueOfIcmsOwnerUnit,
      'FiscalBaseCalcSubstitute': FiscalBaseCalcSubstitute,
      'ReplacementCostReal': ReplacementCostReal,
      'LiquidCostReal': LiquidCostReal,
      'ReplacementCostFiscal': ReplacementCostFiscal,
      'LiquidCostFiscal': LiquidCostFiscal,
      'ActualizationType': ActualizationType?.name,
      'ActualizeDataAfterUpdate': ActualizeDataAfterUpdate,
      'UpdateEnterpriseGroup': UpdateEnterpriseGroup,
    };
  }

  factory AdjustCostParametersModel.fromEntity(
    AdjustCostParametersEntity entity,
  ) {
    return AdjustCostParametersModel(
      ProductCode: entity.ProductCode,
      EnterpriseCode: entity.EnterpriseCode,
      PackingCode: entity.PackingCode,
      UpdateCostClass: entity.UpdateCostClass,
      UpdateChildCost: entity.UpdateChildCost,
      ReplacementCost: entity.ReplacementCost,
      LiquidCost: entity.LiquidCost,
      LastUnitValue: entity.LastUnitValue,
      BaseCalcIcmsSubstUnit: entity.BaseCalcIcmsSubstUnit,
      ValueOfIcmsSubstUnit: entity.ValueOfIcmsSubstUnit,
      ValueOfIcmsOwnerUnit: entity.ValueOfIcmsOwnerUnit,
      FiscalBaseCalcSubstitute: entity.FiscalBaseCalcSubstitute,
      ReplacementCostReal: entity.ReplacementCostReal,
      LiquidCostReal: entity.LiquidCostReal,
      ReplacementCostFiscal: entity.ReplacementCostFiscal,
      LiquidCostFiscal: entity.LiquidCostFiscal,
      ActualizationType: entity.ActualizationType,
      ActualizeDataAfterUpdate: entity.ActualizeDataAfterUpdate,
      UpdateEnterpriseGroup: entity.UpdateEnterpriseGroup,
    );
  }

  AdjustCostParametersEntity toEntity() {
    return AdjustCostParametersEntity(
      ProductCode: ProductCode,
      EnterpriseCode: EnterpriseCode,
      PackingCode: PackingCode,
      UpdateCostClass: UpdateCostClass,
      UpdateChildCost: UpdateChildCost,
      ReplacementCost: ReplacementCost,
      LiquidCost: LiquidCost,
      LastUnitValue: LastUnitValue,
      BaseCalcIcmsSubstUnit: BaseCalcIcmsSubstUnit,
      ValueOfIcmsSubstUnit: ValueOfIcmsSubstUnit,
      ValueOfIcmsOwnerUnit: ValueOfIcmsOwnerUnit,
      FiscalBaseCalcSubstitute: FiscalBaseCalcSubstitute,
      ReplacementCostReal: ReplacementCostReal,
      LiquidCostReal: LiquidCostReal,
      ReplacementCostFiscal: ReplacementCostFiscal,
      LiquidCostFiscal: LiquidCostFiscal,
      ActualizationType: ActualizationType,
      ActualizeDataAfterUpdate: ActualizeDataAfterUpdate,
      UpdateEnterpriseGroup: UpdateEnterpriseGroup,
    );
  }
}

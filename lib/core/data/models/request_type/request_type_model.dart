import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class RequestTypeModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final int OperationType;
  final String OperationTypeString;
  final int UseWholePrice;
  final String UseWholePriceString;
  final int UnitValueType;
  final String UnitValueTypeString;
  final int TransferUnitValueType;
  final String TransferUnitValueTypeString;
  final bool AllowDiscount;
  final bool AllowAlterCostOrSalePrice;

  const RequestTypeModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationType,
    required this.OperationTypeString,
    required this.UseWholePrice,
    required this.UseWholePriceString,
    required this.UnitValueType,
    required this.UnitValueTypeString,
    required this.TransferUnitValueType,
    required this.TransferUnitValueTypeString,
    required this.AllowDiscount,
    required this.AllowAlterCostOrSalePrice,
  });

  @override
  List<Object?> get props => [
    Code,
    PersonalizedCode,
    Name,
    OperationType,
    OperationTypeString,
    UseWholePrice,
    UseWholePriceString,
    UnitValueType,
    UnitValueTypeString,
    TransferUnitValueType,
    TransferUnitValueTypeString,
    AllowDiscount,
    AllowAlterCostOrSalePrice,
  ];

  factory RequestTypeModel.fromJson(Map json) => RequestTypeModel(
    Code: json['Code'] as int,
    PersonalizedCode: json['PersonalizedCode'] as String,
    Name: json['Name'] as String,
    OperationType: json['OperationType'] as int,
    OperationTypeString: json['OperationTypeString'] as String,
    UseWholePrice: json['UseWholePrice'] as int,
    UseWholePriceString: json['UseWholePriceString'] as String,
    UnitValueType: json['UnitValueType'] as int,
    UnitValueTypeString: json['UnitValueTypeString'] as String,
    TransferUnitValueType: json['TransferUnitValueType'] as int,
    TransferUnitValueTypeString: json['TransferUnitValueTypeString'] as String,
    AllowDiscount: json['AllowDiscount'] as bool,
    AllowAlterCostOrSalePrice: json['AllowAlterCostOrSalePrice'] as bool,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
    'OperationType': OperationType,
    'OperationTypeString': OperationTypeString,
    'UseWholePrice': UseWholePrice,
    'UseWholePriceString': UseWholePriceString,
    'UnitValueType': UnitValueType,
    'UnitValueTypeString': UnitValueTypeString,
    'TransferUnitValueType': TransferUnitValueType,
    'TransferUnitValueTypeString': TransferUnitValueTypeString,
    'AllowDiscount': AllowDiscount,
    'AllowAlterCostOrSalePrice': AllowAlterCostOrSalePrice,
  };

  factory RequestTypeModel.fromEntity(RequestTypeEntity entity) =>
      RequestTypeModel(
        Code: entity.Code,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.Name,
        OperationType: entity.OperationType,
        OperationTypeString: entity.OperationTypeString,
        UseWholePrice: entity.UseWholePrice,
        UseWholePriceString: entity.UseWholePriceString,
        UnitValueType: entity.UnitValueType,
        UnitValueTypeString: entity.UnitValueTypeString,
        TransferUnitValueType: entity.TransferUnitValueType,
        TransferUnitValueTypeString: entity.TransferUnitValueTypeString,
        AllowDiscount: entity.AllowDiscount,
        AllowAlterCostOrSalePrice: entity.AllowAlterCostOrSalePrice,
      );

  RequestTypeEntity toEntity() => RequestTypeEntity(
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    Name: Name,
    OperationType: OperationType,
    OperationTypeString: OperationTypeString,
    UseWholePrice: UseWholePrice,
    UseWholePriceString: UseWholePriceString,
    UnitValueType: UnitValueType,
    UnitValueTypeString: UnitValueTypeString,
    TransferUnitValueType: TransferUnitValueType,
    TransferUnitValueTypeString: TransferUnitValueTypeString,
    AllowDiscount: AllowDiscount,
    AllowAlterCostOrSalePrice: AllowAlterCostOrSalePrice,
  );
}

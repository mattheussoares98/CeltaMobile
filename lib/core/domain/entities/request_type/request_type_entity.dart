import 'package:equatable/equatable.dart';

class RequestTypeEntity extends Equatable {
  final int Code;
  final int OperationType;
  final int UseWholePrice;
  final int UnitValueType;
  final int TransferUnitValueType;
  final String PersonalizedCode;
  final String Name;
  final String OperationTypeString;
  final String UseWholePriceString;
  final String UnitValueTypeString;
  final String TransferUnitValueTypeString;
  final bool? AllowDiscount;
  final bool? AllowAlterCostOrSalePrice;

  const RequestTypeEntity({
    required this.Code,
    required this.OperationType,
    required this.UseWholePrice,
    required this.UnitValueType,
    required this.TransferUnitValueType,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationTypeString,
    required this.UseWholePriceString,
    required this.UnitValueTypeString,
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
}

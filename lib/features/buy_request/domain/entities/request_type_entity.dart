import 'package:equatable/equatable.dart';

class RequestTypeEntity extends Equatable {
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

  const RequestTypeEntity({
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
  ];
}

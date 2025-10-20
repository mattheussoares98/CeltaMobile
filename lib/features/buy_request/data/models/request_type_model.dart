import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

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
  );
}

import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class LastBuyEntranceModel extends Equatable {
  final String Number;
  final String EntranceDate;
  final String Supplier;
  final String FiscalCode;
  final String Packing;
  final double Quantity;
  const LastBuyEntranceModel({
    required this.Number,
    required this.EntranceDate,
    required this.Supplier,
    required this.FiscalCode,
    required this.Packing,
    required this.Quantity,
  });

  @override
  List<Object?> get props => [
    Number,
    EntranceDate,
    Supplier,
    FiscalCode,
    Packing,
    Quantity,
  ];

  factory LastBuyEntranceModel.fromJson(Map json) {
    return LastBuyEntranceModel(
      Number: json['Number'],
      EntranceDate: json['EntranceDate'],
      Supplier: json['Supplier'],
      FiscalCode: json['FiscalCode'],
      Packing: json['Packing'],
      Quantity: json['Quantity'],
    );
  }
  factory LastBuyEntranceModel.fromEntity(LastBuyEntranceEntity entity) {
    return LastBuyEntranceModel(
      Number: entity.Number,
      EntranceDate: entity.EntranceDate,
      Supplier: entity.Supplier,
      FiscalCode: entity.FiscalCode,
      Packing: entity.Packing,
      Quantity: entity.Quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'Number': Number,
    'EntranceDate': EntranceDate,
    'Supplier': Supplier,
    'FiscalCode': FiscalCode,
    'Packing': Packing,
    'Quantity': Quantity,
  };

  LastBuyEntranceEntity toEntity() => LastBuyEntranceEntity(
    Number: Number,
    EntranceDate: EntranceDate,
    Supplier: Supplier,
    FiscalCode: FiscalCode,
    Packing: Packing,
    Quantity: Quantity,
  );
}

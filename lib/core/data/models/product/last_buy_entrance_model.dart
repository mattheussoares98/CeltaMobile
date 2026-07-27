import 'package:celta_inventario/core/domain/entities/entities.dart';

class LastBuyEntranceModel extends LastBuyEntranceEntity {
  const LastBuyEntranceModel({
    required super.Code,
    required super.Number,
    required super.EntranceDate,
    required super.Supplier,
    required super.FiscalCode,
    required super.Packing,
    required super.Quantity,
  });

  factory LastBuyEntranceModel.fromJson(Map json) {
    return LastBuyEntranceModel(
      Code: json['Code'],
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
      Code: entity.Code,
      Number: entity.Number,
      EntranceDate: entity.EntranceDate,
      Supplier: entity.Supplier,
      FiscalCode: entity.FiscalCode,
      Packing: entity.Packing,
      Quantity: entity.Quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'Code': Code,
    'Number': Number,
    'EntranceDate': EntranceDate,
    'Supplier': Supplier,
    'FiscalCode': FiscalCode,
    'Packing': Packing,
    'Quantity': Quantity,
  };

  LastBuyEntranceEntity toEntity() => LastBuyEntranceEntity(
    Code: Code,
    Number: Number,
    EntranceDate: EntranceDate,
    Supplier: Supplier,
    FiscalCode: FiscalCode,
    Packing: Packing,
    Quantity: Quantity,
  );
}

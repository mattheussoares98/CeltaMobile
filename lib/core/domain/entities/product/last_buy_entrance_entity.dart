import 'package:equatable/equatable.dart';

class LastBuyEntranceEntity extends Equatable {
  final String Number;
  final String EntranceDate;
  final String Supplier;
  final String FiscalCode;
  final String Packing;
  final double Quantity;
  const LastBuyEntranceEntity({
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
}

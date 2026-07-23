import 'package:equatable/equatable.dart';

class EcBuyMovementFiscalNoteTypeDtoEntity extends Equatable {
  final int? code;
  final String? personalizedCode;
  final String? name;

  const EcBuyMovementFiscalNoteTypeDtoEntity({
    required this.code,
    required this.personalizedCode,
    required this.name,
  });

  @override
  List<Object?> get props => [code, personalizedCode, name];
}

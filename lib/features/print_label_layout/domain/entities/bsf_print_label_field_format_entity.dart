import 'package:equatable/equatable.dart';

class BSFPrintLabelFieldFormatEntity extends Equatable {
  final int code;
  final bool stringType;
  final bool integerType;
  final bool floatType;
  final bool dateTimeType;
  final bool qrCodeType;
  final String name;
  final String description;

  const BSFPrintLabelFieldFormatEntity({
    required this.code,
    required this.stringType,
    required this.integerType,
    required this.floatType,
    required this.dateTimeType,
    required this.qrCodeType,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [
    code,
    stringType,
    integerType,
    floatType,
    dateTimeType,
    qrCodeType,
    name,
    description,
  ];
}

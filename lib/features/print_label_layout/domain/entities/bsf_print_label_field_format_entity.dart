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

  String? get dateTimePattern => switch (code) {
    7 => 'dd/MM/yy',
    8 => 'dd/MM/yyyy',
    9 => 'MM/dd/yy',
    10 => 'MM/dd/yyyy',
    11 => 'yy/MM/dd',
    12 => 'yyyy/MM/dd',
    13 => 'ddMMyy',
    14 => 'ddMMyyyy',
    15 => 'MMddyy',
    16 => 'MMddyyyy',
    17 => 'yyMMdd',
    18 => 'yyyyMMdd',
    19 => 'HH:mm:ss',
    20 => 'HH:mm',
    21 => 'HHmmss',
    22 => 'HHmm',
    _ => null,
  };

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

import 'package:equatable/equatable.dart';

class BSFFiscalCodeValueEntity extends Equatable {
  final String? code;
  final bool? isOldFormat;
  final bool? isValid;

  const BSFFiscalCodeValueEntity({
    required this.code,
    required this.isOldFormat,
    required this.isValid,
  });

  @override
  List<Object?> get props => [code, isOldFormat, isValid];
}

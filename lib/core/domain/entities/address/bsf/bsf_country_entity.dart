import 'package:equatable/equatable.dart';

class BSFCountryEntity extends Equatable {
  final int? code;
  final String? name;
  final bool? isExteriorCountry;
  final String? spedCode;

  const BSFCountryEntity({
    this.code,
    required this.name,
    required this.isExteriorCountry,
    required this.spedCode,
  });

  @override
  List<Object?> get props => [code, name, isExteriorCountry, spedCode];
}

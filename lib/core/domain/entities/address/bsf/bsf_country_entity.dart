import 'package:equatable/equatable.dart';

class BSFCountryEntity extends Equatable {
  final String? name;
  final bool? isExteriorCountry;
  final String? spedCode;

  const BSFCountryEntity({
    required this.name,
    required this.isExteriorCountry,
    required this.spedCode,
  });

  @override
  List<Object?> get props => [name, isExteriorCountry, spedCode];
}

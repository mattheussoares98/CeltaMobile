// lib/core/domain/entities/address/bsf/bsf_city_entity.dart
import 'package:equatable/equatable.dart';

class BSFCityEntity extends Equatable {
  final int? code;
  final String? description;
  final String? ibgeCode;
  final bool? isValid;

  const BSFCityEntity({
    required this.code,
    required this.description,
    required this.ibgeCode,
    required this.isValid,
  });

  @override
  List<Object?> get props => [code, description, ibgeCode, isValid];
}

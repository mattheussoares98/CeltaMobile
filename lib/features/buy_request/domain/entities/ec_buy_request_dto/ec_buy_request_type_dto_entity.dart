import 'package:equatable/equatable.dart';

class EcBuyRequestTypeDtoEntity extends Equatable {
  final int? code;
  final String? name;
  final String? personalizedCode;

  const EcBuyRequestTypeDtoEntity({
    required this.code,
    required this.name,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [code, name, personalizedCode];
}

import 'package:equatable/equatable.dart';

class EcCommerceSiteEntity extends Equatable {
  final int code;
  final int enterpriseCode;
  final String environmentName;
  final int commerceSiteIdentification;
  final String description;

  const EcCommerceSiteEntity({
    required this.code,
    required this.enterpriseCode,
    required this.environmentName,
    required this.commerceSiteIdentification,
    required this.description,
  });

  @override
  List<Object?> get props => [
    code,
    enterpriseCode,
    environmentName,
    commerceSiteIdentification,
    description,
  ];
}

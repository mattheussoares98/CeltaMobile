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

  EcCommerceSiteEntity copyWith({
    int? code,
    int? enterpriseCode,
    String? environmentName,
    int? commerceSiteIdentification,
    String? description,
  }) {
    return EcCommerceSiteEntity(
      code: code ?? this.code,
      enterpriseCode: enterpriseCode ?? this.enterpriseCode,
      environmentName: environmentName ?? this.environmentName,
      commerceSiteIdentification:
          commerceSiteIdentification ?? this.commerceSiteIdentification,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        code,
        enterpriseCode,
        environmentName,
        commerceSiteIdentification,
        description,
      ];
}

import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcNFeDisableSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime issuanceDate;
  final int number;
  final String series;

  const EcNFeDisableSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.issuanceDate,
    required this.number,
    required this.series,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    issuanceDate,
    number,
    series,
  ];
}

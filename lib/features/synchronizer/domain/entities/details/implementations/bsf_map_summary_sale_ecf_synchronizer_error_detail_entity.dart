import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFMapSummarySaleEcfSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime finalizationDate;
  final String ecfPersonalizedCode;
  final String ecfSerialNumber;
  final String userAllowedRead;
  final String description;

  const BSFMapSummarySaleEcfSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.finalizationDate,
    required this.ecfPersonalizedCode,
    required this.ecfSerialNumber,
    required this.userAllowedRead,
    required this.description,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    creationDate,
    finalizationDate,
    ecfPersonalizedCode,
    ecfSerialNumber,
    userAllowedRead,
    description,
  ];
}

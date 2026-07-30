import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSendDataSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final String commerceSite;
  final String description;
  final String siteCode;
  final DateTime? sendDate;
  final String error;

  const BSFSendDataSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.commerceSite,
    required this.description,
    required this.siteCode,
    required this.sendDate,
    required this.error,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    commerceSite,
    description,
    siteCode,
    sendDate,
    error,
  ];
}

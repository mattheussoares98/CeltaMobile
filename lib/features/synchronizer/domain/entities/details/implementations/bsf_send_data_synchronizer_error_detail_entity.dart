import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSendDataSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity
    implements SelectableSynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final String commerceSite;
  final String description;
  final String siteCode;
  final DateTime? sendDate;
  final String error;
  final BSFSendDataType sendDataType;
  final int internalCode;
  final int enterpriseCommerceSiteCode;
  final int enterpriseCode;
  final bool isSent;
  final bool isToResend;

  const BSFSendDataSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.commerceSite,
    required this.description,
    required this.siteCode,
    required this.sendDate,
    required this.error,
    required this.sendDataType,
    required this.internalCode,
    required this.enterpriseCommerceSiteCode,
    required this.enterpriseCode,
    required this.isSent,
    required this.isToResend,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    commerceSite,
    description,
    siteCode,
    sendDate,
    error,
    sendDataType,
    internalCode,
    enterpriseCommerceSiteCode,
    enterpriseCode,
    isSent,
    isToResend,
  ];

  @override
  List<int> get selectableCodes => [internalCode];
}

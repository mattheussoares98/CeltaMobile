import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSaleRequestWithErrorSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity
    implements SelectableSynchronizerErrorDetailEntity {
  final int code;
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime cadasterDate;
  final String commerceSite;
  final String saleRequestInvoiceCode;
  final String saleRequestNumber;
  final String commerceSiteFile;
  final List<String> details;
  final List<BSFSaleRequestProductNotFoundDetailEntity> productsNotFound;

  @override
  List<int> get selectableCodes => [code];

  const BSFSaleRequestWithErrorSynchronizerErrorDetailEntity({
    required this.code,
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.cadasterDate,
    required this.commerceSite,
    required this.saleRequestInvoiceCode,
    required this.saleRequestNumber,
    required this.commerceSiteFile,
    required this.details,
    required this.productsNotFound,
  });

  @override
  List<Object?> get props => [
    code,
    enterprisePersonalizedCode,
    creationDate,
    cadasterDate,
    commerceSite,
    saleRequestInvoiceCode,
    saleRequestNumber,
    commerceSiteFile,
    details,
    productsNotFound,
  ];
}

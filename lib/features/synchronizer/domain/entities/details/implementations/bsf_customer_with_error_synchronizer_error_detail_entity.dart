import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFCustomerWithErrorSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime cadasterDate;
  final String customerCode;
  final String customerName;
  final List<String> details;

  const BSFCustomerWithErrorSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.cadasterDate,
    required this.customerCode,
    required this.customerName,
    required this.details,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    creationDate,
    cadasterDate,
    customerCode,
    customerName,
    details,
  ];
}

import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFCustomerWithErrorSynchronizerErrorDetailModel
    extends BSFCustomerWithErrorSynchronizerErrorDetailEntity {
  const BSFCustomerWithErrorSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.cadasterDate,
    required super.customerCode,
    required super.customerName,
    required super.details,
  });

  factory BSFCustomerWithErrorSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFCustomerWithErrorSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['enterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['creationDate'] as String),
        cadasterDate: DateTime.parse(json['cadasterDate'] as String),
        customerCode: json['customerCode'] as String,
        customerName: json['customerName'] as String,
        details: List<String>.from(json['details'] as List),
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'cadasterDate': cadasterDate.toIso8601String(),
    'customerCode': customerCode,
    'customerName': customerName,
    'details': details,
  };

  factory BSFCustomerWithErrorSynchronizerErrorDetailModel.fromEntity(
    BSFCustomerWithErrorSynchronizerErrorDetailEntity entity,
  ) => BSFCustomerWithErrorSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    cadasterDate: entity.cadasterDate,
    customerCode: entity.customerCode,
    customerName: entity.customerName,
    details: entity.details,
  );

  BSFCustomerWithErrorSynchronizerErrorDetailEntity toEntity() =>
      BSFCustomerWithErrorSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        cadasterDate: cadasterDate,
        customerCode: customerCode,
        customerName: customerName,
        details: details,
      );
}

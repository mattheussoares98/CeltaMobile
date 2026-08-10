import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCustomerWithErrorSynchronizerErrorDetailModel
    extends EcCustomerWithErrorSynchronizerErrorDetailEntity {
  const EcCustomerWithErrorSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.cadasterDate,
    required super.customerCode,
    required super.customerName,
    required super.details,
  });

  factory EcCustomerWithErrorSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcCustomerWithErrorSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['CreationDate'] as String),
        cadasterDate: DateTime.parse(json['CadasterDate'] as String),
        customerCode: json['CustomerCode'] as String,
        customerName: json['CustomerName'] as String,
        details: List<String>.from(json['Details'] as List),
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'CadasterDate': cadasterDate.toIso8601String(),
    'CustomerCode': customerCode,
    'CustomerName': customerName,
    'Details': details,
  };

  factory EcCustomerWithErrorSynchronizerErrorDetailModel.fromEntity(
    EcCustomerWithErrorSynchronizerErrorDetailEntity entity,
  ) => EcCustomerWithErrorSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    cadasterDate: entity.cadasterDate,
    customerCode: entity.customerCode,
    customerName: entity.customerName,
    details: entity.details,
  );

  EcCustomerWithErrorSynchronizerErrorDetailEntity toEntity() =>
      EcCustomerWithErrorSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        cadasterDate: cadasterDate,
        customerCode: customerCode,
        customerName: customerName,
        details: details,
      );
}

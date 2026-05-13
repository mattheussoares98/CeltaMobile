import 'package:equatable/equatable.dart';

class BsfSaleBlockadeEntity extends Equatable {
  final int? code;
  final String? personalizedCode;
  final String? legacyCode;
  final String? description;
  final bool? allowSale;
  final bool? allowSaleRequest;
  final bool? allowSaleWithPaymentFinalizationTypeCheckOrPortion;
  final String? stringAllowSale;
  final String? stringAllowSaleRequest;
  final String? stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion;

  const BsfSaleBlockadeEntity({
    required this.code,
    required this.personalizedCode,
    required this.legacyCode,
    required this.description,
    required this.allowSale,
    required this.allowSaleRequest,
    required this.allowSaleWithPaymentFinalizationTypeCheckOrPortion,
    required this.stringAllowSale,
    required this.stringAllowSaleRequest,
    required this.stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  });

  @override
  List<Object?> get props => [
        code,
        personalizedCode,
        legacyCode,
        description,
        allowSale,
        allowSaleRequest,
        allowSaleWithPaymentFinalizationTypeCheckOrPortion,
        stringAllowSale,
        stringAllowSaleRequest,
        stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
      ];

  BsfSaleBlockadeEntity copyWith({
    int? code,
    String? personalizedCode,
    String? legacyCode,
    String? description,
    bool? allowSale,
    bool? allowSaleRequest,
    bool? allowSaleWithPaymentFinalizationTypeCheckOrPortion,
    String? stringAllowSale,
    String? stringAllowSaleRequest,
    String? stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  }) {
    return BsfSaleBlockadeEntity(
      code: code ?? this.code,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      legacyCode: legacyCode ?? this.legacyCode,
      description: description ?? this.description,
      allowSale: allowSale ?? this.allowSale,
      allowSaleRequest: allowSaleRequest ?? this.allowSaleRequest,
      allowSaleWithPaymentFinalizationTypeCheckOrPortion:
          allowSaleWithPaymentFinalizationTypeCheckOrPortion ??
              this.allowSaleWithPaymentFinalizationTypeCheckOrPortion,
      stringAllowSale: stringAllowSale ?? this.stringAllowSale,
      stringAllowSaleRequest:
          stringAllowSaleRequest ?? this.stringAllowSaleRequest,
      stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
          stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion ??
              this.stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
    );
  }
}

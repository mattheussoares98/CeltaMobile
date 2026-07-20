import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestBuyerDtoModel extends Equatable {
  final int? code;
  final int? personalizedCode;
  final bool? buyer;
  final bool? seller;
  final bool? pdvOperator;
  final DateTime? dateOfBirth;
  final String? cpfNumber;
  final String? rgNumber;
  final String? name;
  final String? nameReduced;

  const EcBuyRequestBuyerDtoModel({
    required this.code,
    required this.personalizedCode,
    required this.buyer,
    required this.seller,
    required this.pdvOperator,
    required this.dateOfBirth,
    required this.cpfNumber,
    required this.rgNumber,
    required this.name,
    required this.nameReduced,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    buyer,
    seller,
    pdvOperator,
    dateOfBirth,
    cpfNumber,
    rgNumber,
    name,
    nameReduced,
  ];

  factory EcBuyRequestBuyerDtoModel.fromJson(Map json) {
    return EcBuyRequestBuyerDtoModel(
      code: json['code'] as int?,
      personalizedCode: json['personalizedCode'] as int?,
      buyer: json['buyer'] as bool?,
      seller: json['seller'] as bool?,
      pdvOperator: json['pdvOperator'] as bool?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
      cpfNumber: json['cpfNumber']?.toString(),
      rgNumber: json['rgNumber']?.toString(),
      name: json['name'] as String?,
      nameReduced: json['nameReduced'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'personalizedCode': personalizedCode,
      'buyer': buyer,
      'seller': seller,
      'pdvOperator': pdvOperator,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'cpfNumber': cpfNumber,
      'rgNumber': rgNumber,
      'name': name,
      'nameReduced': nameReduced,
    };
  }

  factory EcBuyRequestBuyerDtoModel.fromEntity(
    EcBuyRequestBuyerDtoEntity entity,
  ) {
    return EcBuyRequestBuyerDtoModel(
      code: entity.code,
      personalizedCode: entity.personalizedCode,
      buyer: entity.buyer,
      seller: entity.seller,
      pdvOperator: entity.pdvOperator,
      dateOfBirth: entity.dateOfBirth,
      cpfNumber: entity.cpfNumber,
      rgNumber: entity.rgNumber,
      name: entity.name,
      nameReduced: entity.nameReduced,
    );
  }

  EcBuyRequestBuyerDtoEntity toEntity() {
    return EcBuyRequestBuyerDtoEntity(
      code: code,
      personalizedCode: personalizedCode,
      buyer: buyer,
      seller: seller,
      pdvOperator: pdvOperator,
      dateOfBirth: dateOfBirth,
      cpfNumber: cpfNumber,
      rgNumber: rgNumber,
      name: name,
      nameReduced: nameReduced,
    );
  }
}

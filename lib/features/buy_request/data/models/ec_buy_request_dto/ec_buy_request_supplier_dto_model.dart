import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestSupplierDtoModel extends Equatable {
  final int? code;
  final String? name;
  final String? fantasizesName;
  final String? suframaCode;
  final String? cnpjCpfNumber;
  final String? formatedCnpjCpfNumber;
  final String? inscriptionRgNumber;

  const EcBuyRequestSupplierDtoModel({
    required this.code,
    required this.name,
    required this.fantasizesName,
    required this.suframaCode,
    required this.cnpjCpfNumber,
    required this.formatedCnpjCpfNumber,
    required this.inscriptionRgNumber,
  });

  @override
  List<Object?> get props => [
    code,
    name,
    fantasizesName,
    suframaCode,
    cnpjCpfNumber,
    formatedCnpjCpfNumber,
    inscriptionRgNumber,
  ];

  factory EcBuyRequestSupplierDtoModel.fromJson(Map json) {
    return EcBuyRequestSupplierDtoModel(
      code: json['code'] as int?,
      name: json['name'] as String?,
      fantasizesName: json['fantasizesName'] as String?,
      suframaCode: json['suframaCode']?.toString(),
      cnpjCpfNumber: json['cnpjCpfNumber']?.toString(),
      formatedCnpjCpfNumber: json['formatedCnpjCpfNumber'] as String?,
      inscriptionRgNumber: json['inscriptionRgNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'fantasizesName': fantasizesName,
      'suframaCode': suframaCode,
      'cnpjCpfNumber': cnpjCpfNumber,
      'formatedCnpjCpfNumber': formatedCnpjCpfNumber,
      'inscriptionRgNumber': inscriptionRgNumber,
    };
  }

  factory EcBuyRequestSupplierDtoModel.fromEntity(
    EcBuyRequestSupplierDtoEntity entity,
  ) {
    return EcBuyRequestSupplierDtoModel(
      code: entity.code,
      name: entity.name,
      fantasizesName: entity.fantasizesName,
      suframaCode: entity.suframaCode,
      cnpjCpfNumber: entity.cnpjCpfNumber,
      formatedCnpjCpfNumber: entity.formatedCnpjCpfNumber,
      inscriptionRgNumber: entity.inscriptionRgNumber,
    );
  }

  EcBuyRequestSupplierDtoEntity toEntity() {
    return EcBuyRequestSupplierDtoEntity(
      code: code,
      name: name,
      fantasizesName: fantasizesName,
      suframaCode: suframaCode,
      cnpjCpfNumber: cnpjCpfNumber,
      formatedCnpjCpfNumber: formatedCnpjCpfNumber,
      inscriptionRgNumber: inscriptionRgNumber,
    );
  }
}

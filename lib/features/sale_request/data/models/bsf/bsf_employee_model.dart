// lib/features/sale_request/data/models/bsf/bsf_employee_model.dart
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'bsf.dart';

class BSFEmployeeModel extends BSFEmployeeEntity {
  const BSFEmployeeModel({
    required super.code,
    required super.personalizedCode,
    required super.buyer,
    required super.seller,
    required super.sellerType,
    required super.providerService,
    required super.pdvOperator,
    required super.observations,
    required super.paysBank,
    required super.driverInfos,
    required super.admissionDate,
    required super.dismissalDate,
    required super.dateOfBirth,
    required super.cpfNumber,
    required super.formatedCpfNumber,
    required super.rgNumber,
    required super.pisNumber,
    required super.formatedRgNumber,
    required super.name,
    required super.nameReduced,
    required super.email,
    required super.isFired,
    required super.jobRoleString,
    required super.accountEmails,
  });

  factory BSFEmployeeModel.fromJson(Map<String, dynamic> json) =>
      BSFEmployeeModel(
        code: json['Code'],
        personalizedCode: json['PersonalizedCode'],
        buyer: json['Buyer'],
        seller: json['Seller'],
        sellerType: json['SellerType'],
        providerService: json['ProviderService'],
        pdvOperator: json['PdvOperator'],
        observations: json['Observations'],
        paysBank: json['PaysBank'],
        driverInfos: json['DriverInfos'] != null
            ? BSFDriverInfosModel.fromJson(json['DriverInfos'])
            : null,
        admissionDate: json['AdmissionDate'] != null
            ? DateTime.parse(json['AdmissionDate'])
            : null,
        dismissalDate: json['DismissalDate'] != null
            ? DateTime.parse(json['DismissalDate'])
            : null,
        dateOfBirth: json['DateOfBirth'] != null
            ? DateTime.parse(json['DateOfBirth'])
            : null,
        cpfNumber: json['CpfNumber'],
        formatedCpfNumber: json['FormatedCpfNumber'],
        rgNumber: json['RgNumber'],
        pisNumber: json['PisNumber'],
        formatedRgNumber: json['FormatedRgNumber'],
        name: json['Name'],
        nameReduced: json['NameReduced'],
        email: json['Email'],
        isFired: json['IsFired'],
        jobRoleString: json['JobRoleString'],
        accountEmails: json['AccountEmails'] != null
            ? List<String>.from(json['AccountEmails'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'PersonalizedCode': personalizedCode,
        'Buyer': buyer,
        'Seller': seller,
        'SellerType': sellerType,
        'ProviderService': providerService,
        'PdvOperator': pdvOperator,
        'Observations': observations,
        'PaysBank': paysBank,
        'DriverInfos': (driverInfos as BSFDriverInfosModel?)?.toJson(),
        'AdmissionDate': admissionDate?.toIso8601String(),
        'DismissalDate': dismissalDate?.toIso8601String(),
        'DateOfBirth': dateOfBirth?.toIso8601String(),
        'CpfNumber': cpfNumber,
        'FormatedCpfNumber': formatedCpfNumber,
        'RgNumber': rgNumber,
        'PisNumber': pisNumber,
        'FormatedRgNumber': formatedRgNumber,
        'Name': name,
        'NameReduced': nameReduced,
        'Email': email,
        'IsFired': isFired,
        'JobRoleString': jobRoleString,
        'AccountEmails': accountEmails,
      };

  factory BSFEmployeeModel.fromEntity(BSFEmployeeEntity entity) =>
      BSFEmployeeModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
        buyer: entity.buyer,
        seller: entity.seller,
        sellerType: entity.sellerType,
        providerService: entity.providerService,
        pdvOperator: entity.pdvOperator,
        observations: entity.observations,
        paysBank: entity.paysBank,
        driverInfos: entity.driverInfos != null
            ? BSFDriverInfosModel.fromEntity(entity.driverInfos!)
            : null,
        admissionDate: entity.admissionDate,
        dismissalDate: entity.dismissalDate,
        dateOfBirth: entity.dateOfBirth,
        cpfNumber: entity.cpfNumber,
        formatedCpfNumber: entity.formatedCpfNumber,
        rgNumber: entity.rgNumber,
        pisNumber: entity.pisNumber,
        formatedRgNumber: entity.formatedRgNumber,
        name: entity.name,
        nameReduced: entity.nameReduced,
        email: entity.email,
        isFired: entity.isFired,
        jobRoleString: entity.jobRoleString,
        accountEmails: entity.accountEmails,
      );

  BSFEmployeeEntity toEntity() => BSFEmployeeEntity(
        code: code,
        personalizedCode: personalizedCode,
        buyer: buyer,
        seller: seller,
        sellerType: sellerType,
        providerService: providerService,
        pdvOperator: pdvOperator,
        observations: observations,
        paysBank: paysBank,
        driverInfos: (driverInfos as BSFDriverInfosModel?)?.toEntity(),
        admissionDate: admissionDate,
        dismissalDate: dismissalDate,
        dateOfBirth: dateOfBirth,
        cpfNumber: cpfNumber,
        formatedCpfNumber: formatedCpfNumber,
        rgNumber: rgNumber,
        pisNumber: pisNumber,
        formatedRgNumber: formatedRgNumber,
        name: name,
        nameReduced: nameReduced,
        email: email,
        isFired: isFired,
        jobRoleString: jobRoleString,
        accountEmails: accountEmails,
      );
}

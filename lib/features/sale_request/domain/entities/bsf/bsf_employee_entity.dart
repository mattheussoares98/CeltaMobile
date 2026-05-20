// lib/features/sale_request/domain/entities/bsf/bsf_employee_entity.dart
import 'package:equatable/equatable.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class BSFEmployeeEntity extends Equatable {
  final int? code;
  final String? personalizedCode;
  final bool? buyer;
  final bool? seller;
  final int? sellerType;
  final bool? providerService;
  final bool? pdvOperator;
  final String? observations;
  final bool? paysBank;
  final BSFDriverInfosEntity? driverInfos;
  final DateTime? admissionDate;
  final DateTime? dismissalDate;
  final DateTime? dateOfBirth;
  final String? cpfNumber;
  final String? formatedCpfNumber;
  final String? rgNumber;
  final String? pisNumber;
  final String? formatedRgNumber;
  final String? name;
  final String? nameReduced;
  final String? email;
  final bool? isFired;
  final String? jobRoleString;
  final List<String>? accountEmails;

  const BSFEmployeeEntity({
    required this.code,
    required this.personalizedCode,
    required this.buyer,
    required this.seller,
    required this.sellerType,
    required this.providerService,
    required this.pdvOperator,
    required this.observations,
    required this.paysBank,
    required this.driverInfos,
    required this.admissionDate,
    required this.dismissalDate,
    required this.dateOfBirth,
    required this.cpfNumber,
    required this.formatedCpfNumber,
    required this.rgNumber,
    required this.pisNumber,
    required this.formatedRgNumber,
    required this.name,
    required this.nameReduced,
    required this.email,
    required this.isFired,
    required this.jobRoleString,
    required this.accountEmails,
  });

  @override
  List<Object?> get props => [
        code,
        personalizedCode,
        buyer,
        seller,
        sellerType,
        providerService,
        pdvOperator,
        observations,
        paysBank,
        driverInfos,
        admissionDate,
        dismissalDate,
        dateOfBirth,
        cpfNumber,
        formatedCpfNumber,
        rgNumber,
        pisNumber,
        formatedRgNumber,
        name,
        nameReduced,
        email,
        isFired,
        jobRoleString,
        accountEmails,
      ];

  BSFEmployeeEntity copyWith({
    int? code,
    String? personalizedCode,
    bool? buyer,
    bool? seller,
    int? sellerType,
    bool? providerService,
    bool? pdvOperator,
    String? observations,
    bool? paysBank,
    BSFDriverInfosEntity? driverInfos,
    DateTime? admissionDate,
    DateTime? dismissalDate,
    DateTime? dateOfBirth,
    String? cpfNumber,
    String? formatedCpfNumber,
    String? rgNumber,
    String? pisNumber,
    String? formatedRgNumber,
    String? name,
    String? nameReduced,
    String? email,
    bool? isFired,
    String? jobRoleString,
    List<String>? accountEmails,
  }) {
    return BSFEmployeeEntity(
      code: code ?? this.code,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      buyer: buyer ?? this.buyer,
      seller: seller ?? this.seller,
      sellerType: sellerType ?? this.sellerType,
      providerService: providerService ?? this.providerService,
      pdvOperator: pdvOperator ?? this.pdvOperator,
      observations: observations ?? this.observations,
      paysBank: paysBank ?? this.paysBank,
      driverInfos: driverInfos ?? this.driverInfos,
      admissionDate: admissionDate ?? this.admissionDate,
      dismissalDate: dismissalDate ?? this.dismissalDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      cpfNumber: cpfNumber ?? this.cpfNumber,
      formatedCpfNumber: formatedCpfNumber ?? this.formatedCpfNumber,
      rgNumber: rgNumber ?? this.rgNumber,
      pisNumber: pisNumber ?? this.pisNumber,
      formatedRgNumber: formatedRgNumber ?? this.formatedRgNumber,
      name: name ?? this.name,
      nameReduced: nameReduced ?? this.nameReduced,
      email: email ?? this.email,
      isFired: isFired ?? this.isFired,
      jobRoleString: jobRoleString ?? this.jobRoleString,
      accountEmails: accountEmails ?? this.accountEmails,
    );
  }
}


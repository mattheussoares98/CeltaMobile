// lib/core/domain/entities/eletronic_access_key/bsf/bsf_eletronic_access_key_entity.dart
import 'package:equatable/equatable.dart';

class BSFEletronicAccessKeyEntity extends Equatable {
  final int? stateCode;
  final String? stateDescription;
  final String? emission;
  final int? year;
  final int? month;
  final String? cnpjEmitter;
  final int? fiscalNoteNumber;
  final int? documentType;
  final String? documentTypeCode;
  final int? fiscalNoteSerial;
  final String? fiscalNoteSerialString;
  final int? emissionType;
  final String? emissionTypeCode;
  final String? codeRandomToNfeV2;
  final String? codeRandomComplete;
  final int? digit;

  const BSFEletronicAccessKeyEntity({
    this.stateCode,
    this.stateDescription,
    this.emission,
    this.year,
    this.month,
    this.cnpjEmitter,
    this.fiscalNoteNumber,
    this.documentType,
    this.documentTypeCode,
    this.fiscalNoteSerial,
    this.fiscalNoteSerialString,
    this.emissionType,
    this.emissionTypeCode,
    this.codeRandomToNfeV2,
    this.codeRandomComplete,
    this.digit,
  });

  @override
  List<Object?> get props => [
    stateCode,
    stateDescription,
    emission,
    year,
    month,
    cnpjEmitter,
    fiscalNoteNumber,
    documentType,
    documentTypeCode,
    fiscalNoteSerial,
    fiscalNoteSerialString,
    emissionType,
    emissionTypeCode,
    codeRandomToNfeV2,
    codeRandomComplete,
    digit,
  ];
}

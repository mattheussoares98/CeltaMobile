// lib/features/sale_request/domain/entities/bsf/bsf_driver_infos_entity.dart
import 'package:equatable/equatable.dart';

class BSFDriverInfosEntity extends Equatable {
  final bool? isDriver;
  final String? driverDocument;
  final DateTime? driverDocumentExpiration;
  final int? driverCategory;

  const BSFDriverInfosEntity({
    required this.isDriver,
    required this.driverDocument,
    required this.driverDocumentExpiration,
    required this.driverCategory,
  });

  @override
  List<Object?> get props => [
        isDriver,
        driverDocument,
        driverDocumentExpiration,
        driverCategory,
      ];
}

// lib/features/process_authorization/domain/entities/bsf_authorization_process_item_entity.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFProcessAuthorizationItemEntity extends Equatable {
  final int? code;
  final String? name;
  final String? description;
  final BSFProcessAuthorizationItemType? type;
  final TypeAccordingToTheCode? typeAccordingToTheCode;

  const BSFProcessAuthorizationItemEntity({
    this.code,
    this.name,
    this.description,
    this.type,
    this.typeAccordingToTheCode,
  });

  @override
  List<Object?> get props => [
    code,
    name,
    description,
    type,
    typeAccordingToTheCode,
  ];
}

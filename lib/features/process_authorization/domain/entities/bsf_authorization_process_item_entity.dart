// lib/features/process_authorization/domain/entities/bsf_authorization_process_item_entity.dart
import 'package:equatable/equatable.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFAuthorizationProcessItemEntity extends Equatable {
  final int? code;
  final String? name;
  final String? description;
  final BSFAuthorizationProcessItemType? type;
  final BSFAuthorizationProcessCategoryEntity? category;

  const BSFAuthorizationProcessItemEntity({
    this.code,
    this.name,
    this.description,
    this.type,
    this.category,
  });

  @override
  List<Object?> get props => [code, name, description, type, category];
}

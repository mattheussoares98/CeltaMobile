// lib/features/process_authorization/domain/entities/bsf_authorization_process_category_entity.dart
import 'package:equatable/equatable.dart';

class BSFAuthorizationProcessCategoryEntity extends Equatable {
  final int? code;
  final String? name;

  const BSFAuthorizationProcessCategoryEntity({
    this.code,
    this.name,
  });

  @override
  List<Object?> get props => [code, name];
}

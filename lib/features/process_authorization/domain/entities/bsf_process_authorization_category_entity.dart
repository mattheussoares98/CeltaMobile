// lib/features/process_authorization/domain/entities/bsf_authorization_process_category_entity.dart
import 'package:equatable/equatable.dart';

//TODO created BSFProcessAuthorizationCategory TYPE. If it works, should delete this entity here
class BSFProcessAuthorizationCategoryEntity extends Equatable {
  final int? code;
  final String? name;

  const BSFProcessAuthorizationCategoryEntity({this.code, this.name});

  @override
  List<Object?> get props => [code, name];
}

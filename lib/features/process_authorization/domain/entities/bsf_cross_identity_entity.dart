// lib/features/process_authorization/domain/entities/bsf_cross_identity_entity.dart
import 'package:equatable/equatable.dart';

class BSFCrossIdentityEntity extends Equatable {
  final String? identification;
  final String? password;

  const BSFCrossIdentityEntity({
    this.identification,
    this.password,
  });

  @override
  List<Object?> get props => [identification, password];
}

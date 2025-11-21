// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class ConcurrentEntity extends Equatable {
  final int? ConcurrentCode;
  final String? Name;
  final String? Observation;
  final AddressEntity? Address;

  const ConcurrentEntity({
    required this.ConcurrentCode,
    required this.Name,
    required this.Observation,
    required this.Address,
  });

  @override
  List<Object?> get props => [ConcurrentCode, Name, Observation, Address];

  ConcurrentEntity copyWith({
    int? ConcurrentCode,
    String? Name,
    String? Observation,
    AddressEntity? Address,
  }) {
    return ConcurrentEntity(
      ConcurrentCode: ConcurrentCode ?? this.ConcurrentCode,
      Name: Name ?? this.Name,
      Observation: Observation ?? this.Observation,
      Address: Address ?? this.Address,
    );
  }
}

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
}

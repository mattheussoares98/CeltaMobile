import 'package:equatable/equatable.dart';

class BSFUserAuthorizationEntity extends Equatable {
  final String? identification;

  const BSFUserAuthorizationEntity({required this.identification});

  @override
  List<Object?> get props => [identification];
}

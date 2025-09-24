import 'package:equatable/equatable.dart';

import 'entities.dart';

class UserSessionEntity extends Equatable {
  final UserEntity user;
  final EnterpriseEntity enterprise;
  const UserSessionEntity({required this.user, required this.enterprise});

  @override
  List<Object?> get props => [user, enterprise];

  UserSessionEntity copyWith({UserEntity? user, EnterpriseEntity? enterprise}) {
    return UserSessionEntity(
      user: user ?? this.user,
      enterprise: enterprise ?? this.enterprise,
    );
  }
}

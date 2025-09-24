import 'package:equatable/equatable.dart';

import 'entities.dart';

class UserSessionEntity extends Equatable {
  final UserEntity user;
  final EnterpriseEntity supabaseEnterprise;
  const UserSessionEntity({
    required this.user,
    required this.supabaseEnterprise,
  });

  @override
  List<Object?> get props => [user, supabaseEnterprise];

  UserSessionEntity copyWith({
    UserEntity? user,
    EnterpriseEntity? supabaseEnterprise,
  }) {
    return UserSessionEntity(
      user: user ?? this.user,
      supabaseEnterprise: supabaseEnterprise ?? this.supabaseEnterprise,
    );
  }
}

import 'package:equatable/equatable.dart';

import 'entities.dart';

class UserSessionEntity extends Equatable {
  final UserEntity user;
  final EnterpriseEntity? supabaseEnterprise;
  final EnterpriseEntity? selectedEnterprise;
  const UserSessionEntity({
    required this.user,
    required this.supabaseEnterprise,
    this.selectedEnterprise,
  });

  @override
  List<Object?> get props => [user, supabaseEnterprise, selectedEnterprise];

  UserSessionEntity copyWith({
    UserEntity? user,
    EnterpriseEntity? supabaseEnterprise,
    EnterpriseEntity? selectedEnterprise,
  }) {
    return UserSessionEntity(
      user: user ?? this.user,
      supabaseEnterprise: supabaseEnterprise ?? this.supabaseEnterprise,
      selectedEnterprise: selectedEnterprise ?? this.selectedEnterprise,
    );
  }
}

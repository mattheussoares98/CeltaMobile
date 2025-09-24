import 'package:equatable/equatable.dart';

import '../../../features/auth/data/models/models.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class UserSessionModel extends Equatable {
  final UserModel user;
  final SupabaseEnterpriseModel enterprise;
  final SoapEnterpriseModel? selectedEnterprise;
  const UserSessionModel({
    required this.user,
    required this.enterprise,
    this.selectedEnterprise,
  });

  @override
  List<Object?> get props => [user, enterprise];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': user.toJson(),
    'enterprise': enterprise.toJson(),
  };

  factory UserSessionModel.fromJson(Map<String, dynamic> json) =>
      UserSessionModel(
        user: UserModel.fromJson(Map<String, dynamic>.from(json['user'])),
        enterprise: SupabaseEnterpriseModel.fromJson(
          Map<String, dynamic>.from(json['enterprise']),
        ),
      );

  factory UserSessionModel.fromEntity(UserSessionEntity entity) =>
      UserSessionModel(
        user: UserModel.fromEntity(entity.user),
        enterprise: SupabaseEnterpriseModel.fromEntity(
          entity.supabaseEnterprise,
        ),
      );

  UserSessionEntity toEntity() => UserSessionEntity(
    user: user.toEntity(),
    supabaseEnterprise: enterprise.toEntity(),
  );
}

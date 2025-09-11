import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? enterpriseName;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const UserEntity({
    required this.name,
    required this.enterpriseName,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  @override
  List<Object?> get props => [
    name,
    enterpriseName,
    AccessKey,
    CrossIdentity_Usuario,
  ];

  UserEntity copyWith({
    String? name,
    String? enterpriseName,
    String? AccessKey,
    String? CrossIdentity_Usuario,
  }) {
    return UserEntity(
      name: name ?? this.name,
      enterpriseName: enterpriseName ?? this.enterpriseName,
      AccessKey: AccessKey ?? this.AccessKey,
      CrossIdentity_Usuario:
          CrossIdentity_Usuario ?? this.CrossIdentity_Usuario,
    );
  }
}

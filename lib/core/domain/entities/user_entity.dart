import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const UserEntity({
    required this.name,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  @override
  List<Object?> get props => [name, AccessKey, CrossIdentity_Usuario];

  UserEntity copyWith({
    String? name,
    String? AccessKey,
    String? CrossIdentity_Usuario,
  }) {
    return UserEntity(
      name: name ?? this.name,
      AccessKey: AccessKey ?? this.AccessKey,
      CrossIdentity_Usuario:
          CrossIdentity_Usuario ?? this.CrossIdentity_Usuario,
    );
  }
}

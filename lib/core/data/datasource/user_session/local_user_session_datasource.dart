import 'dart:math';

import 'package:celta_inventario/core/data/models/user_session_model.dart';
import 'package:hive/hive.dart';

import 'package:celta_inventario/features/auth/data/models/models.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/core/data/datasource/user_session/user_session.dart';

class LocalUserSessionDatasource implements ILocalUserSessionDatasource {
  final Box box;
  final String Function() _installationIdFactory;

  LocalUserSessionDatasource(
    this.box, {
    String Function()? installationIdFactory,
  }) : _installationIdFactory =
           installationIdFactory ?? _generateInstallationId;

  @override
  Future<String> getOrCreateInstallationId() async {
    final storedInstallationId = await box.get(
      DatabaseConstants.installationIdKey,
    );

    if (storedInstallationId is String &&
        storedInstallationId.trim().isNotEmpty) {
      return storedInstallationId;
    }

    final installationId = _installationIdFactory();
    await box.put(DatabaseConstants.installationIdKey, installationId);
    return installationId;
  }

  @override
  Future<void> logout() async {
    final localUser = await box.get(DatabaseConstants.userSession.name);
    await box.delete(DatabaseConstants.userSession.name);

    if (localUser != null) {
      final userSession = UserSessionModel.fromJson(
        Map<String, dynamic>.from(localUser),
      );
      await box.put(
        DatabaseConstants.userSession.name,
        UserSessionModel(
          user: UserModel(
            name: userSession.user.name,
            enterpriseName: userSession.user.enterpriseName,
            AccessKey: null,
            CrossIdentity_Usuario: null,
            CodigoInterno_Usuario: null,
          ),
          enterprise: null,
        ).toJson(),
      );
    }
  }

  @override
  Future<UserSessionModel?> get() async {
    final localSession = await box.get(DatabaseConstants.userSession.name);

    if (localSession == null) {
      return null;
    } else {
      return UserSessionModel.fromJson(localSession);
    }
  }

  @override
  Future<void> save(UserSessionModel session) async {
    await box.delete(DatabaseConstants.userSession.name);
    await box.put(DatabaseConstants.userSession.name, session.toJson());
  }
}

String _generateInstallationId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));

  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  final hex = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();

  return '${hex.substring(0, 8)}-'
      '${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-'
      '${hex.substring(20)}';
}

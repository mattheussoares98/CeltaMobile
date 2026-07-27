import 'package:celta_inventario/core/data/datasource/user_session/user_session.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/features/auth/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalUserSessionDatasource sut;

  late MockBox hive;

  late UserSessionEntity userSessionEntity;
  late String installationId;

  void initSut() {
    sut = LocalUserSessionDatasource(
      hive,
      installationIdFactory: () => installationId,
    );
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      DatabaseConstants.userSession.name,
      UserSessionModel.fromEntity(userSessionEntity).toJson(),
    );
  }

  void initEntities() {
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    installationId = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('logout', () {
    test('Should behave correctly', () async {
      await sut.logout();

      verify(() => hive.get(DatabaseConstants.userSession.name)).called(1);
      verify(() => hive.delete(DatabaseConstants.userSession.name)).called(1);
      verify(
        () => hive.put(
          DatabaseConstants.userSession.name,
          UserSessionModel(
            user: UserModel(
              name: userSessionEntity.user.name,
              enterpriseName: userSessionEntity.user.enterpriseName,
              AccessKey: null,
              CrossIdentity_Usuario: null,
              CodigoInterno_Usuario: null,
            ),
            enterprise: null,
          ).toJson(),
        ),
      ).called(1);
    });
  });

  group('getOrCreateInstallationId', () {
    test('Should return the stored installation ID', () async {
      hive.mockGet(DatabaseConstants.installationIdKey, installationId);

      expect(await sut.getOrCreateInstallationId(), installationId);

      verify(() => hive.get(DatabaseConstants.installationIdKey)).called(1);
      verifyNever(
        () => hive.put(DatabaseConstants.installationIdKey, installationId),
      );
    });

    test('Should generate and persist a new installation ID', () async {
      hive.mockGet(DatabaseConstants.installationIdKey, null);

      expect(await sut.getOrCreateInstallationId(), installationId);

      verify(() => hive.get(DatabaseConstants.installationIdKey)).called(1);
      verify(
        () => hive.put(DatabaseConstants.installationIdKey, installationId),
      ).called(1);
    });
  });

  group('Get', () {
    test('Should behave correctly', () async {
      expect(
        await sut.get(),
        UserSessionModel.fromEntity(
          userSessionEntity.copyWith(
            supabaseEnterprise: userSessionEntity.supabaseEnterprise?.copyWith(
              annulWorkingUrl: true,
            ),
          ),
        ),
      );

      verify(() => hive.get(DatabaseConstants.userSession.name)).called(1);
    });

    test('Should return null if hive returns null', () async {
      hive.mockGet(DatabaseConstants.userSession.name, null);

      expect(await sut.get(), isNull);
    });
  });

  group("Save", () {
    test("Should call hive with correct params", () async {
      await sut.save(UserSessionModel.fromEntity(userSessionEntity));

      verify(() => hive.delete(DatabaseConstants.userSession.name)).called(1);
      verify(
        () => hive.put(
          DatabaseConstants.userSession.name,
          UserSessionModel.fromEntity(userSessionEntity).toJson(),
        ),
      ).called(1);
    });
  });
}

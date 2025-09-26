import 'package:celta_intelligence/core/data/datasource/user_session/user_session.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/infraestructure/infrastructure.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalUserSessionDatasource sut;

  late MockBox hive;

  late UserSessionEntity userSessionEntity;

  void initSut() {
    sut = LocalUserSessionDatasource(hive);
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
            ),
            enterprise: null,
            selectedEnterprise: null,
          ).toJson(),
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should behave correctly', () async {
      expect(await sut.get(), UserSessionModel.fromEntity(userSessionEntity));

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

import 'package:celta_intelligence/core/constants/database_keys.dart';
import 'package:celta_intelligence/core/data/datasource/user_session/user_session.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
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
      DatabaseKeys.userSession.name,
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

  group('clear', () {
    test('Should call delete with correct params', () async {
      await sut.clear();

      verify(() => hive.delete(DatabaseKeys.userSession.name)).called(1);
    });
  });
  group('Get', () {
    test('Should behave correctly', () async {
      expect(await sut.get(), UserSessionModel.fromEntity(userSessionEntity));

      verify(() => hive.get(DatabaseKeys.userSession.name)).called(1);
    });

    test('Should return null if hive returns null', () async {
      hive.mockGet(DatabaseKeys.userSession.name, null);

      expect(await sut.get(), isNull);
    });
  });

  group("Save", () {
    test("Should call hive with correct params", () async {
      await sut.save(UserSessionModel.fromEntity(userSessionEntity));

      verify(() => hive.delete(DatabaseKeys.userSession.name)).called(1);
      verify(
        () => hive.put(
          DatabaseKeys.userSession.name,
          UserSessionModel.fromEntity(userSessionEntity).toJson(),
        ),
      ).called(1);
    });
  });
}

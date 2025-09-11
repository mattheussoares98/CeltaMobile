import 'package:celta_intelligence/core/constants/database_keys.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/auth/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthLocalDatasource sut;

  late MockBox mockBox;

  late UserEntity userEntity;

  void initSut() {
    sut = AuthLocalDatasource(mockBox);
  }

  void initInjections() {
    mockBox = MockBox();
  }

  // void mockSuccess() {}

  void initEntities() {
    userEntity = EntityFactory.makeUserEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    // mockSuccess();
  });

  group('logout', () {
    test('should behave correctly', () async {
      mockBox.mockGet(
        DatabaseKeys.user.name,
        UserModel.fromEntity(userEntity).toJson(),
      );

      await sut.logout();

      verify(() => mockBox.get(DatabaseKeys.user.name)).called(1);
      verify(() => mockBox.delete(DatabaseKeys.user.name)).called(1);
      verify(
        () => mockBox.put(
          DatabaseKeys.user.name,
          UserModel(
            name: userEntity.name,
            enterpriseName: userEntity.enterpriseName,
            AccessKey: null,
            CrossIdentity_Usuario: null,
          ).toJson(),
        ),
      ).called(1);
    });
  });

  group('get user', () {
    test('should return the correct user', () async {
      mockBox.mockGet(
        DatabaseKeys.user.name,
        UserModel.fromEntity(userEntity).toJson(),
      );

      final result = await sut.getUser();

      expect(result, userEntity);
      verify(() => mockBox.get(DatabaseKeys.user.name)).called(1);
    });

    test('should return null when the box does not have a value', () async {
      mockBox.mockGet(DatabaseKeys.user.name, null);

      final result = await sut.getUser();

      expect(result, isNull);
      verify(() => mockBox.get(DatabaseKeys.user.name)).called(1);
    });
  });

  group("Save user", () {
    test("Should save the user correctly", () async {
      await sut.saveUser(userEntity);

      verify(
        () => mockBox.put(
          DatabaseKeys.user.name,
          UserModel.fromEntity(userEntity).toJson(),
        ),
      ).called(1);
    });
  });
}

import 'package:celta_intelligence/core/constants/database_keys.dart';
import 'package:celta_intelligence/features/auth/data/data_source/data_source.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthLocalDatasource sut;

  late MockBox mockBox;

  late UserModel userModel;

  void initSut() {
    sut = AuthLocalDatasource(mockBox);
  }

  void initInjections() {
    mockBox = MockBox();
  }

  // void mockSuccess() {}

  void initEntities() {
    userModel = ModelFactory.makeUserModel();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    // mockSuccess();
  });

  group('clearUser', () {
    test('should call delete with correct key', () async {
      when(() => mockBox.delete(any())).thenAnswer((_) async => {});

      await sut.clearUser();

      verify(() => mockBox.delete(DatabaseKeys.user)).called(1);
    });
  });

  group('get user', () {
    test('should return the correct user', () async {
      when(
        () => mockBox.get(DatabaseKeys.user.name),
      ).thenReturn(userModel.toJson());

      final result = await sut.getUser();

      expect(result, userModel.toEntity());
      verify(() => mockBox.get(DatabaseKeys.user.name)).called(1);
    });

    test('should return null when the box does not have a value', () async {
      when(() => mockBox.get(DatabaseKeys.user.name)).thenReturn(null);

      final result = await sut.getUser();

      expect(result, isNull);
      verify(() => mockBox.get(DatabaseKeys.user.name)).called(1);
    });
  });

  group("Save user", () {
    test("Should save the user correctly", () async {
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      await sut.saveUser(userModel.toEntity());

      verify(
        () => mockBox.put(DatabaseKeys.user, userModel.toJson()),
      ).called(1);
    });
  });
}

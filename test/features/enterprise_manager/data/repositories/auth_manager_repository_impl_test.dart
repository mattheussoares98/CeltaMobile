import 'package:celta_inventario/features/enterprise_manager/data/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthManagerRepositoryImpl sut;

  late MockAuthManagerDatasource authManagerDatasource;

  late AuthResponse authResponse;
  late String email;
  late String password;

  void initSut() {
    sut = AuthManagerRepositoryImpl(authManagerDatasource);
  }

  void initInjections() {
    authManagerDatasource = MockAuthManagerDatasource();
  }

  void mockSuccess() {
    authManagerDatasource.mockLogin(authResponse);
  }

  void initEntities() {
    authResponse = AuthResponse(
      user: User(
        id: faker.randomGenerator.string(10),
        appMetadata: {},
        userMetadata: {},
        aud: faker.randomGenerator.string(10),
        createdAt: faker.randomGenerator.string(10),
      ),
    );

    email = faker.internet.email();
    password = faker.internet.password();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('logIn', () {
    test('should behave correctly on success', () async {
      await sut.login(email, password);

      verify(() => authManagerDatasource.login(email, password)).called(1);

      verifyNoMoreInteractions(authManagerDatasource);
    });
  });
}

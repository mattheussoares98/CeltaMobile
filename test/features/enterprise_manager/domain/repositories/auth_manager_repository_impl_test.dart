import 'package:celta_intelligence/features/enterprise_manager/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthManagerRepositoryImpl sut;

  late MockAuthManagerDataSource authManagerDataSource;

  late AuthResponse authResponse;
  late String email;
  late String password;

  void initSut() {
    sut = AuthManagerRepositoryImpl(authManagerDataSource);
  }

  void initInjections() {
    authManagerDataSource = MockAuthManagerDataSource();
  }

  void mockSuccess() {
    authManagerDataSource.mockLogin(authResponse);
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

      verify(() => authManagerDataSource.login(email, password)).called(1);

      verifyNoMoreInteractions(authManagerDataSource);
    });
  });
}

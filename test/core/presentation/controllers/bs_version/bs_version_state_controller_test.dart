import 'package:celta_inventario/core/data/datasource/bs_version/bs_version.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/bs_version/bs_version_state_controller.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/bs_version/bs_version.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockSoapBsVersionDatasource extends Mock
    implements ISoapBsVersionDatasource {}

void main() {
  late MockSoapBsVersionDatasource mockDatasource;

  late UserSessionModel userSession;

  late DateTime bsVersion;

  setUp(() {
    mockDatasource = MockSoapBsVersionDatasource();

    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    bsVersion = faker.date.dateTime();
  });

  setUpAll(() {
    for (var value in Modules.values) {
      registerFallbackValue(value);
    }
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        soapBsVersionDatasourceProvider.overrideWithValue(mockDatasource),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(userSession),
        ),
      ],
    );
  }

  group('Build', () {
    test('should return the correct value on success', () async {
      // ARRANGE
      when(() => mockDatasource.get(any())).thenAnswer((_) async => bsVersion);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        bsVersionStateControllerProvider.future,
      );

      expect(result, bsVersion);
      verify(() => mockDatasource.get(any())).called(1);
    });
    test('should return throw on error', () async {
      // ARRANGE
      when(() => mockDatasource.get(any())).thenThrow(Exception());

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(bsVersionStateControllerProvider.future),
        throwsA(isA<Exception>()),
      );

      verify(() => mockDatasource.get(any())).called(1);
    });
  });
}

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

class MockEcSellerRepository extends Mock implements IEcSellerRepository {}

void main() {
  late MockEcSellerRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<EcSellerEntity> fakeSellers;
  late GetSellerParams
  params; //TODO change this file name and put Ec before starting the name

  setUp(() {
    mockRepository = MockEcSellerRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeSellers = [EntityFactory.makeSellerEntity()];
    params = GetSellerParams(
      params: EcRequestParams(
        workingUrl: fakeSession.enterprise!.workingUrl!,
        user: fakeSession.user.name!,
        accessKey: fakeSession.user.AccessKey!,
      ),
      enterpriseCode: fakeSession.enterprise!.id,
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSellerRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('SellersStateController', () {
    test(
      'should call repository and return a list of sellers on success',
      () async {
        // ARRANGE

        when(
          () => mockRepository.get(params),
        ).thenAnswer((_) async => fakeSellers);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          sellersStateControllerProvider(fakeSession.enterprise!.id!).future,
        );

        // ASSERT
        expect(result, fakeSellers);
        verify(() => mockRepository.get(params)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          sellersStateControllerProvider(fakeSession.enterprise!.id!).future,
        ),
        throwsA(isA<AppException>()),
      );

      verifyNever(() => mockRepository.get(params));
    });
  });
}

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/buyer/buyer.dart';
import 'package:celta_intelligence/core/presentation/controllers/buyer/buyer.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/buyer/buyer.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadBuyersRepository extends Mock
    implements ISoapLoadBuyersRepository {}

void main() {
  late MockSoapLoadBuyersRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<BuyerEntity> fakeBuyers;

  setUp(() {
    mockRepository = MockSoapLoadBuyersRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeBuyers = [EntityFactory.makeBuyerEntity()];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadBuyersRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('BuyersStateController', () {
    test(
      'should call repository and return a list of buyers on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
          ),
        ).thenAnswer((_) async => fakeBuyers);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT: Reading the future triggers the build and waits for completion.
        final result = await container.read(
          buyersStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeBuyers);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          ),
        ).called(1);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path in the Fake.
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT: Expect the future to throw an AppException.
      await expectLater(
        container.read(buyersStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was never called.
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
        ),
      );
    });
  });
}

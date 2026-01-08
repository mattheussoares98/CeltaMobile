import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/transfer_request/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/transfer_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadDestinyEnterprisesRepository extends Mock
    implements ISoapLoadDestinyEnterprisesRepository {}

void main() {
  late MockSoapLoadDestinyEnterprisesRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<EnterpriseEntity> fakeEnterprises;
  late int fakeRequestTypeCode;
  late int fakeEnterpriseOriginCode;

  setUp(() {
    mockRepository = MockSoapLoadDestinyEnterprisesRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprises = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
    fakeRequestTypeCode = faker.randomGenerator.integer(100);
    fakeEnterpriseOriginCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadDestinyEnterprisesRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('DestinyEnterprisesStateController', () {
    test(
      'should call repository and return a list of enterprises on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            requestTypeCode: any(named: 'requestTypeCode'),
            enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
          ),
        ).thenAnswer((_) async => fakeEnterprises);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT: Reading the future triggers the build and waits for completion.
        final result = await container.read(
          destinyEnterprisesStateControllerProvider(
            requestTypeCode: fakeRequestTypeCode,
            enterpriseOriginCode: fakeEnterpriseOriginCode,
          ).future,
        );

        // ASSERT
        expect(result, fakeEnterprises);
        verify(
          () => mockRepository.load(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            requestTypeCode: fakeRequestTypeCode,
            enterpriseOriginCode: fakeEnterpriseOriginCode,
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
        container.read(
          destinyEnterprisesStateControllerProvider(
            requestTypeCode: fakeRequestTypeCode,
            enterpriseOriginCode: fakeEnterpriseOriginCode,
          ).future,
        ),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was never called.
      verifyNever(
        () => mockRepository.load(
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          requestTypeCode: any(named: 'requestTypeCode'),
          enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
        ),
      );
    });
  });
}

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../mocks/mocks.dart';

class MockIEcPaymentFinalizationRepository extends Mock
    implements IEcPaymentFinalizationRepository {}

void main() {
  late MockIEcPaymentFinalizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late int enterpriseCode;

  setUpAll(() {
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  setUp(() {
    enterpriseCode = faker.randomGenerator.integer(100);
    mockRepository = MockIEcPaymentFinalizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        ecPaymentFinalizationRepositoryProvider.overrideWith(
          (_) => mockRepository,
        ),
      ],
    );
  }

  group('AllPaymentFinalizationsController', () {
    test(
      'should fetch payment finalizations from repository with correct params',
      () async {
        final fakeFinalizations = [
          EntityFactory.makeBSFPaymentFinalizationEntity(),
          EntityFactory.makeBSFPaymentFinalizationEntity(),
        ];

        // ARRANGE
        when(
          () => mockRepository.getPaymentFinalizations(
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async => fakeFinalizations);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          allPaymentFinalizationsControllerProvider(
            enterpriseCode: enterpriseCode,
          ).future,
        );

        // ASSERT
        expect(result, fakeFinalizations);
        verify(
          () => mockRepository.getPaymentFinalizations(
            enterpriseCode: enterpriseCode,
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
          ),
        ).called(1);
      },
    );
  });
}

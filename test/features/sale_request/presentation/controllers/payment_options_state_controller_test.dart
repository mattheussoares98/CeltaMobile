import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart'
    hide BSFPaymentFinalizationEntity;
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late MockEcSaleRequestsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<BSFPaymentFinalizationEntity> fakePaymentOptions;
  const enterpriseCode = 1;

  setUpAll(() {
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  setUp(() {
    mockRepository = MockEcSaleRequestsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakePaymentOptions = [EntityFactory.makeBSFPaymentFinalizationEntity()];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        ecSaleRequestsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('PaymentOptionsStateController', () {
    test(
      'should call repository and return a list of payment options on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.getPaymentOptions(
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async => fakePaymentOptions);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          paymentOptionsStateControllerProvider(enterpriseCode).future,
        );

        // ASSERT
        expect(result, fakePaymentOptions);
        verify(
          () => mockRepository.getPaymentOptions(
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

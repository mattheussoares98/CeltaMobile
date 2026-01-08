import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/buy_request/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakePendingBuyRequestStateController
    extends PendingBuyRequestStateController {
  final PendingBuyRequestEntity? pendingRequest;
  FakePendingBuyRequestStateController(this.pendingRequest);
  @override
  Future<PendingBuyRequestEntity> build() async {
    if (pendingRequest == null) throw AppException('Pedido pendente inválido.');
    return pendingRequest!;
  }
}

class MockSoapLoadEnterpriseByFiltersRepository extends Mock
    implements ISoapLoadEnterpriseByFiltersRepository {}

void main() {
  late MockSoapLoadEnterpriseByFiltersRepository mockRepository;
  late UserSessionModel fakeSession;
  late PendingBuyRequestEntity fakePendingRequest;
  late List<EnterpriseEntity> fakeEnterprises;

  setUp(() {
    mockRepository = MockSoapLoadEnterpriseByFiltersRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakePendingRequest = EntityFactory.makePendingBuyRequestEntity();
    fakeEnterprises = [EntityFactory.makeEnterpriseEntity()];
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    PendingBuyRequestEntity? pendingRequest,
  }) {
    return ProviderContainer(
      overrides: [
        soapLoadEnterpriseByFiltersRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        pendingBuyRequestStateControllerProvider.overrideWith(
          () => FakePendingBuyRequestStateController(pendingRequest),
        ),
      ],
    );
  }

  group('EnterprisesStateController', () {
    test(
      'should call repository and return a list of enterprises on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            urlInUse: any(named: 'urlInUse'),
            crossIdentity: any(named: 'crossIdentity'),
            supplierCode: any(named: 'supplierCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
          ),
        ).thenAnswer((_) async => fakeEnterprises);

        final container = makeProviderContainer(
          session: fakeSession,
          pendingRequest: fakePendingRequest,
        );
        addTearDown(container.dispose);

        // ACT: Wait for the build method to complete
        final result = await container.read(
          enterprisesStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeEnterprises);
        verify(
          () => mockRepository.load(
            urlInUse: fakeSession.enterprise!.urlInUse!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            supplierCode: fakePendingRequest.selectedSupplier!.Code,
            requestTypeCode: fakePendingRequest.selectedRequestType!.Code,
          ),
        ).called(1);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error
      final container = makeProviderContainer(
        session: null,
        pendingRequest: fakePendingRequest,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT: Expect the future to throw an AppException
      await expectLater(
        container.read(enterprisesStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was never called
      verifyNever(
        () => mockRepository.load(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          supplierCode: any(named: 'supplierCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
        ),
      );
    });

    test('should throw error when pending request is invalid', () async {
      // ARRANGE: Pass null for the pending request
      final container = makeProviderContainer(
        session: fakeSession,
        pendingRequest: null,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(enterprisesStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was never called
      verifyNever(
        () => mockRepository.load(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          supplierCode: any(named: 'supplierCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
        ),
      );
    });
  });
}

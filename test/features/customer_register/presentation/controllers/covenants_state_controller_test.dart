import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/customer_register/domain/entities/entities.dart';
import 'package:celta_intelligence/features/customer_register/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/customer_register/providers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:celta_intelligence/exceptions/exceptions.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadCovenantsRepository extends Mock
    implements ISoapLoadCovenantsRepository {}

void main() {
  late MockSoapLoadCovenantsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<CovenantEntity> fakeCovenants;
  late EnterpriseEntity enterpriseEntity;

  setUpAll(() {
    registerFallbackValue(SearchCovenantType.approximateName);
  });

  setUp(() {
    mockRepository = MockSoapLoadCovenantsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeCovenants = [EntityFactory.makeCovenantEntity()];
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
  });

  // THE FIX 1: Make your container helper flexible
  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadCovenantsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterpriseEntity),
        ),
      ],
    );
  }

  group('CovenantsStateController', () {
    test(
      'should call repository and return a list of covenants on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            urlInUse: any(named: 'urlInUse'),
            crossIdentity: any(named: 'crossIdentity'),
            searchCovenantType: any(named: 'searchCovenantType'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async => fakeCovenants);

        // Pass the valid session here
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(covenantsStateControllerProvider.future),
          completion(equals(fakeCovenants)),
        );

        verify(
          () => mockRepository.load(
            urlInUse: fakeSession.enterprise!.urlInUse!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            searchCovenantType: SearchCovenantType.approximateName,
            searchValue: "%",
          ),
        ).called(1);
      },
    );

    test('should emit [error] when session is invalid', () async {
      // ARRANGE
      // THE FIX 2: Pass NULL for the session to simulate the failure case.
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT
      // The FakeValidatedUserSession will now throw an AppException,
      // which the CovenantsStateController will catch and re-throw.
      await expectLater(
        container.read(covenantsStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was NEVER called because the session was invalid.
      verifyNever(
        () => mockRepository.load(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          searchCovenantType: any(named: 'searchCovenantType'),
          searchValue: any(named: 'searchValue'),
        ),
      );
    });
  });
}

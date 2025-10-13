import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/expedition_conference/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLoadExpeditionDocumentsRepository extends Mock
    implements ISoapLoadExpeditionDocumentsRepository {}

void main() {
  late MockSoapLoadExpeditionDocumentsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<ExpeditionDocumentEntity> fakeDocuments;
  late int fakeEnterpriseCode;
  late EnterpriseEntity fakeEnterprise;

  setUp(() {
    mockRepository = MockSoapLoadExpeditionDocumentsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeDocuments = [EntityFactory.makeExpeditionDocumentEntity()];
    fakeEnterpriseCode = faker.randomGenerator.integer(100);
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadExpeditionDocumentsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ExpeditionDocumentsStateController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async call
          return fakeDocuments;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<List<ExpeditionDocumentEntity>?>>[];
        container.listen(
          expeditionDocumentsStateControllerProvider(
            fakeEnterpriseCode,
            fakeEnterprise.name,
          ),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              expeditionDocumentsStateControllerProvider(
                fakeEnterpriseCode,
                fakeEnterprise.name,
              ).notifier,
            )
            .load(fakeEnterpriseCode);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeDocuments);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterpriseCode,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      final states = <AsyncValue<List<ExpeditionDocumentEntity>?>>[];
      container.listen(
        expeditionDocumentsStateControllerProvider(
          fakeEnterpriseCode,
          fakeEnterprise.name,
        ),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            expeditionDocumentsStateControllerProvider(
              fakeEnterpriseCode,
              fakeEnterprise.name,
            ).notifier,
          )
          .load(fakeEnterpriseCode);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
        ),
      );
    });
  });
}

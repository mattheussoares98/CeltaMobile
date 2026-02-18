import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/repositories/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/core/presentation/controllers/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/transfer_justification/transfer_justification.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapTransferJustificationRepository extends Mock
    implements ISoapTransferJustificationRepository {}

void main() {
  late MockSoapTransferJustificationRepository
  soapTransferJustificationRepository;
  late UserSessionModel userSession;
  late List<TransferJustificationEntity> justificationsEntities;

  // Define test parameters
  late int enterpriseCode;
  late TransferJustificationType justificationType;

  setUp(() {
    soapTransferJustificationRepository =
        MockSoapTransferJustificationRepository();
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    justificationsEntities = [EntityFactory.makeTransferJustificationEntity()];
    enterpriseCode = faker.randomGenerator.integer(100);
    justificationType =
        TransferJustificationType.values[faker.randomGenerator.integer(
          TransferJustificationType.values.length,
        )];
  });

  setUpAll(() {
    for (var value in TransferJustificationType.values) {
      registerFallbackValue(value);
    }
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        // Override the two dependencies
        soapTransferJustificationRepositoryProvider.overrideWithValue(
          soapTransferJustificationRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('TransferJustificationStateController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => soapTransferJustificationRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) async => justificationsEntities);

        final container = makeProviderContainer(session: userSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<List<TransferJustificationEntity>>>[];
        container.listen(
          transferJustificationStateControllerProvider(
            enterpriseCode,
            justificationType,
          ),
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // ACT: Wait for the build method to complete
        await container.read(
          transferJustificationStateControllerProvider(
            enterpriseCode,
            justificationType,
          ).future,
        );

        // ASSERT
        expect(states, [
          isA<AsyncLoading>(),
          isA<AsyncData<List<TransferJustificationEntity>>>(),
        ]);
        verify(
          () => soapTransferJustificationRepository.load(
            workingUrl: userSession.enterprise!.workingUrl!,
            crossIdentity: userSession.user.CrossIdentity_Usuario!,
            type: justificationType,
          ),
        ).called(1);
      },
    );
  });
}

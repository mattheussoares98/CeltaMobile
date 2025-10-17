import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapInventoryEntryQuantityRepository extends Mock
    implements ISoapInventoryEntryQuantityRepository {}

void main() {
  late MockSoapInventoryEntryQuantityRepository mockRepository;
  late UserSessionModel fakeSession;
  late int fakeCodigoInternoInvCont;
  late double quantity;
  late int productPackingCode;
  late bool isSubtract;

  setUp(() {
    quantity = faker.randomGenerator.decimal();
    mockRepository = MockSoapInventoryEntryQuantityRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeCodigoInternoInvCont = faker.randomGenerator.integer(1000);
    productPackingCode = faker.randomGenerator.integer(1000);
    isSubtract = faker.randomGenerator.boolean();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapInventoryEntryQuantityRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('EntryQuantityController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.entry(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            productPackingCode: any(named: 'productPackingCode'),
            quantity: any(named: 'quantity'),
            isSubtract: any(named: 'isSubtract'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        await container.read(
          entryQuantityStateControllerProvider(fakeCodigoInternoInvCont).future,
        );
        final states = <AsyncValue<int?>>[];
        container.listen(
          entryQuantityStateControllerProvider(fakeCodigoInternoInvCont),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              entryQuantityStateControllerProvider(
                fakeCodigoInternoInvCont,
              ).notifier,
            )
            .entry(
              productPackingCode: productPackingCode,
              quantity: quantity,
              isSubtract: isSubtract,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, productPackingCode);
        verify(
          () => mockRepository.entry(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: fakeCodigoInternoInvCont,
            productPackingCode: productPackingCode,
            quantity: quantity,
            isSubtract: isSubtract,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path in the Fake
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      await container.read(
        entryQuantityStateControllerProvider(fakeCodigoInternoInvCont).future,
      );
      final states = <AsyncValue<int?>>[];
      container.listen(
        entryQuantityStateControllerProvider(fakeCodigoInternoInvCont),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            entryQuantityStateControllerProvider(
              fakeCodigoInternoInvCont,
            ).notifier,
          )
          .entry(
            productPackingCode: productPackingCode,
            quantity: quantity,
            isSubtract: isSubtract,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.entry(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
          productPackingCode: any(named: 'productPackingCode'),
          quantity: any(named: 'quantity'),
          isSubtract: any(named: 'isSubtract'),
        ),
      );
    });
  });
}

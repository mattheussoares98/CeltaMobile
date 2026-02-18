import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// A "Spy" version of the cart controller
class SpyCartProductsStateController extends CartProductsStateController {
  final List<TransferRequestProductItemEntity> productsToReturn;
  SpyCartProductsStateController(this.productsToReturn);

  bool clearLotCalled = false; // Our "spy" property

  @override
  Future<List<TransferRequestProductItemEntity>> build(
    DraftKey draftKey,
  ) async {
    return productsToReturn;
  }

  @override
  Future<void> clearLot() async {
    clearLotCalled = true;
  }
}

// A "Spy" version of the last saved number controller
class SpyLastSavedNumberStateController extends LastSavedNumberStateController {
  String? savedNumber;
  @override
  Future<String?> build() async => null;
  @override
  Future<void> save(String number) async {
    savedNumber = number;
    state = AsyncData(number);
  }
}

class MockSoapInsertTransferRequestRepository extends Mock
    implements ISoapInsertTransferRequestRepository {}

void main() {
  late MockSoapInsertTransferRequestRepository mockRepository;
  late SpyCartProductsStateController spyCartController;
  late SpyLastSavedNumberStateController spyLastSavedNumberController;

  late UserSessionModel fakeSession;
  late DraftKey fakeDraftKey;
  late List<TransferRequestProductItemEntity> fakeProducts;
  late String fakeResponseNumber;

  setUpAll(() {
    registerFallbackValue(<TransferRequestProductItemEntity>[]);
  });

  setUp(() {
    mockRepository = MockSoapInsertTransferRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeDraftKey = const DraftKey(
      requestTypeCode: 1,
      enterpriseOrigin: 10,
      enterpriseDestinyCode: 20,
    );
    fakeProducts = [
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
    ];
    fakeResponseNumber = faker.randomGenerator.integer(100).toString();

    // Create new spies for each test
    spyCartController = SpyCartProductsStateController(fakeProducts);
    spyLastSavedNumberController = SpyLastSavedNumberStateController();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapInsertTransferRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        // Override with our spies
        cartProductsStateControllerProvider(
          fakeDraftKey,
        ).overrideWith(() => spyCartController),
        lastSavedNumberStateControllerProvider.overrideWith(
          () => spyLastSavedNumberController,
        ),
      ],
    );
  }

  group('InsertTransferRequestController', () {
    test(
      'should call repository, save number, and clear lot on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.save(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
            enterpriseDestinyCode: any(named: 'enterpriseDestinyCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
            products: any(named: 'products'),
          ),
        ).thenAnswer((_) async => fakeResponseNumber);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT: Reading the future triggers the build method

        await container
            .read(
              insertTransferRequestControllerProvider(fakeDraftKey).notifier,
            )
            .insert();

        // ASSERT
        // 1. Verify the repository was called
        verify(
          () => mockRepository.save(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseOriginCode: fakeDraftKey.enterpriseOrigin,
            enterpriseDestinyCode: fakeDraftKey.enterpriseDestinyCode,
            requestTypeCode: fakeDraftKey.requestTypeCode,
            products: fakeProducts,
          ),
        ).called(1);

        // 2. Verify the side-effects
        expect(spyLastSavedNumberController.savedNumber, fakeResponseNumber);
        expect(spyCartController.clearLotCalled, isTrue);
      },
    );

    test(
      'should throw error and not call side-effects when session is invalid',
      () async {
        // ARRANGE: Pass null for the session
        final container = makeProviderContainer(session: null);
        addTearDown(container.dispose);

        await container.read(
          insertTransferRequestControllerProvider(fakeDraftKey).future,
        ); // Wait for initial build

        final states = <AsyncValue<void>>[];
        container.listen(
          insertTransferRequestControllerProvider(fakeDraftKey),
          (_, next) => states.add(next),
        );

        // ACT & ASSERT

        await container
            .read(
              insertTransferRequestControllerProvider(fakeDraftKey).notifier,
            )
            .insert();

        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);

        // Verify no methods were called
        verifyNever(
          () => mockRepository.save(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
            enterpriseDestinyCode: any(named: 'enterpriseDestinyCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
            products: any(named: 'products'),
          ),
        );
        expect(spyLastSavedNumberController.savedNumber, isNull);
        expect(spyCartController.clearLotCalled, isFalse);
      },
    );
  });
}

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes, Mocks, and Spies ---

class FakeLastSavedSaleRequest extends LastSavedSaleRequestStateController {
  final LastSavedSaleRequestEntity? requestToReturn;
  FakeLastSavedSaleRequest(this.requestToReturn);
  @override
  Future<LastSavedSaleRequestEntity?> build(int enterpriseCode) async {
    return requestToReturn;
  }
}

// "Spy" for the IP controller
class SpyIpPrintSaleRequest extends IpPrintSaleRequestController {
  String? updatedIp;
  @override
  Future<String?> build() async => null;
  @override
  Future<void> updateIp(String ip) async {
    updatedIp = ip;
    state = AsyncData(ip);
  }
}

class MockPrintLastSavedSaleRequestRepository extends Mock
    implements IPrintLastSavedSaleRequestRepository {}

void main() {
  late MockPrintLastSavedSaleRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late LastSavedSaleRequestEntity fakeLastSavedRequest;
  late String fakeIp;

  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeLastSavedSaleRequestEntity());

    mockRepository = MockPrintLastSavedSaleRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeLastSavedRequest = EntityFactory.makeLastSavedSaleRequestEntity();
    fakeIp = faker.internet.ipv4Address();

    // Create the single container ONCE with all providers
    container = ProviderContainer(
      overrides: [
        printLastSavedSaleRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => FakeLastSavedSaleRequest(fakeLastSavedRequest)),
        ipPrintSaleRequestControllerProvider.overrideWith(
          () => SpyIpPrintSaleRequest(),
        ),
      ],
    );
  });

  tearDownAll(() {
    container.dispose();
  });

  tearDown(() {
    reset(mockRepository);
  });

  group('PrintLastSavedSaleRequestController', () {
    test(
      'should call repository, return true and update IP controller on success',
      () async {
        // ARRANGE
        final spyIpPrint = SpyIpPrintSaleRequest();

        // Update overrides for this specific test
        container.updateOverrides([
          printLastSavedSaleRequestRepositoryProvider.overrideWithValue(
            mockRepository,
          ),
          validatedUserSessionProvider.overrideWith(
            () => FakeValidatedUserSession(fakeSession),
          ),
          selectedEnterpriseStateControllerProvider.overrideWith(
            () => FakeSelectedEnterpriseStateController(fakeEnterprise),
          ),
          lastSavedSaleRequestStateControllerProvider(
            fakeEnterprise.Code!,
          ).overrideWith(() => FakeLastSavedSaleRequest(fakeLastSavedRequest)),
          ipPrintSaleRequestControllerProvider.overrideWith(() => spyIpPrint),
        ]);

        when(
          () => mockRepository.print(
            saleRequest: any(named: 'saleRequest'),
            ip: any(named: 'ip'),
            userName: any(named: 'userName'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return true;
        });

        final states = <AsyncValue<void>>[];
        container.listen(
          printLastSavedSaleRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        final printed = await container
            .read(printLastSavedSaleRequestControllerProvider.notifier)
            .print(fakeIp);

        // ASSERT
        expect(printed, isTrue);
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // 1. Verify repository was called
        verify(
          () => mockRepository.print(
            saleRequest: fakeLastSavedRequest,
            ip: fakeIp,
            userName: fakeSession.user.name!,
          ),
        ).called(1);

        // 2. Verify IP controller was updated
        expect(spyIpPrint.updatedIp, fakeIp);
      },
    );

    test(
      'should emit [loading, error] if last saved request is null',
      () async {
        // ARRANGE
        final spyIpPrint = SpyIpPrintSaleRequest();

        container.updateOverrides([
          printLastSavedSaleRequestRepositoryProvider.overrideWithValue(
            mockRepository,
          ),
          validatedUserSessionProvider.overrideWith(
            () => FakeValidatedUserSession(fakeSession),
          ),
          selectedEnterpriseStateControllerProvider.overrideWith(
            () => FakeSelectedEnterpriseStateController(fakeEnterprise),
          ),
          lastSavedSaleRequestStateControllerProvider(
            fakeEnterprise.Code!,
          ).overrideWith(() => FakeLastSavedSaleRequest(null)), // No request
          ipPrintSaleRequestControllerProvider.overrideWith(() => spyIpPrint),
        ]);

        final states = <AsyncValue<void>>[];
        container.listen(
          printLastSavedSaleRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        final printed = await container
            .read(printLastSavedSaleRequestControllerProvider.notifier)
            .print(fakeIp);

        // ASSERT
        expect(printed, isFalse);
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());
        expect(
          (states.last.error as AppException).message,
          'Ainda não foram encontrados pedidos salvos para imprimir',
        );

        // Verify no side-effects happened
        verifyNever(
          () => mockRepository.print(
            saleRequest: any(named: 'saleRequest'),
            ip: any(named: 'ip'),
            userName: any(named: 'userName'),
          ),
        );
        expect(spyIpPrint.updatedIp, isNull);
      },
    );

    test('should emit [loading, error] if session is invalid', () async {
      // ARRANGE
      container.updateOverrides([
        printLastSavedSaleRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(null),
        ), // Invalid session
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => FakeLastSavedSaleRequest(fakeLastSavedRequest)),
        ipPrintSaleRequestControllerProvider.overrideWith(
          () => SpyIpPrintSaleRequest(),
        ),
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        printLastSavedSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      final printed = await container
          .read(printLastSavedSaleRequestControllerProvider.notifier)
          .print(fakeIp);

      // ASSERT
      expect(printed, isFalse);
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}

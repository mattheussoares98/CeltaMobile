import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
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

class FakeSaleRequestDetails extends SaleRequestDetailsStateController {
  final BSFSaleRequestEntity requestToReturn;
  FakeSaleRequestDetails(this.requestToReturn);
  @override
  FutureOr<BSFSaleRequestEntity> build() => requestToReturn;
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

class MockPrintSaleRequest extends Mock
    implements IPrintSaleRequestRepository {}

void main() {
  late MockPrintSaleRequest mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late LastSavedSaleRequestEntity fakeSoapSaleRequest;
  late BSFSaleRequestEntity fakeBSFSaleRequest;
  late String ip;
  late int saleRequestCode;
  late int customerCode;
  late int enterpriseCode;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeLastSavedSaleRequestEntity());
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());

    mockRepository = MockPrintSaleRequest();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeSoapSaleRequest = EntityFactory.makeLastSavedSaleRequestEntity();
    ip = faker.internet.ipv4Address();
    saleRequestCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    enterpriseCode = faker.randomGenerator.integer(100);

    fakeBSFSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
  });

  tearDown(() {
    reset(mockRepository);
  });

  ProviderContainer makeProviderContainer({
    required UserSessionModel? session,
    SpyIpPrintSaleRequest? spyIpPrint,
    bool? returnNullLastSavedSaleRequest,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        printSaleRequestRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(
          () => FakeLastSavedSaleRequest(
            returnNullLastSavedSaleRequest == true ? null : fakeSoapSaleRequest,
          ),
        ),
        ipPrintSaleRequestControllerProvider.overrideWith(
          () => spyIpPrint ?? SpyIpPrintSaleRequest(),
        ),
        saleRequestDetailsStateControllerProvider.overrideWith(
          () => FakeSaleRequestDetails(fakeBSFSaleRequest),
        ),
      ],
    );
  }

  group('Soap print sale request', () {
    test(
      'should call repository, return true and update IP controller on success',
      () async {
        // ARRANGE
        final spyIpPrint = SpyIpPrintSaleRequest();

        // Update overrides for this specific test
        final container = makeProviderContainer(
          session: fakeSession,
          spyIpPrint: spyIpPrint,
        );

        when(
          () => mockRepository.soapPrint(
            saleRequest: any(named: 'saleRequest'),
            ip: any(named: 'ip'),
            userName: any(named: 'userName'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        final states = <AsyncValue<void>>[];
        container.listen(
          printSaleRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        final printed = await container
            .read(printSaleRequestControllerProvider.notifier)
            .soapPrint(ip);

        // ASSERT
        expect(printed, isTrue);
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // 1. Verify repository was called
        verify(
          () => mockRepository.soapPrint(
            saleRequest: fakeSoapSaleRequest,
            ip: ip,
            userName: fakeSession.user.name!,
          ),
        ).called(1);

        // 2. Verify IP controller was updated
        expect(spyIpPrint.updatedIp, ip);
      },
    );

    test(
      'should emit [loading, error] if last saved request is null',
      () async {
        // ARRANGE
        final spyIpPrint = SpyIpPrintSaleRequest();

        final container = makeProviderContainer(
          session: fakeSession,
          returnNullLastSavedSaleRequest: true,
          spyIpPrint: spyIpPrint,
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          printSaleRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        final printed = await container
            .read(printSaleRequestControllerProvider.notifier)
            .soapPrint(ip);

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
          () => mockRepository.soapPrint(
            saleRequest: any(named: 'saleRequest'),
            ip: any(named: 'ip'),
            userName: any(named: 'userName'),
          ),
        );
        expect(spyIpPrint.updatedIp, isNull);
      },
    );

    test('should emit [loading, error] if session is invalid', () async {
      final container = makeProviderContainer(session: null);

      final states = <AsyncValue<void>>[];
      container.listen(
        printSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      final printed = await container
          .read(printSaleRequestControllerProvider.notifier)
          .soapPrint(ip);

      // ASSERT
      expect(printed, isFalse);
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
    test('should emit [loading, error] if print fails', () async {
      when(
        () => mockRepository.soapPrint(
          saleRequest: any(named: 'saleRequest'),
          ip: any(named: 'ip'),
          userName: any(named: 'userName'),
        ),
      ).thenThrow(Exception());

      final container = makeProviderContainer(session: fakeSession);

      final states = <AsyncValue<void>>[];
      container.listen(
        printSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      final printed = await container
          .read(printSaleRequestControllerProvider.notifier)
          .soapPrint(ip);

      // ASSERT
      expect(printed, isFalse);
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
  group('BSF print sale request', () {
    test('should behave correctly on success', () async {
      // ARRANGE
      final spyIpPrint = SpyIpPrintSaleRequest();

      final container = makeProviderContainer(
        spyIpPrint: spyIpPrint,
        session: fakeSession,
      );

      when(
        () => mockRepository.bsfPrint(
          saleRequest: any(named: 'saleRequest'),
          ip: any(named: 'ip'),
          userName: any(named: 'userName'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(Duration.zero);
      });

      final states = <AsyncValue<void>>[];
      container.listen(
        printSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      final printed = await container
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: saleRequestCode,
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            ip: ip,
          );

      // ASSERT
      expect(printed, isTrue);
      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

      // 1. Verify repository was called
      verify(
        () => mockRepository.bsfPrint(
          saleRequest: fakeBSFSaleRequest,
          ip: ip,
          userName: fakeSession.user.name!,
        ),
      ).called(1);

      // 2. Verify IP controller was updated
      expect(spyIpPrint.updatedIp, ip);
    });

    test('should emit [loading, error] if session is invalid', () async {
      // ARRANGE

      final container = makeProviderContainer(session: fakeSession);

      final states = <AsyncValue<void>>[];
      container.listen(
        printSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      final printed = await container
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: saleRequestCode,
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            ip: ip,
          );

      // ASSERT
      expect(printed, isFalse);
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
    test('should emit [loading, error] if print fails', () async {
      when(
        () => mockRepository.soapPrint(
          saleRequest: any(named: 'saleRequest'),
          ip: any(named: 'ip'),
          userName: any(named: 'userName'),
        ),
      ).thenThrow(Exception());

      // ARRANGE
      final container = makeProviderContainer(session: fakeSession);

      final states = <AsyncValue<void>>[];
      container.listen(
        printSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      final printed = await container
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: saleRequestCode,
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            ip: ip,
          );

      // ASSERT
      expect(printed, isFalse);
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}

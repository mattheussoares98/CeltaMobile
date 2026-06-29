import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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

class FakeSaleRequestDetails extends SaleRequestDetailsStateController {
  final BSFSaleRequestEntity requestToReturn;
  FakeSaleRequestDetails(this.requestToReturn);
  @override
  FutureOr<BSFSaleRequestEntity> build(SaleRequestArgs args) => requestToReturn;
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
  late BSFSaleRequestEntity fakeBSFSaleRequest;
  late String ip;
  late int saleRequestCode;
  late int customerCode;
  late int enterpriseCode;
  late SaleRequestArgs fakeArgs;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());

    mockRepository = MockPrintSaleRequest();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    ip = faker.internet.ipv4Address();
    saleRequestCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    enterpriseCode = faker.randomGenerator.integer(100);

    fakeBSFSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    fakeArgs = SaleRequestArgs(
      customerCode: customerCode,
      saleRequestId: saleRequestCode,
      enterpriseCode: enterpriseCode,
    );
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
        saleRequestArgsProvider.overrideWithValue(fakeArgs),
        printSaleRequestRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        ipPrintSaleRequestControllerProvider.overrideWith(
          () => spyIpPrint ?? SpyIpPrintSaleRequest(),
        ),
        saleRequestDetailsStateControllerProvider(
          fakeArgs,
        ).overrideWith(() => FakeSaleRequestDetails(fakeBSFSaleRequest)),
      ],
    );
  }

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
      await container
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: saleRequestCode,
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            ip: ip,
          );

      // ASSERT
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
      await container
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: saleRequestCode,
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            ip: ip,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}

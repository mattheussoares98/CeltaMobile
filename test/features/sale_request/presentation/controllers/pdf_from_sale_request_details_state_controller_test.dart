import 'dart:async';
import 'dart:typed_data';

import 'package:celta_inventario/core/domain/entities/entities.dart';
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

// --- Fakes and Mocks for Dependencies ---

class FakeSaleRequestDetails extends SaleRequestDetailsStateController {
  final BSFSaleRequestEntity requestToReturn;
  FakeSaleRequestDetails(this.requestToReturn);

  @override
  FutureOr<BSFSaleRequestEntity> build(SaleRequestArgs args) => requestToReturn;
}

class MockGeneratePdfRepository extends Mock
    implements IGeneratePdfRepository {}

void main() {
  late MockGeneratePdfRepository mockRepository;
  late EnterpriseEntity fakeEnterprise;
  late BSFSaleRequestEntity saleRequest;
  late Uint8List fakePdfBytes;
  late SaleRequestArgs fakeArgs;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());
  });

  setUp(() {
    mockRepository = MockGeneratePdfRepository();
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    saleRequest = EntityFactory.makeBSFSaleRequestEntity();
    fakePdfBytes = Uint8List.fromList([1, 2, 3]);

    fakeArgs = SaleRequestArgs(
      customerCode: faker.randomGenerator.integer(100),
      saleRequestId: faker.randomGenerator.integer(100),
      enterpriseCode: faker.randomGenerator.integer(100),
    );
  });

  ProviderContainer makeProviderContainer({
    required BSFSaleRequestEntity lastSaved,
    EnterpriseEntity? enterprise,
  }) {
    // We create a new container for each test to avoid keepAlive conflicts
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        saleRequestArgsProvider.overrideWithValue(fakeArgs),
        generatePdfRepositoryProvider.overrideWithValue(mockRepository),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
        // We override the family provider instance we expect to be called
        if (enterprise != null)
          saleRequestDetailsStateControllerProvider.overrideWith(
            () => FakeSaleRequestDetails(lastSaved),
          ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Build', () {
    test('should return Uint8List and call repository on success', () async {
      // ARRANGE
      when(
        () => mockRepository.bsfGeneration(any()),
      ).thenAnswer((_) async => fakePdfBytes);

      final container = makeProviderContainer(
        enterprise: fakeEnterprise,
        lastSaved: saleRequest,
      );

      // ACT
      final result = await container.read(
        pdfFromSaleRequestDetailsStateControllerProvider.future,
      );

      // ASSERT
      expect(result, fakePdfBytes);
      // Verify the repository was called with the correct data
      verify(() => mockRepository.bsfGeneration(saleRequest)).called(1);
    });

    test('should throw error if repository.generate fails', () async {
      // ARRANGE
      final exception = Exception();
      when(() => mockRepository.bsfGeneration(any())).thenThrow(exception);

      final container = makeProviderContainer(
        enterprise: fakeEnterprise,
        lastSaved: saleRequest,
      );

      // ACT & ASSERT
      await expectLater(
        container.read(pdfFromSaleRequestDetailsStateControllerProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });
}

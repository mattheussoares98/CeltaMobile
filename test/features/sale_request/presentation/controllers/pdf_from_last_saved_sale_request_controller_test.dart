import 'dart:typed_data';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class FakeLastSavedSaleRequest extends LastSavedSaleRequestStateController {
  final LastSavedSaleRequestEntity? requestToReturn;
  FakeLastSavedSaleRequest(this.requestToReturn);
  @override
  Future<LastSavedSaleRequestEntity?> build(int enterpriseCode) async {
    return requestToReturn;
  }
}

class MockGeneratePdfRepository extends Mock
    implements IGeneratePdfRepository {}

void main() {
  late MockGeneratePdfRepository mockRepository;
  late EnterpriseEntity fakeEnterprise;
  late LastSavedSaleRequestEntity fakeLastSavedRequest;
  late Uint8List fakePdfBytes;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeLastSavedSaleRequestEntity());
  });

  setUp(() {
    mockRepository = MockGeneratePdfRepository();
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeLastSavedRequest = EntityFactory.makeLastSavedSaleRequestEntity();
    fakePdfBytes = Uint8List.fromList([1, 2, 3]);
  });

  ProviderContainer makeProviderContainer({
    EnterpriseEntity? enterprise,
    LastSavedSaleRequestEntity? lastSaved,
  }) {
    // We create a new container for each test to avoid keepAlive conflicts
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        generatePdfRepositoryProvider.overrideWithValue(mockRepository),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
        // We override the family provider instance we expect to be called
        if (enterprise != null)
          lastSavedSaleRequestStateControllerProvider(
            enterprise.Code!,
          ).overrideWith(() => FakeLastSavedSaleRequest(lastSaved)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('PdfFromLastSavedSaleRequest', () {
    test('should return Uint8List and call repository on success', () async {
      // ARRANGE
      when(
        () => mockRepository.soapGeneration(any()),
      ).thenAnswer((_) async => fakePdfBytes);

      final container = makeProviderContainer(
        enterprise: fakeEnterprise,
        lastSaved: fakeLastSavedRequest,
      );

      // ACT
      final result = await container.read(
        pdfFromLastSavedSaleRequestControllerProvider.future,
      );

      // ASSERT
      expect(result, fakePdfBytes);
      // Verify the repository was called with the correct data
      verify(
        () => mockRepository.soapGeneration(fakeLastSavedRequest),
      ).called(1);
    });

    test('should throw AppException if last saved request is null', () async {
      // ARRANGE
      when(
        () => mockRepository.soapGeneration(any()),
      ).thenAnswer((_) async => fakePdfBytes);

      final container = makeProviderContainer(
        enterprise: fakeEnterprise,
        lastSaved: null, // Simulate no saved request
      );

      // ACT & ASSERT
      await expectLater(
        container.read(pdfFromLastSavedSaleRequestControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      // Verify the PDF repository was never called
      verifyNever(() => mockRepository.soapGeneration(any()));
    });

    test('should throw Error if selected enterprise is null', () async {
      // ARRANGE
      final container = makeProviderContainer(
        enterprise: null, // Simulate no enterprise selected
        lastSaved: fakeLastSavedRequest,
      );

      // ACT & ASSERT
      await expectLater(
        container.read(pdfFromLastSavedSaleRequestControllerProvider.future),
        // This will be a "Null check operator used on a null value" error
        throwsA(isA<Error>()),
      );
    });

    test('should throw error if repository.generate fails', () async {
      // ARRANGE
      final exception = Exception();
      when(() => mockRepository.soapGeneration(any())).thenThrow(exception);

      final container = makeProviderContainer(
        enterprise: fakeEnterprise,
        lastSaved: fakeLastSavedRequest,
      );

      // ACT & ASSERT
      await expectLater(
        container.read(pdfFromLastSavedSaleRequestControllerProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });
}

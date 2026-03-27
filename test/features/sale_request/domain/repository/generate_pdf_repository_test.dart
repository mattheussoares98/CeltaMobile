import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapGeneratePdfDatasourceSpy extends Mock
    implements ISoapGeneratePdfDatasource {
  void mockGenerate(Uint8List response) {
    when(() => this.generate(any())).thenAnswer((_) async => response);
  }
}

class BSFGeneratePdfDatasourceSpy extends Mock
    implements IBSFGeneratePdfDatasource {
  void mockGenerate(Uint8List response) {
    when(() => this.generate(any())).thenAnswer((_) async => response);
  }
}

void main() {
  late IGeneratePdfRepository sut;
  late SoapGeneratePdfDatasourceSpy mockSoapDatasource;
  late BSFGeneratePdfDatasourceSpy mockBSFDatasource;

  late LastSavedSaleRequestEntity soapSaleRequest;
  late BSFSaleRequestEntity bsfSaleRequest;
  late Uint8List generatedPdf;

  setUp(() {
    mockSoapDatasource = SoapGeneratePdfDatasourceSpy();
    mockBSFDatasource = BSFGeneratePdfDatasourceSpy();
    sut = GeneratePdfRepositoryImpl(mockSoapDatasource, mockBSFDatasource);

    generatedPdf = Uint8List.fromList([1, 2, 3, 4, 5]);
    soapSaleRequest = EntityFactory.makeLastSavedSaleRequestEntity();
    bsfSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    mockSoapDatasource.mockGenerate(generatedPdf);
    mockBSFDatasource.mockGenerate(generatedPdf);
  });

  setUpAll(() {
    registerFallbackValue(
      SoapLastSavedSaleRequestModel.fromEntity(
        EntityFactory.makeLastSavedSaleRequestEntity(),
      ),
    );
    registerFallbackValue(
      BSFSaleRequestModel.fromEntity(EntityFactory.makeBSFSaleRequestEntity()),
    );
  });

  test('should behave correctly on soap generation', () async {
    final response = await sut.soapGeneration(soapSaleRequest);

    expect(response, generatedPdf);

    verify(
      () => mockSoapDatasource.generate(
        SoapLastSavedSaleRequestModel.fromEntity(soapSaleRequest),
      ),
    ).called(1);
  });

  test('should behave correctly on bsf generation', () async {
    final response = await sut.bsfGeneration(bsfSaleRequest);

    expect(response, generatedPdf);

    verify(
      () => mockBSFDatasource.generate(
        BSFSaleRequestModel.fromEntity(bsfSaleRequest),
      ),
    ).called(1);
  });
}

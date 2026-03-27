import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class GeneratePdfDatasourceSpy extends Mock implements ISoapGeneratePdfDatasource {
  void mockGenerate(Uint8List response) {
    when(() => this.generate(any())).thenAnswer((_) async => response);
  }
}

void main() {
  late IGeneratePdfRepository sut;
  late GeneratePdfDatasourceSpy mockDatasource;

  late LastSavedSaleRequestEntity saleRequest;
  late Uint8List generatedPdf;

  setUp(() {
    mockDatasource = GeneratePdfDatasourceSpy();
    sut = GeneratePdfRepositoryImpl(mockDatasource);

    generatedPdf = Uint8List.fromList([1, 2, 3, 4, 5]);
    saleRequest = EntityFactory.makeLastSavedSaleRequestEntity();
    mockDatasource.mockGenerate(generatedPdf);
  });

  setUpAll(() {
    registerFallbackValue(
      SoapLastSavedSaleRequestModel.fromEntity(
        EntityFactory.makeLastSavedSaleRequestEntity(),
      ),
    );
  });

  test('should behave correctly on save', () async {
    final response = await sut.generate(saleRequest);

    expect(response, generatedPdf);

    verify(
      () => mockDatasource.generate(
        SoapLastSavedSaleRequestModel.fromEntity(saleRequest),
      ),
    ).called(1);
  });
}

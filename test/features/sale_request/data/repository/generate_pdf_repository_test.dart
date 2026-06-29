import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class BSFGeneratePdfDatasourceSpy extends Mock
    implements IBSFGeneratePdfDatasource {
  void mockGenerate(Uint8List response) {
    when(() => this.generate(any())).thenAnswer((_) async => response);
  }
}

void main() {
  late IGeneratePdfRepository sut;
  late BSFGeneratePdfDatasourceSpy mockBSFDatasource;

  late BSFSaleRequestEntity bsfSaleRequest;
  late Uint8List generatedPdf;

  setUp(() {
    mockBSFDatasource = BSFGeneratePdfDatasourceSpy();
    sut = GeneratePdfRepositoryImpl(mockBSFDatasource);

    generatedPdf = Uint8List.fromList([1, 2, 3, 4, 5]);
    bsfSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    mockBSFDatasource.mockGenerate(generatedPdf);
  });

  setUpAll(() {
    registerFallbackValue(
      BSFSaleRequestModel.fromEntity(EntityFactory.makeBSFSaleRequestEntity()),
    );
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

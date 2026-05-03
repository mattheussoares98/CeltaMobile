import 'package:flutter/foundation.dart';

import '../datasource/datasource.dart';
import '../models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class GeneratePdfRepositoryImpl implements IGeneratePdfRepository {
  final ISoapGeneratePdfDatasource soapDatasource;
  final IBSFGeneratePdfDatasource bsfDatasource;

  GeneratePdfRepositoryImpl(this.soapDatasource, this.bsfDatasource);

  @override
  Future<Uint8List> soapGeneration(
    LastSavedSaleRequestEntity saleRequest,
  ) async {
    return await soapDatasource.generate(
      SoapLastSavedSaleRequestModel.fromEntity(saleRequest),
    );
  }

  @override
  Future<Uint8List> bsfGeneration(BSFSaleRequestEntity saleRequest) async {
    return await bsfDatasource.generate(
      BSFSaleRequestModel.fromEntity(saleRequest),
    );
  }
}

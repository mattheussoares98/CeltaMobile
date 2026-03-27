import 'package:flutter/foundation.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

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

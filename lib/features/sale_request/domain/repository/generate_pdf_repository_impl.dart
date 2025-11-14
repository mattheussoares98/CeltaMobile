import 'package:flutter/foundation.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class GeneratePdfRepositoryImpl implements IGeneratePdfRepository {
  final IGeneratePdfDatasource datasource;

  GeneratePdfRepositoryImpl(this.datasource);

  @override
  Future<Uint8List> generate(LastSavedSaleRequestEntity saleRequest) async {
    return await datasource.generate(
      LastSavedSaleRequestModel.fromEntity(saleRequest),
    );
  }
}

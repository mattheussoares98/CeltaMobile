import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:flutter/foundation.dart';

class GeneratePdfRepositoryImpl implements IGeneratePdfRepository {
  final IBSFGeneratePdfDatasource bsfDatasource;

  GeneratePdfRepositoryImpl(this.bsfDatasource);

  @override
  Future<Uint8List> bsfGeneration(BSFSaleRequestEntity saleRequest) async {
    return await bsfDatasource.generate(
      BSFSaleRequestModel.fromEntity(saleRequest),
    );
  }
}

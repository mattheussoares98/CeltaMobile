import 'dart:typed_data';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class IGeneratePdfRepository {
  Future<Uint8List> soapGeneration(LastSavedSaleRequestEntity saleRequest);
  Future<Uint8List> bsfGeneration(BSFSaleRequestEntity saleRequest);
}

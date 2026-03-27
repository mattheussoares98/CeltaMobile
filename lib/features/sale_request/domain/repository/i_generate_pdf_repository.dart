import 'dart:typed_data';

import '../entities/entities.dart';

abstract class IGeneratePdfRepository {
  Future<Uint8List> soapGeneration(LastSavedSaleRequestEntity saleRequest);
  Future<Uint8List> bsfGeneration(BSFSaleRequestEntity saleRequest);
}

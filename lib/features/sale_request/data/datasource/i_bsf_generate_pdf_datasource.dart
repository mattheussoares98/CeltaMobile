import 'dart:typed_data';

import '../models/models.dart';

abstract class IBSFGeneratePdfDatasource {
  Future<Uint8List> generate(BSFSaleRequestModel saleRequest);
}

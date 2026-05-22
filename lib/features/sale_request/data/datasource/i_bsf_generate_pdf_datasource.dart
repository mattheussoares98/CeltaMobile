import 'dart:typed_data';

import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class IBSFGeneratePdfDatasource {
  Future<Uint8List> generate(BSFSaleRequestModel saleRequest);
}

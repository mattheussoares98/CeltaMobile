import 'dart:typed_data';

import '../models/models.dart';

abstract class IGeneratePdfDatasource {
  Future<Uint8List> generate(SoapLastSavedSaleRequestModel saleRequest);
}

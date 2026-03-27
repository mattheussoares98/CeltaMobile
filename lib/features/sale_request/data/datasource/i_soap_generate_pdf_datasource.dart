import 'dart:typed_data';

import '../models/models.dart';

abstract class ISoapGeneratePdfDatasource {
  Future<Uint8List> generate(SoapLastSavedSaleRequestModel saleRequest);
}

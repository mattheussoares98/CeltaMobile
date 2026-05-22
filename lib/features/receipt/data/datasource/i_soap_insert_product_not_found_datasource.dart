import 'package:celta_inventario/features/receipt/data/model/model.dart';

abstract class ISoapInsertProductNotFoundDatasource {
  Future<void> insert({
    required String workingUrl,
    required String crossIdentity,
    required ProductNotFoundModel productNotFound,
    required int receiptCode,
  });
}

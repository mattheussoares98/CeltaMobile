import '../model/model.dart';

abstract class ISoapInsertProductNotFoundDatasource {
  Future<void> insert({
    required String baseUrl,
    required String crossIdentity,
    required ProductNotFoundModel productNotFound,
    required int receiptCode,
  });
}

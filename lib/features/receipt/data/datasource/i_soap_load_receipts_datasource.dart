import '../model/model.dart';

abstract class ISoapLoadReceiptsDatasource {
  Future<List<ReceiptModel>> loadReceipts({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}

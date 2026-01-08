import '../model/model.dart';

abstract class ISoapLoadReceiptsDatasource {
  Future<List<ReceiptModel>> loadReceipts({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}

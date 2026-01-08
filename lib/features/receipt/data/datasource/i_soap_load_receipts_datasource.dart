import '../model/model.dart';

abstract class ISoapLoadReceiptsDatasource {
  Future<List<ReceiptModel>> loadReceipts({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  });
}

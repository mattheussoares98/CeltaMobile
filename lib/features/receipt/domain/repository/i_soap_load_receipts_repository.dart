import '../entity/entity.dart';

abstract class ISoapLoadReceiptsRepository {
  Future<List<ReceiptEntity>> loadReceipts({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}

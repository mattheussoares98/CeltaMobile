import '../entity/entity.dart';

abstract class ISoapLoadReceiptsRepository {
  Future<List<ReceiptEntity>> loadReceipts({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  });
}

import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

abstract class ISoapLoadReceiptsRepository {
  Future<List<ReceiptEntity>> loadReceipts({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}

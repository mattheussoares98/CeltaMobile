import 'package:celta_inventario/features/receipt/domain/entity/receipt_entity.dart';

import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';
import 'package:celta_inventario/features/receipt/domain/repository/repository.dart';

class SoapLoadReceiptsRepositoryImpl implements ISoapLoadReceiptsRepository {
  final ISoapLoadReceiptsDatasource datasource;

  const SoapLoadReceiptsRepositoryImpl(this.datasource);

  @override
  Future<List<ReceiptEntity>> loadReceipts({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.loadReceipts(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

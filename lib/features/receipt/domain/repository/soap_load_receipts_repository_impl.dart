import 'package:celta_intelligence/features/receipt/domain/entity/receipt_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadReceiptsRepositoryImpl implements ISoapLoadReceiptsRepository {
  final ISoapLoadReceiptsDatasource datasource;

  const SoapLoadReceiptsRepositoryImpl(this.datasource);

  @override
  Future<List<ReceiptEntity>> loadReceipts({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.loadReceipts(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

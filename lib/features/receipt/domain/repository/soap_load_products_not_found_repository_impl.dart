import 'package:celta_intelligence/features/receipt/domain/entity/product_not_found_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadProductsNotFoundRepositoryImpl
    implements ISoapLoadProductsNotFoundRepository {
  final ISoapLoadProductsNotFoundDatasource datasource;
  SoapLoadProductsNotFoundRepositoryImpl(this.datasource);

  @override
  Future<List<ProductNotFoundEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int receiptCode,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      receiptCode: receiptCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

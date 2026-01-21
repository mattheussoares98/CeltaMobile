import 'package:celta_inventario/features/receipt/domain/entity/product_not_found_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadProductsNotFoundRepositoryImpl
    implements ISoapLoadProductsNotFoundRepository {
  final ISoapLoadProductsNotFoundDatasource datasource;
  SoapLoadProductsNotFoundRepositoryImpl(this.datasource);

  @override
  Future<List<ProductNotFoundEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int receiptCode,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      receiptCode: receiptCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

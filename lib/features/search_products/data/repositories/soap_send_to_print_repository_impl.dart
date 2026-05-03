import '../datasource/datasource.dart';
import 'package:celta_inventario/features/search_products/domain/repositories/repositories.dart';

class SoapSendToPrintRepositoryImpl implements ISoapSendToPrintRepository {
  final ISoapSendToPrintDatasource datasource;
  SoapSendToPrintRepositoryImpl(this.datasource);

  @override
  Future<void> send({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productPackingCode,
    required bool newValue,
  }) async {
    await datasource.send(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productPackingCode: productPackingCode,
      newValue: newValue,
    );
  }
}

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapSendToPrintRepositoryImpl implements ISoapSendToPrintRepository {
  final ISoapSendToPrintDatasource datasource;
  SoapSendToPrintRepositoryImpl(this.datasource);

  @override
  Future<void> send({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productPackingCode,
    required bool newValue,
  }) async {
    await datasource.send(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productPackingCode: productPackingCode,
      newValue: newValue,
    );
  }
}

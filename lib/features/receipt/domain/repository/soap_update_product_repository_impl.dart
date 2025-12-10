import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapUpdateProductRepositoryImpl implements ISoapUpdateProductRepository {
  final ISoapUpdateProductDatasource datasource;
  SoapUpdateProductRepositoryImpl(this.datasource);

  @override
  Future<void> update({
    required String baseUrl,
    required String crossIdentity,
    required int grDocCode,
    required int productCode,
    required int productPackingCode,
    required double newQuantity,
    required DateTime? newValidityDate,
  }) async {
    final parametersPayload = {
      "crossIdentity": crossIdentity,
      "grDocCode": grDocCode,
      "productgCode": productCode,
      "productPackingCode": productPackingCode,
      "quantity": newQuantity,
      "validityDate": newValidityDate?.toIso8601String(),
    };

    await datasource.update(
      baseUrl: baseUrl,
      parametersPayload: parametersPayload,
    );
  }
}

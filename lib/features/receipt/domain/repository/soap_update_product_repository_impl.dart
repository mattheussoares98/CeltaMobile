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
    required int productgCode,
    required int productPackingCode,
    double? newQuantity,
    DateTime? newValidityDate,
  }) async {
    final parametersPayload = {
      "crossIdentity": crossIdentity,
      "grDocCode": grDocCode,
      "productgCode": productgCode,
      "productPackingCode": productPackingCode,
      if (newQuantity != null) "quantity": newQuantity,
      if (newValidityDate != null)
        "validityDate": newValidityDate.toIso8601String(),
    };

    await datasource.update(
      baseUrl: baseUrl,
      parametersPayload: parametersPayload,
    );
  }
}

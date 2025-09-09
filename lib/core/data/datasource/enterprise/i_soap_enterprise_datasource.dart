import '../../models/models.dart';

abstract class ISoapEnterpriseDataSource {
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String baseUrl,
    required String crossIdentity,
  });
}

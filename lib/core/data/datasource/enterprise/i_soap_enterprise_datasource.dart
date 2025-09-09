import '../../models/models.dart';

abstract class ISoapEnterpriseDataSource {
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String url,
    required String crossIdentity,
  });
}

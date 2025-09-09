import '../../data/models/models.dart';

abstract class IEnterpriseRepository {
  Future<EnterpriseModel?> getEnterpriseByName(String name);
}

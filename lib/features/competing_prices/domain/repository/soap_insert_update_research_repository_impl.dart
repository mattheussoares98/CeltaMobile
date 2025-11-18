import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapInsertUpdateResearchRepositoryImpl
    implements ISoapInsertUpdateResearchRepository {
  final ISoapInsertUpdateResearchDatasource datasource;
  SoapInsertUpdateResearchRepositoryImpl(this.datasource);

  @override
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    int? researchCode,
    String? observations,
  }) async {
    await datasource.insertUpdate(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      name: name,
      observations: observations,
      researchCode: researchCode,
    );
  }
}

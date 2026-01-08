import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class SoapLoadCovenantsRepositoryImpl implements ISoapLoadCovenantsRepository {
  final ISoapLoadCovenantsDatasource datasource;
  SoapLoadCovenantsRepositoryImpl(this.datasource);

  @override
  Future<List<CovenantEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue,
  }) async {
    final response = await datasource.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      searchCovenantType: searchCovenantType,
      searchValue: searchValue,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

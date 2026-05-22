import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/domain/repositories/repositories.dart';

class SoapLoadCovenantsRepositoryImpl implements ISoapLoadCovenantsRepository {
  final ISoapLoadCovenantsDatasource datasource;
  SoapLoadCovenantsRepositoryImpl(this.datasource);

  @override
  Future<List<CovenantEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      searchCovenantType: searchCovenantType,
      searchValue: searchValue,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

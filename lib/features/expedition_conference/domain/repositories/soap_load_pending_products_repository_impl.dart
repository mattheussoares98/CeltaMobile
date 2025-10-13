import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class SoapLoadPendingProductsRepositoryImpl
    implements ISoapLoadPendingProductsRepository {
  final ISoapLoadPendingProductsDatasource datasource;
  SoapLoadPendingProductsRepositoryImpl(this.datasource);

  @override
  Future<List<ExpeditionProductEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  }) async {
    final result = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
    );

    return result.map((e) => e.toEntity()).toList();
  }
}

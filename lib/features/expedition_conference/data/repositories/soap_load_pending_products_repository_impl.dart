import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/domain/repositories/repositories.dart';

class SoapLoadPendingProductsRepositoryImpl
    implements ISoapLoadPendingProductsRepository {
  final ISoapLoadPendingProductsDatasource datasource;
  SoapLoadPendingProductsRepositoryImpl(this.datasource);

  @override
  Future<List<ExpeditionProductEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  }) async {
    final result = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
    );

    return result.map((e) => e.toEntity()).toList();
  }
}

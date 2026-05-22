import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class EcSellerRepositoryImpl implements IEcSellerRepository {
  final IEcSellerDatasource datasource;
  EcSellerRepositoryImpl(this.datasource);

  @override
  Future<List<EcSellerEntity>> get(EcRequestParams params) async {
    final models = await datasource.get(params);
    return models.map((e) => e.toEntity()).toList();
  }
}

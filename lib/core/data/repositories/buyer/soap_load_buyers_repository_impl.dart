import 'package:celta_inventario/core/data/datasource/buyer/buyer.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/buyer/buyer.dart';

class SoapLoadBuyersRepositoryImpl implements ISoapLoadBuyersRepository {
  final ISoapLoadBuyersDatasource datasource;
  SoapLoadBuyersRepositoryImpl(this.datasource);

  @override
  Future<List<BuyerEntity>> load({
    required String workingUrl,
    required String crossIdentity,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

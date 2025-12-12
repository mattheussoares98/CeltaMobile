import '../../../../core/data/datasource/buyer/buyer.dart';
import '../../../../core/domain/entities/entities.dart';
import 'repository.dart';

class SoapLoadBuyersRepositoryImpl implements ISoapLoadBuyersRepository {
  final ISoapLoadBuyersDatasource datasource;
  SoapLoadBuyersRepositoryImpl(this.datasource);

  @override
  Future<List<BuyerEntity>> load({
    required String baseUrl,
    required String crossIdentity,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

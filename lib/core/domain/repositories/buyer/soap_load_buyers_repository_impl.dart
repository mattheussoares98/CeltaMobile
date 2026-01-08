import '../../../data/datasource/buyer/buyer.dart';
import '../../entities/entities.dart';
import 'buyer.dart';

class SoapLoadBuyersRepositoryImpl implements ISoapLoadBuyersRepository {
  final ISoapLoadBuyersDatasource datasource;
  SoapLoadBuyersRepositoryImpl(this.datasource);

  @override
  Future<List<BuyerEntity>> load({
    required String urlInUse,
    required String crossIdentity,
  }) async {
    final response = await datasource.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

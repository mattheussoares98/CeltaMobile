import '../../../data/datasource/buyer/buyer.dart';
import '../../entities/entities.dart';
import 'buyer.dart';

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

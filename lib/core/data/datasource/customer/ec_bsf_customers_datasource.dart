import '../../../domain/contracts/contracts.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';
import 'customer.dart';

class EcBSFCustomersDatasource implements IEcBSFCustomersDatasource {
  final HttpClient httpClient;

  EcBSFCustomersDatasource(this.httpClient);

  @override
  Future<List<BSFCustomerModel>> searchForMobileApp({
    required EcRequestParams params,
    required String searchValue,
    required int enterpriseCode,
    required bool searchByPersonalizedCode,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/Customers/SearchForMobileApp',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'SearchValue': searchValue,
        'EnterpriseCode': enterpriseCode,
        'SearchByPersonalizedCode': searchByPersonalizedCode,
      },
    );

    if (response == null) return [];

    return (response as List)
        .map((e) => BSFCustomerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

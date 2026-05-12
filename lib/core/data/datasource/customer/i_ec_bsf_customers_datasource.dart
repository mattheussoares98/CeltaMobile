import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class IEcBSFCustomersDatasource {
  Future<List<BSFCustomerModel>> searchForMobileApp({
    required EcRequestParams params,
    required String searchValue,
    required int enterpriseCode,
    required bool searchByPersonalizedCode,
  });
}

import '../../../data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/domain/entities/request_type/request_type.dart';
import 'package:celta_inventario/core/domain/repositories/request_type/request_type.dart';

class SoapLoadRequestTypeRepositoryImpl
    implements ISoapLoadRequestTypeRepository {
  final ISoapLoadRequestTypeDatasource datasource;
  SoapLoadRequestTypeRepositoryImpl(this.datasource);

  @override
  Future<List<RequestTypeEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required bool inclusiveBuy,
    required bool inclusiveTransfer,
    required bool inclusiveSale,
    required int enterpriseCode,
  }) async {
    final result = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      inclusiveBuy: inclusiveBuy,
      inclusiveTransfer: inclusiveTransfer,
      inclusiveSale: inclusiveSale,
      enterpriseCode: enterpriseCode,
    );

    return result.map((e) => e.toEntity()).toList();
  }
}

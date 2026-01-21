import 'package:celta_inventario/features/buy_quotation/domain/entities/buy_quotation_entity.dart';

import 'package:celta_inventario/features/buy_quotation/domain/entities/search_buy_quotation_data_type.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadBuyQuotationsRepositoryImpl
    implements ISoapLoadBuyQuotationsRepository {
  final ISoapLoadBuyQuotationsDatasource datasource;
  SoapLoadBuyQuotationsRepositoryImpl(this.datasource);

  @override
  Future<List<BuyQuotationEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String? codeForFullSearch,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      isCompleteSearch: codeForFullSearch != null,
      searchValue: codeForFullSearch ?? '%',
      dataType: SearchBuyQuotationDataType.byPersonalizedCode,
      inclusiveExpired: false,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}

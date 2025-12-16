import 'package:celta_intelligence/features/buy_quotation/domain/entities/buy_quotation_entity.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import 'repository.dart';

class SoapInsertUpdateBuyQuotationRepositoryImpl
    implements ISoapInsertUpdateBuyQuotationRepository {
  final ISoapInsertUpdateBuyQuotationDatasource datasource;
  SoapInsertUpdateBuyQuotationRepositoryImpl(this.datasource);

  @override
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required BuyQuotationEntity buyQuotation,
  }) async {
    await datasource.insertUpdate(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      buyQuotation: BuyQuotationModel.fromEntity(
        buyQuotation.copyWith(
          Enterprises: buyQuotation.Enterprises?.map(
            (e) => e.copyWith(Code: e.Code ?? 0),
          ).toList(),
          Products: buyQuotation.Products?.map(
            (e) => e.copyWith(Code: e.Code ?? 0),
          ).toList(),
        ),
      ),
    );
  }
}

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
    required String urlInUse,
    required String crossIdentity,
    required BuyQuotationEntity buyQuotation,
    required DateTime now,
    required String? observations,
  }) async {
    final Set<int> currentlySelectedCodes =
        buyQuotation.Enterprises?.where(
          (e) => e.isSelected == true,
        ).map((e) => e.enterprise.Code!).toSet() ??
        {};

    final cleanedProducts = buyQuotation.Products?.map((product) {
      final existingProductEnterprises = product.ProductEnterprises;

      if (existingProductEnterprises == null) {
        return product;
      }

      final filteredProductEnterprises = existingProductEnterprises
          .where(
            (productEnterprise) => currentlySelectedCodes.contains(
              productEnterprise.EnterpriseCode,
            ),
          )
          .toList();

      return product.copyWith(ProductEnterprises: filteredProductEnterprises);
    }).toList();

    await datasource.insertUpdate(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      buyQuotation: BuyQuotationModel.fromEntity(
        buyQuotation.copyWith(
          Enterprises: buyQuotation.Enterprises?.map(
            (e) => e.copyWith(Code: e.Code ?? 0),
          ).toList().where((x) => x.isSelected == true).toList(),
          Products: cleanedProducts
              ?.map((e) => e.copyWith(Code: e.Code ?? 0))
              .toList(),
          Code: buyQuotation.Code ?? 0,
          DateOfCreation: buyQuotation.DateOfCreation ?? now,
          Observations: observations,
        ),
      ),
    );
  }
}

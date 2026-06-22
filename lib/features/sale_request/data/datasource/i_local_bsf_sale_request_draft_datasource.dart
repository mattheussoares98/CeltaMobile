import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class ILocalBSFSaleRequestDraftDatasource {
  Future<void> save(
    BSFSaleRequestModel value, {
    required int enterpriseCode,
    required int requestTypeCode,
  });

  Future<BSFSaleRequestModel?> load({
    required int enterpriseCode,
    required int requestTypeCode,
  });

  Future<void> clear({
    required int enterpriseCode,
    required int requestTypeCode,
  });
}

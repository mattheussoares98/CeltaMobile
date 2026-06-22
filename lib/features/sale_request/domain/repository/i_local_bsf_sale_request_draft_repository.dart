import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class ILocalBSFSaleRequestDraftRepository {
  Future<void> save(
    BSFSaleRequestEntity value, {
    required int enterpriseCode,
    required int requestTypeCode,
  });

  Future<BSFSaleRequestEntity?> load({
    required int enterpriseCode,
    required int requestTypeCode,
  });

  Future<void> clear({
    required int enterpriseCode,
    required int requestTypeCode,
  });
}

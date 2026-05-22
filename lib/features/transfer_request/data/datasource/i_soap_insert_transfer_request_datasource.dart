import 'package:celta_inventario/features/transfer_request/data/models/models.dart';

abstract class ISoapInsertTransferRequestDatasource {
  Future<String> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required List<TransferRequestProductItemModel> products,
  });
}
